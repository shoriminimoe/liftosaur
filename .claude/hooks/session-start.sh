#!/bin/bash
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/../..}"

echo "==> npm install"
npm install --no-audit --no-fund

echo "==> localdomain.js"
npm run ensure:localdomain

# src/generated/*.ts, src/models/exerciseDescriptions.ts and theme.generated.css are
# gitignored codegen output that src/ imports at require time - without them even a
# single mocha test fails to load.
echo "==> codegen"
npm run build:markdown
npm run build:theme
npm run build:exercises
npm run build:programs

# The mocha suite fetches /programdata/* through MockFetch, which reads from dist/ -
# normally populated by webpack's CopyPlugin, so mirror that without a full build.
echo "==> dist/programdata"
mkdir -p dist
rm -rf dist/programdata
cp -r programdata dist/programdata

echo "==> ready: npm test | npm run lint | npm run check"
