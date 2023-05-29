# https://docs.ruby-lang.org/ja/latest/library/irb.html

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 10_000
IRB.conf[:USE_AUTOCOMPLETE] = false

# サジェストの色を変更する
IRB.conf[:SUGGEST_COLOR] = "\e[1;32m"

# 新しいプロンプトモード MY_PROMPT を作成する
IRB.conf[:PROMPT][:MY_PROMPT] = {
  PROMPT_I: 'irb>',       # 通常時のプロンプト
  PROMPT_N: '*',          # 継続行のプロンプト
  PROMPT_S: 'irb>*',      # 文字列などの継続行のプロンプト
  PROMPT_C: 'irb>*',      # 式が継続している時のプロンプト
  RETURN: "==>%s\n"       # メソッドから戻る時のプロンプト
}

# プロンプトモード MY_PROMPT を使う
# IRB.conf[:PROMPT_MODE] = :MY_PROMPT
