" Build and return the renderer.
function! fern#renderer#nf#core#new() abort
	let l:renderers = {}
	let l:renderers.leaf = fern#renderer#nf#leaf_renderer#init()
	let l:renderers.branch = fern#renderer#nf#branch_renderer#init()
	let l:renderers.root = fern#renderer#nf#root_renderer#init()

	return {
		\ 'render': funcref('s:render', [l:renderers]),
		\ 'index': { lnum -> lnum - 1 },
		\ 'lnum': { index -> index + 1 },
		\ 'syntax': { -> v:null },
		\ 'highlight': { -> v:null }
	\ }
endfunction

" Render given nodes and return a list of lines with text properties.
function! s:render(renderers, nodes) abort
	let l:base = len(a:nodes[0].__key)
	return map(copy(a:nodes), { i, node ->
		\ s:render_node(a:renderers, node, l:base) })
endfunction

" Render a single node, returning the line of text with text properties.
function! s:render_node(renderers, node, base) abort
	let l:level = len(a:node.__key) - a:base
	if l:level is# 0
		return s:render_line(a:renderers.root(a:node))
	endif

	if a:node.status is# g:fern#STATUS_NONE
		return s:render_line(a:renderers.leaf(a:node, l:level))
	else
		return s:render_line(a:renderers.branch(a:node, l:level))
	endif
endfunction

" For one or more dict arguments, render a single line of text with text
" properties. As input, each dict must have:
"
"   - 'text': the text to render, and
"   - 'type': the name of the text property for this text
"
" This function will return a new dictionary:
"
"   - 'text': the entire line of text from all inputs, and
"   - 'props': list of text properties
function! s:render_line(...) abort
	let l:text = ''
	let l:props = []

	for item in flatten(copy(a:000))
		let l:col = len(l:text) + 1
		let l:length = len(item.text)

		let l:text .= item.text
		call add(l:props, { 'col': l:col, 'length': l:length, 'type': item.type })
	endfor

	return { 'text': l:text, 'props': l:props }
endfunction
