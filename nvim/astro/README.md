# tree sitter について
astro のセットアップが終わっても tree sitter の install は手動で必要になります。
- ruby
- rust
- go
- python
- lua
このあたりは入っていれば良いと思う。

```lua
<cmd>TSInstall ruby<cr>
```

# lsp install について
LSPのサーバーも自分でinstall する必要がある。
これは現在のファイルの拡張子から判断して選択できるコマンドがあるため
それを使用してインストールすればよい。
```lua
<cmd>LspInstall<cr>
```
