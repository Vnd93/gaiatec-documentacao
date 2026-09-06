param(
  [Parameter(Mandatory = $true)]
  [string]$DocsRepo,

  [Parameter(Mandatory = $true)]
  [string]$CmsRepo,

  [Parameter(Mandatory = $true)]
  [string]$SiteRoot,

  [Parameter(Mandatory = $true)]
  [string]$OutputCsv,

  [Parameter(Mandatory = $true)]
  [string]$OutputSummaryJson
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$supportedExtensions = [Collections.Generic.HashSet[string]]::new(
  [string[]]@(".md", ".docx", ".pdf", ".json", ".png", ".zip"),
  [StringComparer]::OrdinalIgnoreCase
)
$textExtensions = [Collections.Generic.HashSet[string]]::new(
  [string[]]@(
    ".cjs",
    ".css",
    ".html",
    ".js",
    ".json",
    ".jsx",
    ".md",
    ".mjs",
    ".ps1",
    ".sh",
    ".sql",
    ".toml",
    ".ts",
    ".tsx",
    ".yaml",
    ".yml"
  ),
  [StringComparer]::OrdinalIgnoreCase
)

function ConvertTo-ForwardSlash([string]$Value) {
  return $Value.Replace("\", "/")
}

function Get-RelativePath([string]$Root, [string]$Path) {
  return ConvertTo-ForwardSlash ([IO.Path]::GetRelativePath($Root, $Path))
}

function Test-ExcludedPath([string]$Path) {
  $normalized = "/$(ConvertTo-ForwardSlash $Path)/"
  return $normalized -match "/(?:\.git|\.secrets|node_modules|\.codex-worktrees)(?:/|$)"
}

function Get-Sha256([string]$Path) {
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
}

function Get-GitValue([string]$Repository, [string[]]$Arguments) {
  $value = & git -C $Repository @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "git $($Arguments -join ' ') failed in $Repository"
  }
  return ($value | Out-String).Trim()
}

function Get-GitFiles([string]$Repository) {
  $paths = & git -C $Repository ls-files
  if ($LASTEXITCODE -ne 0) {
    throw "git ls-files failed in $Repository"
  }
  return @($paths | ForEach-Object { ConvertTo-ForwardSlash $_ })
}

function Get-GitBlobMap([string]$Repository) {
  $map = @{}
  $entries = & git -C $Repository ls-tree -r --full-tree HEAD
  if ($LASTEXITCODE -ne 0) {
    throw "git ls-tree failed in $Repository"
  }
  foreach ($entry in $entries) {
    $parts = $entry -split "`t", 2
    if ($parts.Count -ne 2) { continue }
    $metadata = $parts[0] -split " "
    if ($metadata.Count -lt 3) { continue }
    $map[(ConvertTo-ForwardSlash $parts[1])] = $metadata[2]
  }
  return $map
}

function Get-Category([string]$LogicalPath) {
  $path = $LogicalPath.ToLowerInvariant()
  if ($path -match "manual") { return "manual" }
  if ($path -match "evidenc|canary|probe|relatorio|auditoria|audit") { return "evidencia-auditoria" }
  if ($path -match "approval|aprovac|gate|controle|runbook|rollback|operacao|backup|restore") { return "controle-operacional" }
  if ($path -match "govern|legal|dpo|politica|origem|repositorio") { return "governanca-legal" }
  if ($path -match "adr|arquitet|threat|segur|csp|database|supabase") { return "arquitetura-seguranca" }
  if ($path -match "produto|requisito|especificacao|planejamento|decisoes") { return "produto-requisitos" }
  if ($path -match "site|public") { return "site-publico" }
  if ($path -match "cms|admin") { return "cms" }
  if ($path -match "modelo|template") { return "modelo" }
  if ($path -match "histor|original|legacy|source") { return "historico" }
  return "documentacao-geral"
}

function Get-TaxonomyDestination([string]$RelativePath, [string]$Category) {
  $name = [IO.Path]::GetFileName($RelativePath)
  switch ($Category) {
    "produto-requisitos" { return "docs/10-produto-requisitos/$name" }
    "arquitetura-seguranca" { return "docs/20-arquitetura-seguranca/$name" }
    "cms" { return "docs/30-cms/$name" }
    "site-publico" { return "docs/40-site-publico/$name" }
    "controle-operacional" { return "docs/50-operacao-entrega/$name" }
    "evidencia-auditoria" { return "docs/60-qualidade-auditoria/$name" }
    "governanca-legal" { return "docs/70-governanca-legal/$name" }
    "modelo" { return "docs/99-modelos/$name" }
    "manual" { return "docs/30-cms/manual-do-usuario/$name" }
    default { return "docs/90-historico/$name" }
  }
}

function Get-CanonicalDocsPath([string]$RelativePath, [string]$Category) {
  $normalized = ConvertTo-ForwardSlash $RelativePath
  if ($normalized.StartsWith("docs/ev2/", [StringComparison]::OrdinalIgnoreCase)) {
    return $normalized -replace "^docs/ev2/", "docs/80-evolucao/ev2/"
  }
  if ($normalized.StartsWith("docs/adr/", [StringComparison]::OrdinalIgnoreCase)) {
    return $normalized -replace "^docs/adr/", "docs/20-arquitetura-seguranca/adr/"
  }
  if ($normalized.StartsWith("docs/auditoria-cms-2026-09-01/", [StringComparison]::OrdinalIgnoreCase)) {
    return $normalized -replace "^docs/", "docs/60-qualidade-auditoria/"
  }
  if ($normalized.StartsWith("docs/fase-1/", [StringComparison]::OrdinalIgnoreCase)) {
    return $normalized -replace "^docs/fase-1/", "docs/90-historico/fase-1/"
  }
  if ($normalized -match "^docs/(fase-(?:0|[2-9]|10|11)/.+)$") {
    return "docs/90-historico/cms-fases-0-a-11/$($Matches[1])"
  }
  switch ($normalized) {
    "docs/api/README.md" { return "docs/30-cms/api.md" }
    "docs/database/README.md" { return "docs/20-arquitetura-seguranca/database.md" }
    "docs/operations/README.md" { return "docs/50-operacao-entrega/operacao-do-codigo.md" }
    default { return Get-TaxonomyDestination $normalized $Category }
  }
}

function Get-TextCorpus([string]$Repository) {
  $items = [Collections.Generic.List[object]]::new()
  foreach ($relativePath in (Get-GitFiles $Repository)) {
    if ($relativePath.StartsWith("docs/", [StringComparison]::OrdinalIgnoreCase)) { continue }
    if (Test-ExcludedPath $relativePath) { continue }
    $extension = [IO.Path]::GetExtension($relativePath)
    if (-not $textExtensions.Contains($extension)) { continue }
    $absolutePath = Join-Path $Repository $relativePath
    if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) { continue }
    if ((Get-Item -LiteralPath $absolutePath).Length -gt 4MB) { continue }
    try {
      $items.Add([pscustomobject]@{
          path    = $relativePath
          content = [IO.File]::ReadAllText($absolutePath)
        })
    }
    catch {
      # A file that cannot be decoded as text is irrelevant to literal reference scanning.
    }
  }
  return $items
}

