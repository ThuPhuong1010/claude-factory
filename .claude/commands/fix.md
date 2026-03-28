Auto-fix a bug. Usage: /fix [error message or file path]

1. Read the error
2. Search memory/bugs.md → seen this before?
   YES → apply known fix → verify → done
   NO → continue
3. Analyze root cause
4. Apply fix
5. Run related tests
6. If pass → append to memory/bugs.md:
   ### BUG-{N}: {title}
   - Symptom: ...
   - Root Cause: ...
   - Fix: ...
   - Prevention: ...
   - Status: FIXED
7. If fail after 3 attempts → log [NEEDS_HUMAN] in tracklog/active.md
