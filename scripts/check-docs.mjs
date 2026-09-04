import { existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { dirname, extname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const ignoredDirectories = new Set([".git", "node_modules"]);
const textExtensions = new Set([".json", ".md", ".yaml", ".yml"]);

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
