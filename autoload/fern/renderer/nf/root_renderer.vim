function! fern#renderer#nf#root_renderer#init() abort
	let l:options = {}

	let l:options.symbol = g:fern#renderer#nf#root_symbol
	let l:options.prop_symbol =
		\ s:build_prop('fern_renderer_root_symbol', 'FernRootSymbol')
	let l:options.prop_text =
		\ s:build_prop('fern_renderer_root_text', 'FernRootText')

	return funcref('s:render', [l:options])
endfunction

function! s:render(this, node) abort
	return [
		\ { 'text': a:this.symbol, 'type': a:this.prop_symbol },
		\ { 'text': a:node.label . a:node.badge, 'type': a:this.prop_text }
	\ ]
endfunction

function! s:build_prop(name, hl) abort
	if empty(prop_type_get(a:name))
		call prop_type_add(a:name, { 'highlight': a:hl })
	endif

	return a:name
endfunction