function Get-Dependencies([string]$RelativePath, [object[]]$Corpus) {
  $needles = [Collections.Generic.List[string]]::new()
  $needles.Add((ConvertTo-ForwardSlash $RelativePath))
  $fileName = [IO.Path]::GetFileName($RelativePath)
  if ($fileName.Length -ge 12 -and $fileName -notmatch "^README\.md$") {
    $needles.Add($fileName)
  }

  $matches = [Collections.Generic.SortedSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
  foreach ($item in $Corpus) {
    foreach ($needle in $needles) {
      if ($item.content.IndexOf($needle, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
        [void]$matches.Add($item.path)
        break
      }
    }
  }
  return ($matches -join "; ")
}

function New-Record {
  param(
    [string]$SourcePath,
    [string]$Sha256,
    [long]$SizeBytes,
    [string]$SourceRepository,
    [string]$SourceCommit,
    [string]$Category,
    [string]$ProposedStatus,
    [string]$CanonicalDocument,
    [string]$RecommendedDestination,
    [string]$Action,
    [string]$Justification,
    [string]$Dependencies
  )
  return [pscustomobject][ordered]@{
    caminho_origem        = $SourcePath
    sha256                = $Sha256
    tamanho_bytes         = $SizeBytes
    repositorio_origem    = $SourceRepository
    commit_origem         = $SourceCommit
    categoria_documental  = $Category
    status_proposto       = $ProposedStatus
    documento_canonico    = $CanonicalDocument
    destino_recomendado   = $RecommendedDestination
    acao                   = $Action
    justificativa         = $Justification
    dependencias           = $Dependencies
  }
}

$docsRepo = (Resolve-Path -LiteralPath $DocsRepo).Path
$cmsRepo = (Resolve-Path -LiteralPath $CmsRepo).Path
$siteRoot = (Resolve-Path -LiteralPath $SiteRoot).Path
$docsCommit = Get-GitValue $docsRepo @("rev-parse", "HEAD")
$cmsCommit = Get-GitValue $cmsRepo @("rev-parse", "HEAD")
$docsBlobMap = Get-GitBlobMap $docsRepo
$cmsBlobMap = Get-GitBlobMap $cmsRepo
$cmsCorpus = @(Get-TextCorpus $cmsRepo)
$records = [Collections.Generic.List[object]]::new()

$originalCanonicalDestinations = @{
  "documentacao-original/Analise e Arquitetura do Site - GAIATEC SISTEMAS.md" = "gaiatec-documentacao:docs/20-arquitetura-seguranca/analise-e-arquitetura-do-site-gaiatec-sistemas.md"
  "documentacao-original/ATTRIBUTIONS.md" = "gaiatec-documentacao:docs/70-governanca-legal/atribuicoes.md"
  "documentacao-original/AUDIT-DELTA.md" = "gaiatec-documentacao:docs/60-qualidade-auditoria/audit-delta.md"
  "documentacao-original/AUDITORIA_CMS_GAIATEC.md" = "gaiatec-documentacao:docs/60-qualidade-auditoria/auditoria-cms-gaiatec.md"
  "documentacao-original/COMPLEMENTO_TECNICO_OPERACIONAL_AUDITORIA_CMS_GAIATEC.md" = "gaiatec-documentacao:docs/60-qualidade-auditoria/complemento-tecnico-operacional-auditoria-cms-gaiatec.md"
  "documentacao-original/guidelines/Guidelines.md" = "gaiatec-documentacao:docs/40-site-publico/guidelines.md"
  "documentacao-original/PROCEDIMENTO_AJUSTES_E_DESENVOLVIMENTO_PAINEL_ADMINISTRATIVO_GAIATEC.md" = "gaiatec-documentacao:docs/50-operacao-entrega/procedimento-ajustes-desenvolvimento-painel-administrativo-gaiatec.md"
  "documentacao-original/PROMPTS-IMAGENS-V2.md" = "gaiatec-documentacao:docs/99-modelos/prompts-imagens-v2.md"
  "documentacao-original/PROMPTS-IMAGENS.md" = "gaiatec-documentacao:docs/99-modelos/prompts-imagens.md"
  "documentacao-original/README_PROJETO_ORIGINAL.md" = "gaiatec-documentacao:docs/90-historico/indice.md"
}

$docsFiles = @(Get-GitFiles $docsRepo | Where-Object {
    $supportedExtensions.Contains([IO.Path]::GetExtension($_))
  })
$cmsFiles = @(Get-GitFiles $cmsRepo | Where-Object {
    $supportedExtensions.Contains([IO.Path]::GetExtension($_))
  })
$docsSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$cmsSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($path in $docsFiles) { [void]$docsSet.Add($path) }
foreach ($path in $cmsFiles) { [void]$cmsSet.Add($path) }

foreach ($relativePath in $docsFiles) {
  $absolutePath = Join-Path $docsRepo $relativePath
  $category = Get-Category $relativePath
  $isOriginal = $relativePath.StartsWith("documentacao-original/", [StringComparison]::OrdinalIgnoreCase)
  $isRootControl = $relativePath -in @("GOVERNANCA.md", "ORIGEM.md", "CONTROLES_REPOSITORIO.md")
  $destination = if ($relativePath.StartsWith("docs/ev2/", [StringComparison]::OrdinalIgnoreCase)) {
    $relativePath -replace "^docs/ev2/", "docs/80-evolucao/ev2/"
  }
  elseif ($relativePath.StartsWith("docs/adr/", [StringComparison]::OrdinalIgnoreCase)) {
    $relativePath -replace "^docs/adr/", "docs/20-arquitetura-seguranca/adr/"
  }
  elseif ($relativePath.StartsWith("docs/auditoria-cms-2026-09-01/", [StringComparison]::OrdinalIgnoreCase)) {
    $relativePath -replace "^docs/", "docs/60-qualidade-auditoria/"
  }
  elseif ($relativePath.StartsWith("docs/fase-1/", [StringComparison]::OrdinalIgnoreCase)) {
    $relativePath -replace "^docs/fase-1/", "docs/90-historico/fase-1/"
  }
  elseif ($isRootControl) {
    "docs/70-governanca-legal/$($relativePath.ToLowerInvariant().Replace('_', '-'))"
  }
  else {
    Get-TaxonomyDestination $relativePath $category
  }

  $counterpart = ""
  $status = "ativo"
  $action = "mover"
  $justification = "Documento oficial deve residir na taxonomia canonica do repositorio documental."
  if ($relativePath -eq "README.md") {
    $destination = "README.md"
    $action = "manter"
    $justification = "Indice de entrada do repositorio canonico."
  }
  elseif ($isOriginal) {
    $destination = "arquivo-historico:documentos-originais/gaiatec-documentacao/$relativePath"
    $status = "historico"
    $action = "arquivar"
    $justification = "Fonte original preservada fora do repositorio ativo apos validacao de hash e sucessor canonico."
  }
  elseif ($cmsSet.Contains($relativePath)) {
    $counterpart = "gaiatec-cms:$relativePath"
    if ($docsBlobMap[$relativePath] -eq $cmsBlobMap[$relativePath]) {
      $justification = "Conteudo Git identico nos dois repositorios; manter somente a copia canonica documental."
    }
    else {
      $status = "decisao-canonica"
      $action = "consolidar"
      $justification = "Caminho duplicado com conteudo divergente; exige decisao registrada antes da movimentacao."
    }
  }

  $file = Get-Item -LiteralPath $absolutePath
  $canonicalDocument = if ($isOriginal -and $originalCanonicalDestinations.ContainsKey($relativePath)) {
    $originalCanonicalDestinations[$relativePath]
  }
  else {
    "gaiatec-documentacao:$destination"
  }
  $records.Add((New-Record `
        -SourcePath "gaiatec-documentacao:$relativePath" `
        -Sha256 (Get-Sha256 $absolutePath) `
        -SizeBytes $file.Length `
        -SourceRepository "Vnd93/gaiatec-documentacao" `
        -SourceCommit $docsCommit `
        -Category $category `
        -ProposedStatus $status `
        -CanonicalDocument $canonicalDocument `
        -RecommendedDestination $destination `
        -Action $action `
        -Justification $justification `
        -Dependencies $counterpart))
}

$cmsHumanDestinations = @{
  "AUDIT-DELTA.md" = "gaiatec-documentacao:docs/60-qualidade-auditoria/audit-delta.md"
  "AUDITORIA_CMS_GAIATEC.md" = "gaiatec-documentacao:docs/60-qualidade-auditoria/auditoria-cms-gaiatec.md"
  "Analise e Arquitetura do Site - GAIATEC SISTEMAS.md" = "gaiatec-documentacao:docs/20-arquitetura-seguranca/analise-e-arquitetura-do-site-gaiatec-sistemas.md"
  "COMPLEMENTO_TECNICO_OPERACIONAL_AUDITORIA_CMS_GAIATEC.md" = "gaiatec-documentacao:docs/60-qualidade-auditoria/complemento-tecnico-operacional-auditoria-cms-gaiatec.md"
  "PLANEJAMENTO_EXECUTIVO_DESENVOLVIMENTO_REMODELAGEM_CMS_GAIATEC.md" = "gaiatec-documentacao:docs/10-produto-requisitos/planejamento-executivo-desenvolvimento-remodelagem-cms-gaiatec.md"
  "POLITICA_RECADASTRO_LIMPO_CONTEUDO_E_MIDIA_GAIATEC.md" = "gaiatec-documentacao:docs/70-governanca-legal/politica-recadastramento-limpo-conteudo-midia-gaiatec.md"
  "PROCEDIMENTO_AJUSTES_E_DESENVOLVIMENTO_PAINEL_ADMINISTRATIVO_GAIATEC.md" = "gaiatec-documentacao:docs/50-operacao-entrega/procedimento-ajustes-desenvolvimento-painel-administrativo-gaiatec.md"
  "PROMPTS-IMAGENS-V2.md" = "gaiatec-documentacao:docs/99-modelos/prompts-imagens-v2.md"
  "PROMPTS-IMAGENS.md" = "gaiatec-documentacao:docs/99-modelos/prompts-imagens.md"
  "guidelines/Guidelines.md" = "gaiatec-documentacao:docs/40-site-publico/guidelines.md"
}
$releaseControlDestinations = @{
  "docs/ev2/fase-12/approvals/G12_e52b25d903251cf538918d89049a58524c3c9911.json" = "gaiatec-cms:.github/release-controls/approvals/G12_e52b25d903251cf538918d89049a58524c3c9911.json"
  "docs/ev2/fase-12/evidencias/G12_CANARY_e52b25d_2026-09-05.json" = "gaiatec-cms:.github/release-controls/evidence/G12_CANARY_e52b25d_2026-09-05.json"
  "docs/ev2/fase-16/evidencias/G16_CSP_BROWSER_e52b25d.json" = "gaiatec-cms:.github/release-controls/evidence/G16_CSP_BROWSER_e52b25d.json"
  "docs/ev2/fase-16/ESCOPO_DPO_LEGAL_PADRAO.md" = "gaiatec-cms:.github/release-controls/evidence/escopo-dpo-legal-39fd74f2.md"
  "docs/ev2/fase-12/G12_APPROVAL.template.json" = "gaiatec-cms:.github/release-controls/templates/g12-approval.template.json"
}
$cmsCompatibilityDestinations = @{
  "docs/README.md" = "gaiatec-cms:docs/README.md; gaiatec-documentacao:docs/00-indice/mapa-documental.md"
  "docs/validacao-local/ULTIMA_VALIDACAO.md" = "gaiatec-documentacao:docs/90-historico/cms-validacao-local/ultima-validacao-local-2026-08-29.md"
}

foreach ($relativePath in $cmsFiles) {
  $absolutePath = Join-Path $cmsRepo $relativePath
  $category = Get-Category $relativePath
  $dependencies = if ($relativePath.StartsWith("docs/", [StringComparison]::OrdinalIgnoreCase)) {
    Get-Dependencies $relativePath $cmsCorpus
  }
  else { "" }
  $counterpart = if ($docsSet.Contains($relativePath)) { "gaiatec-documentacao:$relativePath" } else { "" }
  $status = "duplicado"
  $action = "substituir"
  $destination = "gaiatec-documentacao:$(Get-CanonicalDocsPath $relativePath $category)"
  $justification = "Documento humano deve existir somente no repositorio documental canonico."

  if ($releaseControlDestinations.ContainsKey($relativePath)) {
    $status = "controle-operacional-ativo"
    $action = "mover"
    $destination = $releaseControlDestinations[$relativePath]
    $justification = "Controle consumido por CI/deployment permanece versionado junto ao executavel; a documentacao humana correspondente reside no repositorio documental."
  }
  elseif ($cmsCompatibilityDestinations.ContainsKey($relativePath)) {
    $status = if ($relativePath -eq "docs/README.md") { "indice-compatibilidade" } else { "historico-migrado" }
    $action = "substituir"
    $destination = $cmsCompatibilityDestinations[$relativePath]
    $justification = if ($relativePath -eq "docs/README.md") {
      "Indice curto de compatibilidade permanece no CMS e direciona para a fonte documental canonica."
    }
    else {
      "Registro de validacao local foi preservado como historico; o gerador passou a escrever em outputs fora da arvore documental."
    }
  }
  elseif ($cmsHumanDestinations.ContainsKey($relativePath)) {
    $status = "migrado-para-fonte-canonica"
    $action = "consolidar"
    $destination = $cmsHumanDestinations[$relativePath]
    $justification = "Documento humano de raiz foi consolidado na taxonomia canonica e removido do repositorio executavel."
  }
  elseif (-not $relativePath.StartsWith("docs/", [StringComparison]::OrdinalIgnoreCase)) {
    $status = "tecnico-ativo"
    $action = "manter"
    $destination = "gaiatec-cms:$relativePath"
    $justification = "Arquivo tecnico, de codigo, fixture, configuracao ou recurso de runtime ligado ao executavel."
  }
  elseif ($relativePath -match "^docs/ev2/fase-12/approvals/.+\.json$" -or
    ($dependencies -match "deploy-production|verify-approval|release-guard|CODEOWNERS")) {
    $status = "controle-operacional-ativo"
    $action = "mover"
    $destination = "gaiatec-cms:.github/release-controls/$($relativePath -replace '^docs/ev2/fase-12/', '')"
    $justification = "Controle consumido por CI/deployment deve permanecer versionado junto ao executavel, fora da arvore documental humana."
  }
  elseif ($counterpart -and $docsBlobMap[$relativePath] -ne $cmsBlobMap[$relativePath]) {
    $status = "decisao-canonica"
    $action = "consolidar"
    $justification = "Caminho duplicado com conteudo divergente; decisao canonica deve preservar historico e evidencias."
  }
  elseif (-not $counterpart -and $dependencies) {
    $status = "dependencia-tecnica"
    $action = "consolidar"
    $justification = "Documento existe apenas no CMS e possui consumidores em codigo, testes, scripts ou workflows; migracao requer refatoracao ou compatibilidade."
  }

  $file = Get-Item -LiteralPath $absolutePath
  $records.Add((New-Record `
        -SourcePath "gaiatec-cms:$relativePath" `
        -Sha256 (Get-Sha256 $absolutePath) `
        -SizeBytes $file.Length `
        -SourceRepository "Vnd93/gaiatec-cms" `
        -SourceCommit $cmsCommit `
        -Category $category `
        -ProposedStatus $status `
        -CanonicalDocument $destination `
        -RecommendedDestination $destination `
        -Action $action `
        -Justification $justification `
        -Dependencies $dependencies))
}

function Add-ExternalFiles {
  param(
    [string]$Root,
    [string]$LogicalPrefix,
    [string]$Repository,
    [string]$Commit,
    [scriptblock]$Selector,
    [scriptblock]$Decision
  )
  if (-not (Test-Path -LiteralPath $Root)) { return }
  $files = Get-ChildItem -LiteralPath $Root -File -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object { -not (Test-ExcludedPath $_.FullName) -and (& $Selector $_) }
  foreach ($file in $files) {
    $relativePath = Get-RelativePath $Root $file.FullName
    $decisionResult = & $Decision $file $relativePath
    $records.Add((New-Record `
          -SourcePath "${LogicalPrefix}:$relativePath" `
          -Sha256 (Get-Sha256 $file.FullName) `
          -SizeBytes $file.Length `
          -SourceRepository $Repository `
          -SourceCommit $Commit `
          -Category (Get-Category "$LogicalPrefix/$relativePath") `
          -ProposedStatus $decisionResult.status `
          -CanonicalDocument $decisionResult.canonical `
          -RecommendedDestination $decisionResult.destination `
          -Action $decisionResult.action `
          -Justification $decisionResult.justification `
          -Dependencies $decisionResult.dependencies))
  }
}

$looseSelector = { param($file) $supportedExtensions.Contains($file.Extension) }
$looseCanonicalDestinations = @{
  "Analise e Arquitetura do Site - GAIATEC SISTEMAS.md" = "gaiatec-documentacao:docs/20-arquitetura-seguranca/analise-e-arquitetura-do-site-gaiatec-sistemas.md"
  "AUDITORIA_CMS_GAIATEC.md" = "gaiatec-documentacao:docs/60-qualidade-auditoria/auditoria-cms-gaiatec.md"
  "COMPLEMENTO_TECNICO_OPERACIONAL_AUDITORIA_CMS_GAIATEC.md" = "gaiatec-documentacao:docs/60-qualidade-auditoria/complemento-tecnico-operacional-auditoria-cms-gaiatec.md"
  "PLANEJAMENTO_EXECUTIVO_DESENVOLVIMENTO_REMODELAGEM_CMS_GAIATEC.md" = "gaiatec-documentacao:docs/10-produto-requisitos/planejamento-executivo-desenvolvimento-remodelagem-cms-gaiatec.md"
  "POLITICA_RECADASTRO_LIMPO_CONTEUDO_E_MIDIA_GAIATEC.md" = "gaiatec-documentacao:docs/70-governanca-legal/politica-recadastramento-limpo-conteudo-midia-gaiatec.md"
  "PROCEDIMENTO_AJUSTES_E_DESENVOLVIMENTO_PAINEL_ADMINISTRATIVO_GAIATEC.md" = "gaiatec-documentacao:docs/50-operacao-entrega/procedimento-ajustes-desenvolvimento-painel-administrativo-gaiatec.md"
}
$looseDecision = {
  param($file, $relativePath)
  $category = Get-Category $relativePath
  if ($file.Extension -ieq ".zip") {
    return @{ status = "historico"; canonical = ""; destination = "arquivo-historico:pacotes-zip/site-raiz/$relativePath"; action = "arquivar"; justification = "Pacote antigo deve sair da pasta ativa com hash preservado."; dependencies = "" }
  }
  if ($category -eq "manual") {
    $extension = $file.Extension.ToLowerInvariant()
    $canonical = "gaiatec-documentacao:docs/30-cms/manual-do-usuario/manual-do-usuario-cms-gaiatec$extension"
    return @{ status = "canonico-sanitizado-e-original-arquivado"; canonical = $canonical; destination = "$canonical; arquivo-historico:edicoes-antigas-manuais/manual-do-usuario-v1.0-2026-08-31/$relativePath"; action = "consolidar"; justification = "Edicao vigente foi versionada com metadados pessoais removidos e original byte a byte arquivado."; dependencies = "" }
  }
  if ($looseCanonicalDestinations.ContainsKey($relativePath)) {
    $canonical = $looseCanonicalDestinations[$relativePath]
    return @{ status = "consolidado-e-arquivado"; canonical = $canonical; destination = "$canonical; arquivo-historico:documentos-originais/soltos-2026-09-06/$relativePath"; action = "consolidar"; justification = "Documento solto foi comparado, consolidado na taxonomia e preservado como fonte historica."; dependencies = "" }
  }
  return @{ status = "original-historico"; canonical = "revisar-sucessor"; destination = "arquivo-historico:documentos-originais/soltos-2026-09-06/$relativePath"; action = "arquivar"; justification = "Documento solto deve ser comparado ao sucessor canonico e preservado como fonte historica."; dependencies = "" }
}
$looseFiles = Get-ChildItem -LiteralPath $siteRoot -File -Force | Where-Object { $supportedExtensions.Contains($_.Extension) }
foreach ($file in $looseFiles) {
  $decision = & $looseDecision $file $file.Name
  $records.Add((New-Record `
        -SourcePath "site-raiz:$($file.Name)" `
        -Sha256 (Get-Sha256 $file.FullName) `
        -SizeBytes $file.Length `
        -SourceRepository "fora-de-repositorio" `
        -SourceCommit "n/a" `
        -Category (Get-Category $file.Name) `
        -ProposedStatus $decision.status `
        -CanonicalDocument $decision.canonical `
        -RecommendedDestination $decision.destination `
        -Action $decision.action `
        -Justification $decision.justification `
        -Dependencies $decision.dependencies))
}

$legacyRoot = Join-Path $siteRoot "_source_website_gaiatecsistemas"
if (Test-Path -LiteralPath $legacyRoot) {
  $legacyCommit = Get-GitValue $legacyRoot @("rev-parse", "HEAD")
  Add-ExternalFiles `
    -Root $legacyRoot `
    -LogicalPrefix "repositorio-legado" `
    -Repository "pedronishida/website_gaiatecsistemas" `
    -Commit $legacyCommit `
    -Selector { param($file) $supportedExtensions.Contains($file.Extension) } `
    -Decision {
      param($file, $relativePath)
      @{
        status        = "historico-somente-leitura"
        canonical     = "gaiatec-documentacao:docs/00-indice/catalogo-documentos.md"
        destination   = "arquivo-historico:repositorio-legado/website_gaiatecsistemas-pedronishida/$relativePath"
        action        = "arquivar"
        justification = "Repositorio legado preservado como referencia historica, sem promover seu conteudo a fonte canonica."
        dependencies  = "remote push local deve ser desabilitado; remoto original preservado"
      }
    }
}

$artifactsRoot = Join-Path $siteRoot ".codex-artifacts"
Add-ExternalFiles `
  -Root $artifactsRoot `
  -LogicalPrefix ".codex-artifacts" `
  -Repository "fora-de-repositorio" `
  -Commit "n/a" `
  -Selector {
    param($file)
    $relative = [IO.Path]::GetRelativePath($artifactsRoot, $file.FullName)
    $supportedExtensions.Contains($file.Extension) -and $relative -notmatch "^reorganizacao-documental[\\/]"
  } `
  -Decision {
    param($file, $relativePath)
    $isFinalSource = $file.Extension -in @(".docx", ".pdf", ".zip") -and $relativePath -notmatch "(?:^|/|\\)(?:qa|render|rendered-)"
    $isImmutableEvidence = $relativePath -match "[0-9a-f]{7,40}" -and $file.Extension -ieq ".json"
    if ($isFinalSource -or $isImmutableEvidence) {
      $destination = if ($file.Extension -ieq ".zip") {
        "arquivo-historico:pacotes-zip/ev2-canary/$($file.Name)"
      }
      else {
        "arquivo-historico:documentos-originais/.codex-artifacts/$relativePath"
      }
      $canonical = "n/a"
      if ($isImmutableEvidence) {
        $normalizedArtifactPath = $relativePath.Replace("\\", "/")
        if ($normalizedArtifactPath -match "^ev2-g16-evidence/3433aebb134a74546d7a26bc1029a74421d6c597/(.+)$" -or
          $normalizedArtifactPath -eq "ev2-g16-evidence/7804d5b44786941e4fa1f4c6ad5626cb26bee802/http-probe-attempt-1.json") {
          $canonical = "gaiatec-documentacao:docs/80-evolucao/ev2/fase-16/evidencias/originais-artifacts/$($normalizedArtifactPath -replace '^ev2-g16-evidence/', '')"
        }
        elseif ($normalizedArtifactPath -match "^ev2-g16-evidence/7804d5b44786941e4fa1f4c6ad5626cb26bee802/browser-csp\.json$") {
          $canonical = "gaiatec-documentacao:docs/80-evolucao/ev2/fase-16/evidencias/G16_CSP_BROWSER_7804d5b.json"
        }
        elseif ($normalizedArtifactPath -match "^ev2-g16-evidence/7804d5b44786941e4fa1f4c6ad5626cb26bee802/http-probe\.json$") {
          $canonical = "gaiatec-documentacao:docs/80-evolucao/ev2/fase-16/evidencias/G16_CSP_HTTP_7804d5b.json"
        }
        elseif ($normalizedArtifactPath -match "^ev2-g16-evidence/ced95e61f89ff14eda9675e0ec730614899dde65/g16-csp-browser-evidence\.json$") {
          $canonical = "gaiatec-documentacao:docs/80-evolucao/ev2/fase-16/evidencias/G16_CSP_BROWSER_ced95e61.json"
        }
        elseif ($normalizedArtifactPath -match "^ev2-g16-evidence/ced95e61f89ff14eda9675e0ec730614899dde65/g16-csp-http-evidence\.json$") {
          $canonical = "gaiatec-documentacao:docs/80-evolucao/ev2/fase-16/evidencias/G16_CSP_HTTP_ced95e61.json"
        }
      }
      return @{
        status        = "resultado-encerrado"
        canonical     = $canonical
        destination   = $destination
        action        = "arquivar"
        justification = "Resultado encerrado ou evidencia vinculada a SHA; preservar com hash, sem tratar o diretorio de artefatos como fonte canonica."
        dependencies  = ""
      }
    }
    return @{
      status        = "intermediario-nao-canonico"
      canonical     = ""
      destination   = ".codex-artifacts:$relativePath"
      action        = "ignorar"
      justification = "Artefato intermediario de QA/render; manter fora da fonte canonica e nao arquivar indiscriminadamente."
      dependencies  = ""
    }
  }

$g6Root = Join-Path $siteRoot ".g6-homologation-aab55f7"
if (Test-Path -LiteralPath $g6Root) {
  $g6Commit = Get-GitValue $g6Root @("rev-parse", "HEAD")
  Add-ExternalFiles `
    -Root $g6Root `
    -LogicalPrefix ".g6-homologation-aab55f7" `
    -Repository "Vnd93/gaiatec-cms-worktree" `
    -Commit $g6Commit `
    -Selector { param($file) $supportedExtensions.Contains($file.Extension) } `
    -Decision {
      param($file, $relativePath)
      @{
        status        = "worktree-protegido"
        canonical     = ""
        destination   = ".g6-homologation-aab55f7:$relativePath"
        action        = "ignorar"
        justification = "Worktree registrado com alteracoes nao commitadas; preservar integralmente e encerrar somente por comandos Git apos reconciliacao."
        dependencies  = "supabase/functions/cms-public/index.ts modificado; supabase/functions/_shared/cms-public-projection.ts nao rastreado"
      }
    }
}

$anomalyRoot = Join-Path $siteRoot "%SystemDrive%"
Add-ExternalFiles `
  -Root $anomalyRoot `
  -LogicalPrefix "%SystemDrive%" `
  -Repository "fora-de-repositorio" `
  -Commit "n/a" `
  -Selector { param($file) $true } `
  -Decision {
    param($file, $relativePath)
    @{
      status        = "anomalia-nao-documental"
      canonical     = "n/a"
      destination   = "%SystemDrive%:$relativePath"
      action        = "ignorar"
      justification = "Cache do Windows criado sob caminho literal anomalo; manter em quarentena local e tratar manualmente fora da migracao documental."
      dependencies  = "nenhuma referencia operacional identificada"
    }
  }

$orderedRecords = @($records | Sort-Object caminho_origem, sha256)
$outputCsvDirectory = Split-Path -Parent $OutputCsv
$outputJsonDirectory = Split-Path -Parent $OutputSummaryJson
New-Item -ItemType Directory -Force -Path $outputCsvDirectory | Out-Null
New-Item -ItemType Directory -Force -Path $outputJsonDirectory | Out-Null
$orderedRecords | Export-Csv -LiteralPath $OutputCsv -NoTypeInformation -Encoding utf8NoBOM

$summary = [ordered]@{
  generated_at_utc = [DateTime]::UtcNow.ToString("o")
  docs_commit      = $docsCommit
  cms_commit       = $cmsCommit
  record_count     = $orderedRecords.Count
  by_source        = @($orderedRecords | Group-Object { ($_.caminho_origem -split ":", 2)[0] } | Sort-Object Name | ForEach-Object { [ordered]@{ source = $_.Name; count = $_.Count; bytes = [long](($_.Group | Measure-Object tamanho_bytes -Sum).Sum) } })
  by_action        = @($orderedRecords | Group-Object acao | Sort-Object Name | ForEach-Object { [ordered]@{ action = $_.Name; count = $_.Count; bytes = [long](($_.Group | Measure-Object tamanho_bytes -Sum).Sum) } })
  safety           = [ordered]@{
    snapshot                      = "pre-migracao"
    secrets_read                  = $false
    deploy_executed               = $false
    staging_or_production_touched = $false
    movements_executed_at_snapshot = $false
  }
}
$summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputSummaryJson -Encoding utf8NoBOM

Write-Output ($summary | ConvertTo-Json -Depth 8)
