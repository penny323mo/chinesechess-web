#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TASK="${1:-}"

if [[ -z "${TASK}" ]]; then
  echo "No task provided"
  exit 2
fi

echo "[run-once] repo=${REPO_DIR}"
echo "[run-once] task=${TASK}"
echo "[run-once] AUTO_DEPLOY=${AUTO_DEPLOY:-0}"

PROMPT_FILE="${REPO_DIR}/.agent/_prompt.txt"

cat > "${PROMPT_FILE}" <<PROMPT
You are a coding agent working inside this repo: ${REPO_DIR}

Read these files first:
- .agent/PROJECT.md
- .agent/MEMORY.md

Task:
${TASK}

Hard rules:
- Do NOT start long-running servers.
- Make minimal, focused changes.
- Do NOT touch tasks/*, .agent/_prompt.txt, node_modules, dist.
- After editing source files, STOP. Do not run git commit or deploy yourself.
- Update .agent/MEMORY.md only if there is a durable learning (short bullets).
PROMPT

cd "${REPO_DIR}"

# Let the model edit files
opencode run --dir "${REPO_DIR}" "$(cat "${PROMPT_FILE}")"

# Deterministic pipeline controlled by script
echo "[run-once] build..."
npm run build

# Stage only source + config + memory (never stage tasks logs)
git add -A \
  ':!tasks' \
  ':!.agent/_prompt.txt' \
  ':!node_modules' \
  ':!dist' || true

if git diff --cached --quiet; then
  echo "[run-once] no staged changes; skipping commit"
else
  MSG="chore: agent update"
  if [[ "${TASK}" =~ board\ skeleton ]]; then MSG="feat: board skeleton"; fi
  echo "[run-once] commit: ${MSG}"
  git commit -m "${MSG}"
fi

echo "[run-once] push..."
git push -u origin HEAD || git push

if [[ "${AUTO_DEPLOY:-0}" == "1" ]]; then
  echo "[run-once] deploy..."
  npm run deploy
else
  echo "[run-once] AUTO_DEPLOY!=1; skipping deploy"
fi
