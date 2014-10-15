{kit} = require 'nobone'
assert = require 'assert'

coss = require '../coss.coffee'

level = ->
	level.count ?= 1
	'.level_' + level.count++

src_arr = [
	[level()
		['background', 'red']
		['border', '1px solid #fff']

		[level()
			['margin', '1px']

			['&:hover'
				['background', 'blue']
			]

			[level()
				['padding', 0]
			]
		]
	]
	['#another'
		['font-size', '12px']
		['opacity', 0.8]
	]
	['#another'
		['opacity', 0.7]
	]
]

src_obj =
	'.level_1':
		background: 'red'
		border: '1px solid #fff'

		'.level_2':
			margin: '1px'

			'&:hover':
				background: 'blue'

			'.level_3':
				padding: 0
	'#another':
		'font-size': '12px'
		opacity: 0.8

out = coss(src_arr)
console.log out
assert.equal out, """
.level_1 {
    background: red;
    border: 1px solid #fff;
}
.level_1 .level_2 {
    margin: 1px;
}
.level_1 .level_2:hover {
    background: blue;
}
.level_1 .level_2 .level_3 {
    padding: 0;
}
#another {
    font-size: 12px;
    opacity: 0.8;
}
#another {
    opacity: 0.7;
}

"""

out = coss(src_obj)
console.log out
assert.equal out, """
.level_1 {
    background: red;
    border: 1px solid #fff;
}
.level_1 .level_2 {
    margin: 1px;
}
.level_1 .level_2:hover {
    background: blue;
}
.level_1 .level_2 .level_3 {
    padding: 0;
}
#another {
    font-size: 12px;
    opacity: 0.8;
}

"""
