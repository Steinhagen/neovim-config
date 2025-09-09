" Remove the default Neovim mapping for <Space>q in mail files.
" This prevents the old mapping from interfering.
silent! nunmap <buffer> <Space>q

" Create a new mapping: <leader>Q that will trigger the MailQuote action.
" The '<buffer>' argument ensures this mapping only exists in mail files.
nnoremap <buffer> <leader>Q <Plug>MailQuote

