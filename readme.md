# COSS

```
npm install coss

# Or use in browser. Note that only the `coss.min.js` is build for browser.
bower install coss
```

# API

## coss

**<u>param</u>**: `source` { _Object | Array_ }

The source data to compile.

**<u>param</u>**: `indent` { _String_ }

Default is 4 spaces.

**<u>return</u>**:  { _String_ }

The compiled code.

**<u>example</u>**:  

```coffeescript
level = ->
	level.count ?= 1
	'.level_' + level.count++

# Compile an array css tree.
# The array compiler can use variable as css selector.
coss [
	['#basic'
		['font-size', '12px']
		['opacity', 0.8]
	]
	[level()
		['background', 'red']
		['border', '1px solid #fff']

		['&:hover'
			['background', 'blue']
		]

		[level()
			['margin', '1px']

			[level()
				['padding', 0]
			]
		]
	]
]

# Compile an object css tree.
coss {
	'.level_1':
		background: 'red'
		border: '1px solid #fff'

		'.level_2':
			margin: '1px'

			'.level_3':
				padding: 0
	'#another':
		'font-size': '12px'
		opacity: 0.8
}
```


