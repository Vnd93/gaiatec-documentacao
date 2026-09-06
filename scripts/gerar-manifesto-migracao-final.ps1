param(
  [Parameter(Mandatory = $true)]
  [string]$DocsSourceRepo,

  [Parameter(Mandatory = $true)]
  [string]$CmsSourceRepo,

  [Parameter(Mandatory = $true)]
  [string]$SiteRoot,

  [Parameter(Mandatory = $true)]
  [string]$DocsWorktree,

  [Parameter(Mandatory = $true)]
  [string]$CmsWorktree,

  [Parameter(Mandatory = $true)]
  [string]$ArchiveRoot,

  [Parameter(Mandatory = $true)]
  [string]$InitialManifest,

  [Parameter(Mandatory = $true)]
  [string]$OutputCsv,

  [Parameter(Mandatory = $true)]
  [string]$OutputSummaryJson
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-Directory([string]$Path) {
  return (Resolve-Path -LiteralPath $Path).Path
}

$docsSourceRepo = Resolve-Directory $DocsSourceRepo
$cmsSourceRepo = Resolve-Directory $CmsSourceRepo
$siteRoot = Resolve-Directory $SiteRoot
$docsWorktree = Resolve-Directory $DocsWorktree
$cmsWorktree = Resolve-Directory $CmsWorktree
$archiveRoot = Resolve-Directory $ArchiveRoot
$initialManifest = (Resolve-Path -LiteralPath $InitialManifest).Path

$knownPrefixes = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($prefix in @(
    "gaiatec-documentacao",
    "gaiatec-cms",
    "arquivo-historico",
    "site-raiz",
    "repositorio-legado",
    ".codex-artifacts",
    ".g6-homologation-aab55f7",
    "%SystemDrive%"
  )) {
  [void]$knownPrefixes.Add($prefix)
}

function Get-Sha256([string]$Path) {
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant()
}

function Convert-ToForwardSlash([string]$Path) {
  return $Path.Replace("\", "/")
}

function Assert-AllowedRelativePath([string]$RelativePath) {
  $normalized = Convert-ToForwardSlash $RelativePath
  if ($normalized -match "(^|/)\.secrets($|/)" -or $normalized -match "(^|/)\.codex-worktrees($|/)") {
    throw "Caminho protegido encontrado no manifesto; processamento interrompido sem acesso: $normalized"
  }
  if ($normalized -match "(^|/)\.git($|/)") {
    throw "Metadado Git nao pode ser tratado como arquivo documental: $normalized"
  }
}

function Join-ContainedPath([string]$Root, [string]$RelativePath) {
  Assert-AllowedRelativePath $RelativePath
  $relativeWindows = $RelativePath.Replace("/", "\")
  $candidate = [IO.Path]::GetFullPath((Join-Path $Root $relativeWindows))
  $rootFull = [IO.Path]::GetFullPath($Root).TrimEnd("\")
  $rootPrefix = "$rootFull\"
  if (-not $candidate.Equals($rootFull, [StringComparison]::OrdinalIgnoreCase) -and
    -not $candidate.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Caminho fora da raiz permitida: $RelativePath"
  }
  return $candidate
}

function Split-LogicalPath([string]$LogicalPath, [string]$DefaultPrefix = "") {
  if ([string]::IsNullOrWhiteSpace($LogicalPath)) { return $null }
  $trimmed = $LogicalPath.Trim()
  if ($trimmed -in @("n/a", "revisar-sucessor")) { return $null }

  $separator = $trimmed.IndexOf(":")
  if ($separator -gt 0) {
    $possiblePrefix = $trimmed.Substring(0, $separator)
    if ($knownPrefixes.Contains($possiblePrefix)) {
      return [pscustomobject]@{
        prefix = $possiblePrefix
        path   = $trimmed.Substring($separator + 1).TrimStart("/", "\")
      }
    }
  }

  if ([string]::IsNullOrWhiteSpace($DefaultPrefix)) { return $null }
  return [pscustomobject]@{
    prefix = $DefaultPrefix
    path   = $trimmed.TrimStart("/", "\")
  }
}

function Get-TargetRoot([string]$Prefix) {
  switch ($Prefix.ToLowerInvariant()) {
    "gaiatec-documentacao" { return $docsWorktree }
    "gaiatec-cms" { return $cmsWorktree }
    "arquivo-historico" { return $archiveRoot }
    "site-raiz" { return $siteRoot }
    "repositorio-legado" { return (Join-Path $siteRoot "_source_website_gaiatecsistemas") }
    ".codex-artifacts" { return (Join-Path $siteRoot ".codex-artifacts") }
    ".g6-homologation-aab55f7" { return (Join-Path $siteRoot ".g6-homologation-aab55f7") }
    "%systemdrive%" { return (Join-Path $siteRoot "%SystemDrive%") }
    default { throw "Prefixo logico desconhecido: $Prefix" }
  }
}

function Get-SourceRoot([string]$Prefix) {
  switch ($Prefix.ToLowerInvariant()) {
    "gaiatec-documentacao" { return $docsSourceRepo }
    "gaiatec-cms" { return $cmsSourceRepo }
    default { return Get-TargetRoot $Prefix }
  }
}

function Resolve-LogicalTarget([string]$LogicalPath, [string]$DefaultPrefix = "") {
  $parts = Split-LogicalPath $LogicalPath $DefaultPrefix
  if ($null -eq $parts) { return $null }
  if ([string]::IsNullOrWhiteSpace($parts.path) -or $parts.path.Contains(":")) { return $null }
  $root = Get-TargetRoot $parts.prefix
  $physical = Join-ContainedPath $root $parts.path
  return [pscustomobject]@{
    logical  = "$($parts.prefix):$(Convert-ToForwardSlash $parts.path)"
    physical = $physical
  }
}

function Resolve-LogicalSource([string]$LogicalPath) {
  $parts = Split-LogicalPath $LogicalPath
  if ($null -eq $parts) { throw "Origem logica invalida: $LogicalPath" }
  $root = Get-SourceRoot $parts.prefix
  return [pscustomobject]@{
    prefix   = $parts.prefix
    path     = Convert-ToForwardSlash $parts.path
    physical = Join-ContainedPath $root $parts.path
  }
}

function Add-ExistingCandidate(
  [Collections.Generic.List[object]]$Candidates,
  [string]$LogicalPath,
  [string]$DefaultPrefix
) {
  $resolved = Resolve-LogicalTarget $LogicalPath $DefaultPrefix
  if ($null -eq $resolved) { return }
  if (-not (Test-Path -LiteralPath $resolved.physical -PathType Leaf)) { return }
  if (@($Candidates | Where-Object { $_.logical -eq $resolved.logical }).Count -gt 0) { return }
  $Candidates.Add([pscustomobject]@{
      logical = $resolved.logical
      path    = $resolved.physical
      sha256  = Get-Sha256 $resolved.physical
    })
}

function Get-RepositoryHashIndex([string]$Repository, [string]$LogicalPrefix) {
  $result = @{}
  $paths = @(& git -C $Repository ls-files --cached --others --exclude-standard)
  if ($LASTEXITCODE -ne 0) { throw "Falha ao listar arquivos de $Repository" }
  foreach ($relativePath in $paths) {
    if ([string]::IsNullOrWhiteSpace($relativePath)) { continue }
    $normalized = Convert-ToForwardSlash $relativePath
    if ($normalized -match "(^|/)\.secrets($|/)" -or
      $normalized -match "(^|/)\.codex-worktrees($|/)" -or
      $normalized -match "(^|/)(node_modules|dist|coverage)($|/)") {
      continue
    }
    $absolutePath = Join-ContainedPath $Repository $normalized
    if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) { continue }
    $hash = Get-Sha256 $absolutePath
    if (-not $result.ContainsKey($hash)) {
      $result[$hash] = [Collections.Generic.List[object]]::new()
    }
    $result[$hash].Add([pscustomobject]@{
        logical = "${LogicalPrefix}:$normalized"
        path    = $absolutePath
        sha256  = $hash
      })
  }
  return $result
}

$rows = @(Import-Csv -LiteralPath $initialManifest)
$docsHashIndex = Get-RepositoryHashIndex $docsWorktree "gaiatec-documentacao"
$cmsHashIndex = Get-RepositoryHashIndex $cmsWorktree "gaiatec-cms"
$finalRows = [Collections.Generic.List[object]]::new()
$sourceMismatches = [Collections.Generic.List[string]]::new()
$unresolved = [Collections.Generic.List[string]]::new()
$archiveMismatches = [Collections.Generic.List[string]]::new()
$archiveRequiredRows = 0
$archiveExactRows = 0
$restrictedProcessed = 0

$statusByAction = @{
  "arquivar"   = "copia-arquivada-validada-origem-retida"
  "consolidar" = "consolidado-com-historico-preservado"
  "ignorar"    = "preservado-fora-da-migracao"
  "manter"     = "mantido-no-repositorio-alvo"
  "mover"      = "movido-ou-migrado-no-alvo"
  "substituir" = "substituido-por-fonte-canonica"
}

foreach ($row in $rows) {
  $source = Resolve-LogicalSource $row.caminho_origem
  if (-not (Test-Path -LiteralPath $source.physical -PathType Leaf)) {
    $sourceMismatches.Add("ausente:$($row.caminho_origem)")
    continue
  }
  $sourceHash = Get-Sha256 $source.physical
  $sourceSize = (Get-Item -LiteralPath $source.physical).Length
  $sourceValid = $sourceHash -eq $row.sha256 -and $sourceSize -eq [long]$row.tamanho_bytes
  if (-not $sourceValid) {
    $sourceMismatches.Add("hash-ou-tamanho:$($row.caminho_origem)")
  }

  $candidates = [Collections.Generic.List[object]]::new()
  $defaultPrefix = if ($source.prefix -eq "gaiatec-documentacao") { "gaiatec-documentacao" } elseif ($source.prefix -eq "gaiatec-cms") { "gaiatec-cms" } else { "" }
  foreach ($logicalDestination in @($row.destino_recomendado -split "\s*;\s*")) {
    Add-ExistingCandidate $candidates $logicalDestination $defaultPrefix
  }
  Add-ExistingCandidate $candidates $row.documento_canonico $defaultPrefix

  if ($row.acao -eq "ignorar") {
    Add-ExistingCandidate $candidates $row.caminho_origem ""
  }

  if ($candidates.Count -eq 0 -and $docsHashIndex.ContainsKey($sourceHash)) {
    foreach ($candidate in $docsHashIndex[$sourceHash]) {
      if (@($candidates | Where-Object { $_.logical -eq $candidate.logical }).Count -eq 0) { $candidates.Add($candidate) }
    }
  }
  if ($candidates.Count -eq 0 -and $cmsHashIndex.ContainsKey($sourceHash)) {
    foreach ($candidate in $cmsHashIndex[$sourceHash]) {
      if (@($candidates | Where-Object { $_.logical -eq $candidate.logical }).Count -eq 0) { $candidates.Add($candidate) }
    }
  }

  if ($candidates.Count -eq 0) {
    $unresolved.Add($row.caminho_origem)
  }

  if ($row.destino_recomendado -match "(^|;\s*)arquivo-historico:") {
    $archiveRequiredRows += 1
    $exactArchiveCandidates = @($candidates | Where-Object {
        $_.logical.StartsWith("arquivo-historico:", [StringComparison]::OrdinalIgnoreCase) -and
        $_.sha256 -eq $sourceHash
      })
    if ($exactArchiveCandidates.Count -eq 0) {
      $archiveMismatches.Add($row.caminho_origem)
    }
    else {
      $archiveExactRows += 1
    }
  }

  $destinationValues = @($candidates | ForEach-Object { $_.logical })
  $destinationHashes = @($candidates | ForEach-Object { "$($_.logical)=$($_.sha256)" })
  $destinationChecks = @($candidates | ForEach-Object {
      if ($_.sha256 -eq $sourceHash) {
        "$($_.logical)=hash-identico"
      }
      else {
        "$($_.logical)=sucessor-transformado-origem-preservada@$($row.commit_origem)"
      }
    })

  $finalRows.Add([pscustomobject][ordered]@{
      caminho_origem       = $row.caminho_origem
      sha256_origem        = $row.sha256
      tamanho_bytes        = $row.tamanho_bytes
      repositorio_origem   = $row.repositorio_origem
      commit_origem        = $row.commit_origem
      categoria_documental = $row.categoria_documental
      status_proposto      = $row.status_proposto
      documento_canonico   = $row.documento_canonico
      destino_recomendado  = $row.destino_recomendado
      acao                 = $row.acao
      justificativa        = $row.justificativa
      dependencias         = $row.dependencias
      status_execucao      = $statusByAction[$row.acao]
      destino_efetivo      = $destinationValues -join "; "
      sha256_destino       = $destinationHashes -join "; "
      validacao_origem     = if ($sourceValid) { "hash-e-tamanho-identicos-ao-snapshot" } else { "divergente" }
      validacao_destino    = $destinationChecks -join "; "
      recuperacao          = if ($row.commit_origem -ne "n/a") { "origem-fisica-retida-e-Git@$($row.commit_origem)" } else { "origem-fisica-retida" }
    })
}

if ($sourceMismatches.Count -gt 0) {
  throw "Manifesto final interrompido: $($sourceMismatches.Count) origem(ns) divergente(s)."
}
if ($unresolved.Count -gt 0) {
  $sample = ($unresolved | Select-Object -First 10) -join "; "
  throw "Manifesto final interrompido: $($unresolved.Count) destino(s) nao resolvido(s). Amostra: $sample"
}
if ($archiveMismatches.Count -gt 0) {
  $sample = ($archiveMismatches | Select-Object -First 10) -join "; "
  throw "Manifesto final interrompido: $($archiveMismatches.Count) copia(s) de arquivo sem hash identico. Amostra: $sample"
}
if ($finalRows.Count -ne $rows.Count) {
  throw "Contagem final divergente: $($finalRows.Count) de $($rows.Count)."
}

$outputCsvDirectory = Split-Path -Parent $OutputCsv
$outputJsonDirectory = Split-Path -Parent $OutputSummaryJson
New-Item -ItemType Directory -Force -Path $outputCsvDirectory | Out-Null
New-Item -ItemType Directory -Force -Path $outputJsonDirectory | Out-Null
$finalRows | Export-Csv -LiteralPath $OutputCsv -NoTypeInformation -Encoding utf8NoBOM

$summary = [ordered]@{
  generated_at_utc               = [DateTime]::UtcNow.ToString("o")
  record_count                   = $finalRows.Count
  source_hash_or_size_mismatches = $sourceMismatches.Count
  unresolved_destinations        = $unresolved.Count
  restricted_paths_processed     = $restrictedProcessed
  archive_rows_required          = $archiveRequiredRows
  archive_rows_hash_identical    = $archiveExactRows
  exact_destination_rows         = @($finalRows | Where-Object { $_.validacao_destino -match "hash-identico" }).Count
  transformed_successor_rows     = @($finalRows | Where-Object { $_.validacao_destino -match "sucessor-transformado" }).Count
  by_execution_status            = @($finalRows | Group-Object status_execucao | Sort-Object Name | ForEach-Object {
      [ordered]@{ status = $_.Name; count = $_.Count; bytes = [long](($_.Group | Measure-Object tamanho_bytes -Sum).Sum) }
    })
  safety                         = [ordered]@{
    source_files_retained             = $true
    archive_hashes_validated           = $true
    secrets_read                       = $false
    codex_worktrees_moved_or_inspected = $false
    deploy_executed                    = $false
    staging_or_production_touched      = $false
  }
}
$summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputSummaryJson -Encoding utf8NoBOM
Write-Output ($summary | ConvertTo-Json -Depth 8)
