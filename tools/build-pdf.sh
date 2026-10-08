#!/usr/bin/env bash
# シート定義書.md から シート定義書.pdf を生成する。
# 必要なもの: pandoc、Chromium 系ブラウザ（Edge / Chrome）
# 使い方: bash tools/build-pdf.sh
#   ブラウザの場所は環境変数 BROWSER で上書きできる。
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_MD="${ROOT_DIR}/シート定義書.md"
OUT_PDF="${ROOT_DIR}/シート定義書.pdf"
CSS_REL="tools/pdf.css"   # HTML からの相対パス
DOC_TITLE="不動在庫・期限切迫・経過措置品 管理システム シート定義書"
DEFAULT_BROWSER="/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
BROWSER="${BROWSER:-$DEFAULT_BROWSER}"

fail() {
  echo "[build-pdf] $(date '+%Y-%m-%dT%H:%M:%S') ERROR: $*" >&2
  exit 1
}

command -v pandoc >/dev/null 2>&1 || fail "pandoc が見つからない"
[ -x "$BROWSER" ] || fail "ブラウザが見つからない: $BROWSER（環境変数 BROWSER で指定）"
[ -f "$SRC_MD" ] || fail "入力ファイルが無い: $SRC_MD"
[ -f "${ROOT_DIR}/${CSS_REL}" ] || fail "CSS が無い: ${ROOT_DIR}/${CSS_REL}"

WORK_DIR="$(mktemp -d)"
# 画像の相対パスを解決できるよう、HTML はリポジトリ直下に一時的に置く
HTML_FILE="${ROOT_DIR}/.build-tmp.html"
trap 'rm -rf "$WORK_DIR" "$HTML_FILE"' EXIT

pandoc "$SRC_MD" \
  --from gfm \
  --to html5 \
  --standalone \
  --metadata title="$DOC_TITLE" \
  --metadata lang=ja \
  --css "$CSS_REL" \
  --output "$HTML_FILE" \
  || fail "pandoc の変換に失敗"

to_win() { cygpath -w "$1" 2>/dev/null || echo "$1"; }

"$BROWSER" \
  --headless \
  --disable-gpu \
  --no-pdf-header-footer \
  --user-data-dir="$(to_win "$WORK_DIR")" \
  --print-to-pdf="$(to_win "$OUT_PDF")" \
  "file:///$(to_win "$HTML_FILE" | sed 's|\\|/|g')" \
  >/dev/null 2>&1 \
  || fail "PDF の出力に失敗"

[ -s "$OUT_PDF" ] || fail "PDF が空: $OUT_PDF"
echo "[build-pdf] 出力: $OUT_PDF"
