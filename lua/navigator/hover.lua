-- TODO: change background and use TextView?
local lsp = require("vim.lsp")

local mk_handler = require"navigator.util".mk_handler
return {
  hover_handler = mk_handler(function(_, result, ctx, cfg)
    vim.lsp.util.focusable_float(ctx.method or "Hover", function()
      if not (result and result.contents) then
        return
      end
      local markdown_lines = lsp.util.convert_input_to_markdown_lines(result.contents)
      markdown_lines = lsp.util.trim_empty_lines(markdown_lines)
      if vim.tbl_isempty(markdown_lines) then
        return
      end

      local bnr, contents_winid, _, border_winid =
          vim.lsp.util.fancy_floating_markdown(markdown_lines)
      lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, contents_winid)
      lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, border_winid)
      return bnr, contents_winid
    end)
  end)
}
