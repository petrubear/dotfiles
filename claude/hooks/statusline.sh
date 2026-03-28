#!/usr/bin/env bash
# Claude Code status line with context and usage bars

input=$(cat)

# --- Extract fields ---
model=$(echo "$input" | jq -r '.model.display_name // "?"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir_name=$(basename "$current_dir")

# Context: used percentage (0-100)
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Usage: 5-hour rate limit (Pro/Max) or cost fallback
usage_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
weekly_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# --- Git info ---
git_info=""
if git -C "$current_dir" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$current_dir" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    dirty=""
    if ! git -C "$current_dir" --no-optional-locks diff --quiet 2>/dev/null || \
       ! git -C "$current_dir" --no-optional-locks diff --cached --quiet 2>/dev/null; then
      dirty="*"
    fi
    git_info=$(printf " \033[36mon\033[0m \033[35m%s%s\033[0m" "$branch" "$dirty")
  fi
fi

# --- Bar renderer ---
# Usage: render_bar <percentage_used> <bar_width>
# Returns colored bar string
render_bar() {
  local pct=$1
  local width=${2:-10}
  local filled=$(( pct * width / 100 ))
  local empty=$(( width - filled ))

  # Color: green < 50, yellow 50-80, red > 80
  local color
  if [ "$pct" -gt 80 ]; then
    color="\033[31m" # red
  elif [ "$pct" -gt 50 ]; then
    color="\033[33m" # yellow
  else
    color="\033[32m" # green
  fi

  local bar=""
  for ((i=0; i<filled; i++)); do bar+="●"; done
  for ((i=0; i<empty; i++)); do bar+="○"; done

  printf "%b%s\033[0m" "$color" "$bar"
}

# --- Build context bar ---
ctx_display=""
if [ -n "$ctx_used" ]; then
  ctx_pct=${ctx_used%.*}  # strip decimals
  ctx_pct=${ctx_pct:-0}
  ctx_bar=$(render_bar "$ctx_pct" 10)
  ctx_display=$(printf " \033[2mctx\033[0m %s \033[2m%s%%\033[0m" "$ctx_bar" "$ctx_pct")
fi

# --- Build usage bar (5-hour) ---
usage_display=""
if [ -n "$usage_pct" ]; then
  use_pct=${usage_pct%.*}
  use_pct=${use_pct:-0}
  use_bar=$(render_bar "$use_pct" 10)
  usage_display=$(printf " \033[2muse\033[0m %s \033[2m%s%%\033[0m" "$use_bar" "$use_pct")
elif [ -n "$cost" ] && [ "$cost" != "0" ]; then
  usage_display=$(printf " \033[2m$\033[0m\033[33m%s\033[0m" "$cost")
fi

# --- Build weekly bar ---
weekly_display=""
if [ -n "$weekly_pct" ]; then
  wk_pct=${weekly_pct%.*}
  wk_pct=${wk_pct:-0}
  wk_bar=$(render_bar "$wk_pct" 10)
  weekly_display=$(printf " \033[2mweek\033[0m %s \033[2m%s%%\033[0m" "$wk_bar" "$wk_pct")
fi

# --- Output ---
printf "\033[32m%s\033[0m \033[34min\033[0m \033[36m%s\033[0m%s%s%s%s" \
  "$model" "$dir_name" "$git_info" "$ctx_display" "$usage_display" "$weekly_display"
