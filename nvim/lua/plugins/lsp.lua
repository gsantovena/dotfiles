return {
  -- LSP and completion (COC)
  {
    "neoclide/coc.nvim",
    branch = "release",
    init = function()
      vim.opt.backup = false
      vim.opt.writebackup = false
      vim.opt.updatetime = 300
      vim.opt.signcolumn = "yes"

      vim.g.coc_global_extensions = {
        "coc-css",
        "coc-docker",
        "coc-eslint",
        "coc-explorer",
        "coc-git",
        "coc-go",
        "coc-html",
        "coc-json",
        "coc-markdownlint",
        "coc-webview",
        "coc-markdown-preview-enhanced",
        "coc-marketplace",
        "coc-pairs",
        "coc-prettier",
        "coc-pyright",
        "coc-sh",
        "coc-solargraph",
        "coc-sql",
        "coc-syntax",
        "coc-terraform",
        "coc-tsserver",
        "coc-yaml",
      }

      vim.cmd([[
        inoremap <silent><expr> <TAB>
              \ coc#pum#visible() ? coc#pum#next(1) :
              \ CheckBackspace() ? "\<Tab>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction

        if has('nvim')
          inoremap <silent><expr> <c-space> coc#refresh()
        else
          inoremap <silent><expr> <c-@> coc#refresh()
        endif

        nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
        nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

        nmap <silent><nowait> gd <Plug>(coc-definition)
        nmap <silent><nowait> gy <Plug>(coc-type-definition)
        nmap <silent><nowait> gi <Plug>(coc-implementation)
        nmap <silent><nowait> gr <Plug>(coc-references)

        nnoremap <silent> K :call ShowDocumentation()<CR>

        function! ShowDocumentation()
          if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
          else
            call feedkeys('K', 'in')
          endif
        endfunction

        augroup coc_user_config
          autocmd!
          autocmd CursorHold * silent call CocActionAsync('highlight')
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        augroup END

        nmap <leader>rn <Plug>(coc-rename)

        xmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)

        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>ac  <Plug>(coc-codeaction-cursor)
        nmap <leader>as  <Plug>(coc-codeaction-source)
        nmap <leader>qf  <Plug>(coc-fix-current)

        nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
        xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
        nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

        nmap <leader>cl  <Plug>(coc-codelens-action)

        xmap if <Plug>(coc-funcobj-i)
        omap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap af <Plug>(coc-funcobj-a)
        xmap ic <Plug>(coc-classobj-i)
        omap ic <Plug>(coc-classobj-i)
        xmap ac <Plug>(coc-classobj-a)
        omap ac <Plug>(coc-classobj-a)

        if has('nvim-0.4.0') || has('patch-8.2.0750')
          nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
          vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        endif

        nmap <silent> <C-s> <Plug>(coc-range-select)
        xmap <silent> <C-s> <Plug>(coc-range-select)

        command! -nargs=0 Format :call CocActionAsync('format')
        command! -nargs=? Fold :call CocAction('fold', <f-args>)
        command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

        nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
        nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
        nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
        nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
        nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
        nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
        nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
        nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

        nnoremap <leader>e :CocCommand explorer --toggle --position left<CR>
        nnoremap <F10> :CocCommand explorer --toggle --position left<CR>
        map <C-p> :CocCommand markdown-preview-enhanced.openPreview<CR>
        map <C-S-p> :CocCommand markdown-preview-enhanced.syncPreview<CR>

        nmap <leader>gs :CocCommand git.status<CR>
        nmap <leader>gd :CocCommand git.diff<CR>
        nmap <leader>gl :CocCommand git.log<CR>
        nmap <leader>gb :CocCommand git.blame<CR>
      ]])
    end,
  },
}
