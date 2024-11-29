function! s:build_prop(name, hl) abort
	if empty(prop_type_get(a:name))
		call prop_type_add(a:name, { 'highlight': a:hl })
	endif

	return a:name
endfunction

function! fern#renderer#nf#branch_renderer#init() abort
	let l:options = {}

	let l:options.symbol_leading = g:fern#renderer#nf#leading
	let l:options.symbol_expanded = g:fern#renderer#nf#branch_expanded_symbol
	let l:options.symbol_collapsed = g:fern#renderer#nf#branch_collapsed_symbol
	let l:options.symbol_symlink_expanded = g:fern#renderer#nf#branch_expanded_symlink_symbol
	let l:options.symbol_symlink_collapsed = g:fern#renderer#nf#branch_collapsed_symlink_symbol

	let l:options.prop_leading =
		\ s:build_prop('fern_renderer_leading', 'FernLeaderSymbol')
	let l:options.prop_symbol =
		\ s:build_prop('fern_renderer_branch_symbol', 'FernBranchSymbol')
	let l:options.prop_text =
		\ s:build_prop('fern_renderer_branch_text', 'FernBranchText')
	let l:options.prop_text_symlink =
		\ s:build_prop('fern_renderer_branch_symlink_text', 'FernBranchSymlinkText')
	let l:options.prop_special =
		\ s:build_prop('fern_renderer_branch_special', 'FernSpecialNode')

	return funcref('s:render', [l:options])
endfunction

function! s:render(this, node, level) abort
	return [
		\ s:render_leader(a:this, a:node, a:level),
		\ s:render_symbol(a:this, a:node),
		\ s:render_text(a:this, a:node)
	\ ]
endfunction

function! s:render_leader(this, node, level) abort
	return {
		\ 'text': repeat(a:this.symbol_leading, a:level - 1),
		\ 'type': a:this.prop_leading
	\ }
endfunction

function! s:render_symbol(this, node) abort
	let [l:symbol, l:prop] = s:get_symbol(a:this, a:node)

	return { 'text': l:symbol, 'type': l:prop }
endfunction

function! s:render_text(this, node) abort
	let l:prop = s:is_symlink(a:node) ?
		\ a:this.prop_text_symlink : a:this.prop_text
	let l:prop = s:is_special(a:node) ? a:this.prop_special : l:prop

	return { 'text': a:node.label . a:node.badge, 'type': l:prop }
endfunction

function! s:get_symbol(this, node) abort
	let l:symbol = a:node.status == g:fern#STATUS_COLLAPSED ?
		\ a:this.symbol_collapsed : a:this.symbol_expanded
	let l:prop = s:is_special(a:node) ? a:this.prop_special : a:this.prop_symbol

	if s:is_symlink(a:node)
		let l:symbol = a:node.status == g:fern#STATUS_COLLAPSED ?
			\ a:this.symbol_symlink_collapsed : a:this.symbol_symlink_expanded
	endif

	return [l:symbol, l:prop]
endfunction

function! s:is_symlink(node) abort
	return getftype(a:node._path) == 'link'
endfunction

function! s:is_special(node) abort
	for key in a:node.__key
		if index(g:fern#renderer#nf#special_nodes, key) >= 0
			return v:true
		endif
	endfor

	return v:false
endfunction
