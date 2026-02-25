#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
INBOX="${REPO_DIR}/tasks/inbox.txt"
DONE="${REPO_DIR}/tasks/done.log"
LOG="${REPO_DIR}/tasks/agent.log"
PIDFILE="${REPO_DIR}/tasks/agent.pid"

AUTO_DEPLOY="${AUTO_DEPLOY:-1}"
SLEEP_SEC="${SLEEP_SEC:-8}"

if [[ -f "${PIDFILE}" ]]; then
  OLD_PID="$(cat "${PIDFILE}" || true)"
  if [[ -n "${OLD_PID}" ]] && kill -0 "${OLD_PID}" 2>/dev/null; then
    echo "Agent already running pid=${OLD_PID}"
    exit 0
  fi
fi

echo $$ > "${PIDFILE}"
echo "[agent-loop] started pid=$$ repo=${REPO_DIR} AUTO_DEPLOY=${AUTO_DEPLOY}" | tee -a "${LOG}"

cd "${REPO_DIR}"

while true; do
  if [[ -s "${INBOX}" ]]; then
    TASK="$(head -n 1 "${INBOX}" | sed 's/[[:space:]]*$//')"
    if [[ -n "${TASK}" ]]; then
      echo "[agent-loop] picked task: ${TASK}" | tee -a "${LOG}"

      # pop first line
      tail -n +2 "${INBOX}" > "${INBOX}.tmp" || true
      mv "${INBOX}.tmp" "${INBOX}"

      # run
      ( export AUTO_DEPLOY="${AUTO_DEPLOY}" ; "${REPO_DIR}/.agent/run-once.sh" "${TASK}" ) 2>&1 | tee -a "${LOG}"

      echo "$(date '+%Y-%m-%d %H:%M:%S')  DONE  ${TASK}" >> "${DONE}"
      echo "[agent-loop] done task: ${TASK}" | tee -a "${LOG}"
    fi
  fi

  sleep "${SLEEP_SEC}"
done
