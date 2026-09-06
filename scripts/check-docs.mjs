import { existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { dirname, extname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const ignoredDirectories = new Set([".codex-worktrees", ".git", ".secrets", "node_modules"]);
const textExtensions = new Set([".json", ".md", ".yaml", ".yml"]);
const metadataKeys = [
  "id",
  "titulo",
  "status",
  "tipo",
  "area",
  "fase",
  "ambiente",
  "responsavel",
  "data_criacao",
  "ultima_revisao",
  "fonte_canonica",
  "substitui",
  "relacionados",
];
const metadataRequiredFiles = new Set([
  "README.md",
  "GOVERNANCA.md",
  "ORIGEM.md",
  "CONTROLES_REPOSITORIO.md",
  "docs/30-cms/manual-do-usuario/README.md",
  "docs/70-governanca-legal/atribuicoes.md",
  "docs/70-governanca-legal/controles-repositorio.md",
  "docs/70-governanca-legal/governanca.md",
  "docs/70-governanca-legal/origem.md",
  "docs/80-evolucao/ev2/README.md",
  "docs/80-evolucao/ev2/fase-12/registro-encerramento-g12-2026-09-06.md",
  "docs/80-evolucao/ev2/fase-16/evidencias-controles-2026-09-06.md",
  "docs/80-evolucao/ev2/fase-16/registro-declaracao-governanca-dpo-risco-2026-09-06.md",
  "docs/80-evolucao/ev2/fase-16/evidencias/originais-artifacts/README.md",
  "docs/80-evolucao/ev2/fase-17/README.md",
]);

const secretPatterns = [
  ["GitHub token", /\bgh[pousr]_[A-Za-z0-9]{30,}\b/],
  ["GitHub fine-grained token", /\bgithub_pat_[A-Za-z0-9_]{50,}\b/],
  ["Supabase secret key", /\bsb_secret_[A-Za-z0-9._-]{20,}\b/],
  ["provider secret key", /\bsk-[A-Za-z0-9_-]{20,}\b/],
  ["AWS access key", /\bAKIA[A-Z0-9]{16}\b/],
  ["private key", /-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/],
];

function walk(directory) {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    if (entry.isDirectory() && ignoredDirectories.has(entry.name)) return [];
    const absolute = resolve(directory, entry.name);
    return entry.isDirectory() ? walk(absolute) : [absolute];
  });
}

function normalizeLinkTarget(target) {
  const withoutTitle = target
    .trim()
    .replace(/^<|>$/g, "")
    .split(/\s+["']/u, 1)[0];
  const withoutFragment = withoutTitle.split("#", 1)[0].split("?", 1)[0];
  try {
    return decodeURIComponent(withoutFragment);
  } catch {
    return withoutFragment;
  }
}

const files = walk(root);
const failures = [];
let markdownFiles = 0;
let localLinks = 0;

for (const file of files) {
  const extension = extname(file).toLowerCase();
  if (!textExtensions.has(extension)) continue;

  const content = readFileSync(file, "utf8");
  const relative = file.slice(root.length + 1).replaceAll("\\", "/");

  for (const [label, pattern] of secretPatterns) {
    if (pattern.test(content)) failures.push(`${relative}: padrão sensível detectado (${label})`);
  }

  if (extension !== ".md") continue;
  markdownFiles += 1;

  const requiresMetadata =
    metadataRequiredFiles.has(relative) ||
    relative.startsWith("docs/00-indice/") ||
    /(?:^|\/)indice\.md$/u.test(relative);
  if (requiresMetadata) {
    const frontmatter = content.match(/^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/u)?.[1];
    if (!frontmatter) {
      failures.push(`${relative}: frontmatter obrigatório ausente`);
    } else {
      for (const key of metadataKeys) {
        if (!new RegExp(`^${key}:`, "mu").test(frontmatter)) {
          failures.push(`${relative}: metadado obrigatório ausente (${key})`);
        }
      }
    }
  }

  const links = content.matchAll(/!?\[[^\]]*\]\(([^)]+)\)/gu);
  for (const match of links) {
    const rawTarget = match[1].trim();
    if (!rawTarget || rawTarget.startsWith("#") || /^(?:https?:|mailto:|tel:)/iu.test(rawTarget)) {
      continue;
    }

    localLinks += 1;
    const target = normalizeLinkTarget(rawTarget);
    const absoluteTarget = resolve(dirname(file), target);
    if (!existsSync(absoluteTarget)) {
      failures.push(`${relative}: link local ausente (${rawTarget})`);
    } else if (!statSync(absoluteTarget).isFile() && !statSync(absoluteTarget).isDirectory()) {
      failures.push(`${relative}: destino local inválido (${rawTarget})`);
    }
  }
}

if (failures.length > 0) {
  console.error(`DOCS_CHECK_FAILED (${failures.length})`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exitCode = 1;
} else {
  console.log(
    JSON.stringify({
      outcome: "DOCS_CHECK_PASS",
      markdownFiles,
      localLinks,
      sensitivePatterns: 0,
    }),
  );
}
