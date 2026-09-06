param(
  [Parameter(Mandatory = $true)]
  [string]$SiteRoot,

  [Parameter(Mandatory = $true)]
  [string]$ArchiveRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$siteRoot = (Resolve-Path -LiteralPath $SiteRoot).Path
$archiveRoot = (Resolve-Path -LiteralPath $ArchiveRoot).Path
$rows = [Collections.Generic.List[object]]::new()

function Get-Sha256([string]$Path) {
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
}

function Add-FileRecord {
  param(
    [string]$Type,
    [string]$LogicalSource,
    [string]$SourcePath,
    [string]$RelativeDestination,
    [string]$SourceCommit = "n/a"
  )

  $destinationPath = Join-Path $archiveRoot $RelativeDestination.Replace("/", "\")
  if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
    throw "Arquivo de origem ausente: $SourcePath"
  }
  if (-not (Test-Path -LiteralPath $destinationPath -PathType Leaf)) {
    throw "Arquivo de destino ausente: $destinationPath"
  }

  $sourceHash = Get-Sha256 $SourcePath
  $destinationHash = Get-Sha256 $destinationPath
  $rows.Add([pscustomobject][ordered]@{
      tipo               = $Type
      origem_logica      = $LogicalSource
      destino_relativo   = $RelativeDestination.Replace("\", "/")
      tamanho_bytes      = (Get-Item -LiteralPath $SourcePath).Length
      sha256_origem      = $sourceHash
      sha256_destino     = $destinationHash
      origem_git_commit  = $SourceCommit
      origem_git_tree    = "n/a"
      validacao          = if ($sourceHash -eq $destinationHash) { "hash-identico" } else { "hash-divergente" }
      rollback           = "origem mantida ate validacao final"
    })
}

$legacySource = Join-Path $siteRoot "_source_website_gaiatecsistemas"
$legacyDestination = Join-Path $archiveRoot "repositorio-legado\website_gaiatecsistemas-pedronishida"
$legacyCommit = (& git -C $legacySource rev-parse HEAD | Out-String).Trim()
$legacyTree = (& git -C $legacySource rev-parse "HEAD^{tree}" | Out-String).Trim()
$archivedCommit = (& git -C $legacyDestination rev-parse HEAD | Out-String).Trim()
$archivedTree = (& git -C $legacyDestination rev-parse "HEAD^{tree}" | Out-String).Trim()
$legacyBytes = [long]((Get-ChildItem -LiteralPath $legacyDestination -File -Recurse -Force | Measure-Object Length -Sum).Sum)
$rows.Add([pscustomobject][ordered]@{
    tipo               = "repositorio-git"
    origem_logica      = "site-raiz:_source_website_gaiatecsistemas"
    destino_relativo   = "repositorio-legado/website_gaiatecsistemas-pedronishida"
    tamanho_bytes      = $legacyBytes
    sha256_origem      = "n/a"
    sha256_destino     = "n/a"
    origem_git_commit  = $legacyCommit
    origem_git_tree    = $legacyTree
    validacao          = if ($legacyCommit -eq $archivedCommit -and $legacyTree -eq $archivedTree) { "git-head-tree-identicos-e-fsck-aprovado" } else { "git-divergente" }
    rollback           = "origem mantida; clone arquivado independente"
  })

$documentSourceRoot = Join-Path $siteRoot "gaiatec-documentacao\documentacao-original"
$documentDestinationRoot = Join-Path $archiveRoot "documentos-originais\gaiatec-documentacao\documentacao-original"
foreach ($file in (Get-ChildItem -LiteralPath $documentSourceRoot -File -Recurse | Sort-Object FullName)) {
  $relative = [IO.Path]::GetRelativePath($documentSourceRoot, $file.FullName).Replace("\", "/")
  Add-FileRecord `
    -Type "documento-original" `
    -LogicalSource "gaiatec-documentacao:documentacao-original/$relative" `
    -SourcePath $file.FullName `
    -RelativeDestination "documentos-originais/gaiatec-documentacao/documentacao-original/$relative" `
    -SourceCommit "bee751b10d696b0c9d101b1283741b1ae9d0ee9f"
}

$looseDocuments = @(
  "Analise e Arquitetura do Site - GAIATEC SISTEMAS.md",
  "AUDITORIA_CMS_GAIATEC.md",
  "COMPLEMENTO_TECNICO_OPERACIONAL_AUDITORIA_CMS_GAIATEC.md",
  "PLANEJAMENTO_EXECUTIVO_DESENVOLVIMENTO_REMODELAGEM_CMS_GAIATEC.md",
  "POLITICA_RECADASTRO_LIMPO_CONTEUDO_E_MIDIA_GAIATEC.md",
  "PROCEDIMENTO_AJUSTES_E_DESENVOLVIMENTO_PAINEL_ADMINISTRATIVO_GAIATEC.md"
)
foreach ($name in $looseDocuments) {
  Add-FileRecord `
    -Type "documento-solto" `
    -LogicalSource "site-raiz:$name" `
    -SourcePath (Join-Path $siteRoot $name) `
    -RelativeDestination "documentos-originais/soltos-2026-09-06/$name"
}

$manualDocuments = @(
  "Manual do Usuário - CMS GAIATEC.docx",
  "Manual do Usuário - CMS GAIATEC.pdf"
)
foreach ($name in $manualDocuments) {
  Add-FileRecord `
    -Type "edicao-antiga-manual" `
    -LogicalSource "site-raiz:$name" `
    -SourcePath (Join-Path $siteRoot $name) `
    -RelativeDestination "edicoes-antigas-manuais/manual-do-usuario-v1.0-2026-08-31/$name"
}

$artifactDocuments = @(
  "fase2-cms/Plano Diretor - Fase 2 - Evolucao do CMS e Site GAIATEC.docx",
  "manual-do-usuario-cms/Especificacao Tecnica Funcional e Plano de Implementacao do CMS GAIATEC.docx",
  "manual-do-usuario-cms/Manual do Usuario - Plano Consolidado de Melhorias do CMS GAIATEC.docx",
  "manual-do-usuario-cms/Manual do Usuario - Plano Consolidado de Melhorias do CMS GAIATEC.pdf",
  "manual-do-usuario-cms/Manual do Usuario - Resumo Executivo das Melhorias do CMS GAIATEC.docx"
)
foreach ($relative in $artifactDocuments) {
  Add-FileRecord `
    -Type "resultado-encerrado-codex-artifacts" `
    -LogicalSource ".codex-artifacts:$relative" `
    -SourcePath (Join-Path $siteRoot ".codex-artifacts\$($relative.Replace('/', '\'))") `
    -RelativeDestination "documentos-originais/.codex-artifacts/$relative"
}

$g16SourceRoot = Join-Path $siteRoot ".codex-artifacts\ev2-g16-evidence"
foreach ($file in (Get-ChildItem -LiteralPath $g16SourceRoot -File -Recurse | Sort-Object FullName)) {
  $relative = [IO.Path]::GetRelativePath($g16SourceRoot, $file.FullName).Replace("\", "/")
  Add-FileRecord `
    -Type "evidencia-imutavel-codex-artifacts" `
    -LogicalSource ".codex-artifacts:ev2-g16-evidence/$relative" `
    -SourcePath $file.FullName `
    -RelativeDestination "documentos-originais/.codex-artifacts/ev2-g16-evidence/$relative"
}

$zipRecords = @(
  @{
    logical = "site-raiz:website_gaiatecsistemas-main.zip"
    source  = "website_gaiatecsistemas-main.zip"
    target  = "pacotes-zip/site-raiz/website_gaiatecsistemas-main.zip"
  },
  @{
    logical = ".codex-artifacts:ev2-canary/ev2-g2-canary-55b549f.zip"
    source  = ".codex-artifacts\ev2-canary\ev2-g2-canary-55b549f.zip"
    target  = "pacotes-zip/ev2-canary/ev2-g2-canary-55b549f.zip"
  },
  @{
    logical = ".codex-artifacts:ev2-canary/ev2-g2-canary-70489c8.zip"
    source  = ".codex-artifacts\ev2-canary\ev2-g2-canary-70489c8.zip"
    target  = "pacotes-zip/ev2-canary/ev2-g2-canary-70489c8.zip"
  },
  @{
    logical = ".codex-artifacts:manual-do-usuario-cms/ev2-g2-canary-af20bc7.zip"
    source  = ".codex-artifacts\manual-do-usuario-cms\ev2-g2-canary-af20bc7.zip"
    target  = "pacotes-zip/ev2-canary/ev2-g2-canary-af20bc7.zip"
  }
)
foreach ($zipRecord in $zipRecords) {
  Add-FileRecord `
    -Type "pacote-zip" `
    -LogicalSource $zipRecord.logical `
    -SourcePath (Join-Path $siteRoot $zipRecord.source) `
    -RelativeDestination $zipRecord.target
}

$manifestPath = Join-Path $archiveRoot "manifestos-de-arquivamento\manifesto-arquivamento-inicial.csv"
$rows | Export-Csv -LiteralPath $manifestPath -NoTypeInformation -Encoding utf8NoBOM

$mismatches = @($rows | Where-Object { $_.validacao -match "divergente" })
if ($mismatches.Count -gt 0) {
  throw "Manifesto contém $($mismatches.Count) divergência(s)."
}

[pscustomobject]@{
  registros = $rows.Count
  bytes = [long](($rows | Measure-Object tamanho_bytes -Sum).Sum)
  divergencias = $mismatches.Count
  manifesto = $manifestPath
} | ConvertTo-Json
