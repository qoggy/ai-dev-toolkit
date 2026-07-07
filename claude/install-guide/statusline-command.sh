#!/usr/bin/env bash
# Claude Code statusLine：模型 · 上下文用量 · effort · 成本 · 限流
input=$(cat)

IFS=$'\t' read -r model_name used size pct effort cost h5 d7 <<<"$(echo "$input" | jq -r '
  [ .model.display_name
  , .context_window.total_input_tokens
  , .context_window.context_window_size
  , .context_window.used_percentage
  , .effort.level
  , .cost.total_cost_usd
  , .rate_limits.five_hour.used_percentage
  , .rate_limits.seven_day.used_percentage
  ] | map(if . == null then "" else . end) | @tsv')"

# 去掉 display_name 里的括号后缀，如 "Opus 4.8 (1M context)" -> "Opus 4.8"
model_label="${model_name%% (*}"

# 还没有 API 响应时只显示模型名
if [ -z "$pct" ]; then
  echo "$model_label"
  exit 0
fi

fmt() { [ "$1" -ge 1000 ] 2>/dev/null && echo "$(( $1 / 1000 ))k" || echo "${1:-?}"; }
pct_int=$(printf "%.0f" "$pct")

# 上下文：按用量百分比着色
if   [ "$pct_int" -ge 90 ]; then c="\033[31m"   # 红
elif [ "$pct_int" -ge 70 ]; then c="\033[33m"   # 黄
else c="\033[0m"; fi
out="${model_label} · ${c}$(fmt "$used")/$(fmt "$size") (${pct_int}%)\033[0m"

# effort
[ -n "$effort" ] && out="$out · $effort"

# 成本（保留 3 位小数）
[ -n "$cost" ] && out="$out · \$$(printf "%.3f" "$cost")"

# 限流（仅 Pro/Max 订阅且有数据时出现）
rl=""
[ -n "$h5" ] && rl="5h $(printf "%.0f" "$h5")%"
[ -n "$d7" ] && rl="${rl:+$rl }7d $(printf "%.0f" "$d7")%"
[ -n "$rl" ] && out="$out · $rl"

printf "%b" "$out"
