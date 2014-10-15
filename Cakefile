{kit} = require 'nobone'

task 'dev', 'Dev', ->
	kit.monitor_app {
		bin: 'coffee'
		watch_list: 'test/basic.coffee'
		args: ['test/basic.coffee']
	}

task 'test', 'Test', ->
	kit.spawn 'coffee', ['test/basic.coffee']