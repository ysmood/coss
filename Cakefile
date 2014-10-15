{kit} = require 'nobone'
{_} = kit

task 'dev', 'Dev', ->
	kit.monitor_app {
		bin: 'coffee'
		watch_list: 'test/basic.coffee'
		args: ['test/basic.coffee']
	}

task 'test', 'Test', ->
	kit.spawn 'coffee', ['test/basic.coffee']


task 'build', 'Build readme', ->
	kit.readFile 'coss.coffee'
	.then (str) ->
		parsed = kit.parse_comment '', str
		method_str = "## #{parsed[0].name}\n\n"

		for tag in parsed[0].tags
			tname = if tag.name then "`#{tag.name}`" else ''
			ttype = if tag.type then "{ _#{tag.type}_ }" else ''
			method_str += """
			**<u>#{tag.tag_name}</u>**: #{tname} #{ttype}
			"""
			method_str += '\n\n'
			if tag.description
				method_str += tag.description
				method_str += '\n\n'

		kit.readFile 'readme.ejs.md'
		.then (str) ->
			_.template str, {api: method_str}
	.then (readme) ->
		kit.outputFile 'readme.md', readme
