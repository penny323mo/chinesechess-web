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
- After editing, run: npm run build
- If build passes, git status should show changes.
- Commit with a clear message.
- If AUTO_DEPLOY=1, run: npm run deploy

Update .agent/MEMORY.md with any durable learnings (short bullet points).
PROMPT

cd "${REPO_DIR}"

# Execute via opencode (local, no Telegram timeout)
opencode run --dir "${REPO_DIR}" "$(cat "${PROMPT_FILE}")"
