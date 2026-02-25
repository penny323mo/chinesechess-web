# chinesechess-web project room

Goal
Build a Chinese chess (Xiangqi) web game deployed on GitHub Pages.

Repo
penny323mo/chinesechess-web

Conventions
- Keep changes small and commit often
- Prefer plain JS + SVG for UI
- Always run: npm run build before committing
- Deploy with: npm run deploy (gh-pages)

Files
- tasks/inbox.txt: task queue (one task per line)
- tasks/done.log: completed tasks log
- .agent/MEMORY.md: persistent memory for the agent
- .agent/agent-loop.sh: background worker
- .agent/run-once.sh: executes one task via opencode
