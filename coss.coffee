do ->
	###*
	 * The core compiler of coss. Supports nested css and '&' self sugar.
	 * @param  {Object | Array} source The source data to compile.
	 * @param  {String} indent Default is 4 spaces.
	 * @return {String} The compiled code.
	 * @example
	 * ```coffeescript
	 * level = ->
	 * 	level.count ?= 1
	 * 	'.level_' + level.count++
	 *
	 * # Compile an array css tree.
	 * # The array compiler can use variable as css selector.
	 * coss [
	 * 	['#basic'
	 * 		['font-size', '12px']
	 * 		['opacity', 0.8]
	 * 	]
	 * 	[level()
	 * 		['background', 'red']
	 * 		['border', '1px solid #fff']
	 *
	 * 		['&:hover'
	 * 			['background', 'blue']
	 * 		]
	 *
	 * 		[level()
	 * 			['margin', '1px']
	 *
	 * 			[level()
	 * 				['padding', 0]
	 * 			]
	 * 		]
	 * 	]
	 * ]
	 *
	 * # Compile an object css tree.
	 * coss {
	 * 	'.level_1':
	 * 		background: 'red'
	 * 		border: '1px solid #fff'
	 *
	 * 		'.level_2':
	 * 			margin: '1px'
	 *
	 * 			'.level_3':
	 * 				padding: 0
	 * 	'#another':
	 * 		'font-size': '12px'
	 * 		opacity: 0.8
	 * }
	 * ```
	###
	coss = (source, indent = '    ') ->

		compile_obj = (node, parents) ->
			props = ''
			children = ''

			for sel, leaf of node
				if typeof leaf == 'object'
					if sel.charAt(0) == '&'
						children += compile_obj leaf, parents + sel[1..]
					else
						children += compile_obj leaf, parents + ' ' + sel
				else
					props += "#{indent}#{sel}: #{leaf};\n"

			"""
			#{parents} {
			#{props}}
			#{children}
			"""

		compile_arr = (node, parents) ->
			props = ''
			children = ''

			parents += node[0]
			for leaf in node[1..]
				defs = leaf[1]
				if typeof defs == 'object'
					sel = leaf[0]
					if sel.charAt(0) == '&'
						leaf[0] = sel[1..]
						children += compile_arr leaf, parents
					else
						children += compile_arr leaf, parents + ' '
				else
					props += "#{indent}#{leaf[0]}: #{defs};\n"

			"""
			#{parents} {
			#{props}}
			#{children}
			"""

		type_error = ->
			throw new Error('The type of source is incorrect.')

		if typeof source == 'object'
			ret = ''
			if typeof source.length == 'number'
				for node in source
					if typeof node == 'object'
						ret += compile_arr node, ''
					else
						type_error()
			else
				for k, node of source
					if typeof node == 'object'
						ret += compile_obj node, k
					else
						type_error()
			ret
		else
			type_error()

	# AMD Support
	if typeof module == "object" and module and typeof module.exports == "object"
		module.exports = coss
	else
		if typeof define == "function" and define.amd
			define -> coss
		else
			window.coss = coss
