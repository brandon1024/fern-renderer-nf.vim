if exists('g:loaded_brandon1024_fern_renderer_nf_plugin')
	finish
endif
let g:loaded_brandon1024_fern_renderer_nf_plugin = 1

let g:fern#enable_textprop_support = 1

" renderer config
call extend(g:fern#renderers, {
	\ 'brandon1024/fern-renderer-nf.vim': function('fern#renderer#nf#core#new')
\ })

" plugin configs
if !exists('g:fern#renderer#nf#leading')
	let g:fern#renderer#nf#leading = ' │'
endif

if !exists('g:fern#renderer#nf#root_symbol')
	let g:fern#renderer#nf#root_symbol = '  '
endif

if !exists('g:fern#renderer#nf#default_leaf_symbol')
	let g:fern#renderer#nf#default_leaf_symbol = '  '
endif

if !exists('g:fern#renderer#nf#leaf_symlink_symbol')
	let g:fern#renderer#nf#leaf_symlink_symbol = '  '
endif

if !exists('g:fern#renderer#nf#branch_collapsed_symlink_symbol')
	let g:fern#renderer#nf#branch_collapsed_symlink_symbol = '   '
endif

if !exists('g:fern#renderer#nf#branch_expanded_symlink_symbol')
	let g:fern#renderer#nf#branch_expanded_symlink_symbol = '   '
endif

if !exists('g:fern#renderer#nf#branch_collapsed_symbol')
	let g:fern#renderer#nf#branch_collapsed_symbol = '   '
endif

if !exists('g:fern#renderer#nf#branch_expanded_symbol')
	let g:fern#renderer#nf#branch_expanded_symbol = '   '
endif

if !exists('g:fern#renderer#nf#symbol_file')
	let g:fern#renderer#nf#symbol_file = expand('<sfile>:p:h') . '/symbols.json'
endif

if !exists('g:fern#renderer#nf#leaf_symbols')
	let g:fern#renderer#nf#leaf_symbols =
		\ json_decode(join(readfile(g:fern#renderer#nf#symbol_file)))
endif

if !exists('g:fern#renderer#nf#symbol_colors_file')
	let g:fern#renderer#nf#symbol_colors_file = expand('<sfile>:p:h') . '/colors.json'
endif

if !exists('g:fern#renderer#nf#leaf_symbol_colors')
	let g:fern#renderer#nf#leaf_symbol_colors =
		\ json_decode(join(readfile(g:fern#renderer#nf#symbol_colors_file)))
endif

" default highlights
highlight default link FernLeaderSymbol      Directory
highlight default link FernRootSymbol        Directory
highlight default link FernBranchSymbol      Directory
highlight default link FernLeafSymbol        Directory
highlight default link FernLeafSymlinkSymbol FernLeafSymbol

highlight default link FernRootText           Normal
highlight default link FernBranchText         Normal
highlight default link FernBranchSymlinkText  FernBranchText
highlight default link FernLeafText           Normal
highlight default link FernLeafSymlinkText    FernLeafText
highlight default link FernLeafExecutableText FernLeafText

highlight default link FernLeafSymbolBlue   FernLeafSymbol
highlight default link FernLeafSymbolGreen  FernLeafSymbol
highlight default link FernLeafSymbolGrey   FernLeafSymbol
highlight default link FernLeafSymbolRed    FernLeafSymbol
highlight default link FernLeafSymbolPurple FernLeafSymbol
highlight default link FernLeafSymbolYellow FernLeafSymbol
highlight default link FernLeafSymbolPink   FernLeafSymbol
highlight default link FernLeafSymbolTeal   FernLeafSymbol
