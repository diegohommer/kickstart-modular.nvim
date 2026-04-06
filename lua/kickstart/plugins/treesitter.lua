return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      -- 1. Crucial: Sets the install directory and prepends it to Neovim's runtimepath
      -- This forces Neovim to use nvim-treesitter's rich queries over the minimal built-in ones.
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }

      local parsers = {
        'bash',
        'c',
        'cpp',
        'diff',
        'html',
        'javascript',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'ruby',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
      }

      -- Asynchronously installs your parsers
      require('nvim-treesitter').install(parsers)

      -- Feature activation using Neovim core APIs
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('custom-treesitter', { clear = true }),
        desc = 'Enable treesitter highlighting and indentation',
        callback = function(event)
          local buf = event.buf
          local ft = vim.bo[buf].filetype

          -- Trigger treesitter highlighting (fails silently if parser isn't downloaded yet)
          pcall(vim.treesitter.start, buf)

          -- Indentation fallback
          if ft ~= 'ruby' then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          -- Regex syntax fallback for Ruby
          if ft == 'ruby' then
            vim.bo[buf].syntax = 'on'
          end
        end,
      })
    end,
  },
}
