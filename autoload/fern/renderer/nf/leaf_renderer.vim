function! s:build_prop(name, hl) abort
	if empty(prop_type_get(a:name))
		call prop_type_add(a:name, { 'highlight': a:hl })
	endif

	return a:name
endfunction

function! fern#renderer#nf#leaf_renderer#init() abort
	let l:options = {}

	let l:options.symbol_leading = g:fern#renderer#nf#leading
	let l:options.symbol_files = g:fern#renderer#nf#leaf_symbols
	let l:options.symbol_default = g:fern#renderer#nf#default_leaf_symbol
	let l:options.symbol_symlink = g:fern#renderer#nf#leaf_symlink_symbol

	let l:options.prop_leading =
		\ s:build_prop('fern_renderer_leading', 'FernLeaderSymbol')
	let l:options.prop_files =
		\ map(copy(g:fern#renderer#nf#leaf_symbol_colors),
			\ { f_name, f_color ->
				\ s:build_prop('fern_renderer_leaf_' . f_name . '_symbol', f_color) })
	let l:options.prop_default =
		\ s:build_prop('fern_renderer_leaf_symbol', 'FernLeafSymbol')
	let l:options.prop_symlink =
		\ s:build_prop('fern_renderer_leaf_symlink_symbol', 'FernLeafSymlinkSymbol')
	let l:options.prop_text =
		\ s:build_prop('fern_renderer_leaf_text', 'FernLeafText')
	let l:options.prop_text_symlink =
		\ s:build_prop('fern_renderer_leaf_symlink_text', 'FernLeafSymlinkText')
	let l:options.prop_text_executable =
		\ s:build_prop('fern_renderer_leaf_exe_text', 'FernLeafExecutableText')
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
	let l:prop = s:is_executable(a:node) ?
		\ a:this.prop_text_executable : l:prop
	let l:prop = s:is_special(a:node) ?
		\ a:this.prop_special : l:prop
	let l:exe_marker = s:is_executable(a:node) ? '*' : ''

	return {
		\ 'text': a:node.label . a:node.badge . l:exe_marker,
		\ 'type': l:prop
	\ }
endfunction

function! s:get_symbol(this, node) abort
	let l:extension = fnamemodify(a:node.label, ':e')
	let l:tail = fnamemodify(a:node.label, ':t')

	let l:symbol = get(a:this.symbol_files, l:extension,
		\ get(a:this.symbol_files, l:tail, a:this.symbol_default))
	let l:prop = get(a:this.prop_files, l:extension,
		\ get(a:this.prop_files, l:tail, a:this.prop_default))

	if s:is_symlink(a:node)
		let l:symbol = a:this.symbol_symlink
		let l:prop = a:this.prop_symlink
	endif

	let l:prop = s:is_special(a:node) ?
		\ a:this.prop_special : l:prop

	return [l:symbol, l:prop]
endfunction

function! s:is_symlink(node) abort
	return getftype(a:node._path) == 'link'
endfunction

function! s:is_executable(node) abort
	return executable(a:node._path)
endfunction

function! s:is_special(node) abort
	for key in a:node.__key
		if index(g:fern#renderer#nf#special_nodes, key) >= 0
			return v:true
		endif
	endfor

	return v:false
endfunction
