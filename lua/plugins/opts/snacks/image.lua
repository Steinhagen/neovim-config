return {
  force = false,
  img_dirs = { 'img', 'images', 'assets', 'static', 'public', 'media', 'attachments' },
  cache = vim.fn.stdpath 'cache' .. '/snacks/image',
  env = {},
  formats = { 'png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp', 'tiff', 'heic', 'avif', 'mp4', 'mov', 'avi', 'mkv', 'webm', 'pdf', 'icns' },
  icons = { math = '󰪚 ', chart = '󰄧 ', image = ' ' },
  debug = { request = false, convert = false, placement = false },
  wo = {
    wrap = false,
    number = false,
    relativenumber = false,
    cursorcolumn = false,
    signcolumn = 'no',
    foldcolumn = '0',
    list = false,
    spell = false,
    statuscolumn = '',
  },
  doc = {
    enabled = true,
    inline = true,
    float = true,
    max_width = 80,
    max_height = 40,
    conceal = function(lang, type)
      return type == 'math'
    end,
  },
  convert = {
    notify = false,
    mermaid = function()
      local theme = vim.o.background == 'light' and 'neutral' or 'dark'
      return { '-i', '{src}', '-o', '{file}', '-b', 'transparent', '-t', theme, '-s', '{scale}' }
    end,
    magick = {
      default = { '{src}[0]', '-scale', '1920x1080>' },
      vector = { '-density', 192, '{src}[{page}]' },
      math = { '-density', 192, '{src}[{page}]', '-trim' },
      pdf = { '-density', 192, '{src}[{page}]', '-background', 'white', '-alpha', 'remove', '-trim' },
    },
  },
  math = {
    enabled = true,
    typst = {
      tpl = [[#set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))\n#show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")\n#set text(size: 12pt, fill: rgb("${color}"))\n${header}\n${content}]],
    },
    latex = {
      font_size = 'Large',
      packages = { 'amsmath', 'amssymb', 'amsfonts', 'amscd', 'mathtools' },
      tpl = [[\documentclass[preview,border=0pt,varwidth,12pt]{standalone}\n\usepackage{${packages}}\n\begin{document}\n${header}\n{ \${font_size} \selectfont\n  \color[HTML]{${color}}\n${content}}\n\end{document}]],
    },
  },
}
