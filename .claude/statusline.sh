#!/bin/bash
# Claude Code statusline script
# stdin から JSON セッションデータを受け取り、ステータスラインを出力する

input=$(cat)

# フィールド抽出
MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
WT_NAME=$(echo "$input" | jq -r '.worktree.name // empty')
WT_PATH=$(echo "$input" | jq -r '.worktree.path // empty')
WT_BRANCH=$(echo "$input" | jq -r '.worktree.branch // empty')

# 色定義
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
MAGENTA='\033[35m'
RESET='\033[0m'

# コンテキスト使用率に基づいてバーの色を選択
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

# プログレスバー構築
FILLED=$((PCT / 10))
EMPTY=$((10 - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /█}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

# 期間計算
MINS=$((DURATION_MS / 60000))
SECS=$(((DURATION_MS % 60000) / 1000))

# コスト
COST_FMT=$(printf '$%.2f' "$COST")

# git ブランチ
BRANCH=""
if git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=" | 🌿 $(git -C "$DIR" branch --show-current 2>/dev/null)"
fi

# 1行目: モデル、ディレクトリ、gitブランチ
echo -e "${CYAN}[$MODEL]${RESET} 📁 ${DIR##*/}$BRANCH"
# 2行目: コンテキストバー、コスト、期間
echo -e "${BAR_COLOR}${BAR}${RESET} ${PCT}% | ${YELLOW}${COST_FMT}${RESET} | ⏱️ ${MINS}m ${SECS}s"
# 3行目: ワークツリー情報（アクティブ時のみ）
if [ -n "$WT_NAME" ]; then
    WT_PATH_SHORT="${WT_PATH##*/}"
    echo -e "${MAGENTA}🌳 ${WT_NAME}${RESET} | 🌿 ${WT_BRANCH} | 📂 ${WT_PATH_SHORT}"
fi
