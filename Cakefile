fs = require 'fs'
path = require 'path'
{spawn, exec} = require 'child_process'
Coffees = require 'coffee-script'
util = require 'util'
{parser, uglify} = require 'uglify-js'

javascripts =
    'public/javascripts/global.js' : [
        'src/coffee/global.coffee'
        'src/coffee/basic.coffee'
    ]

Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output

source_files = ->
    all_sources = []
    for javascript, sources of javascripts
        for source in sources
            all_sources.push source
        all_sources.unique()

version = ->
    "#{fs.readFileSync('VERSION')}".replace /[^0-9a-zA-Z.]*/gm, ''

write_javascripts = (filename, body, trailing='') ->
    fs.writeFileSync filename, """
    // compiled globaljs VERSION #{version()}, author is Cyril Kong
    // powered by cake + coffee.
    #{body}#{trailing}
    """
    console.log "Generated #{filename}"

task 'cook', 'build form sources', build = (cb) ->
    file_name = null
    file_contents = null
    try
        for javascript, sources of javascripts
            code = ''
            for source in sources
                file_name = source
                file_contents = "#{fs.readFileSync source}"
                code += Coffees.compile file_contents
            write_javascripts javascript, code
            unless process.env.MINIFY is 'false'
                write_javascripts javascript.replace(/\.js$/, '.min.js'), (
                    uglify.gen_code uglify.ast_squeeze uglify.ast_mangle parser.parse code
                ), ';'
    catch e
        print_error e, file_name, file_contents

task 'eat', 'watch src files and build them', ->
    invoke 'cook'
    console.log 'Watching in src'
    for javascript, sources of javascripts
        for source in sources
            file_name = source
            ((file_name) ->
                fs.watchFile file_name, (curr, prev) ->
                    if +curr.mtime isnt +prev.mtime
                        console.log "Modify detected in #{file_name}"
                        invoke 'cook'
            )(file_name)

print_error = (error, file_name, file_contents) ->
    line = error.message.match /line ([0-9]+):/
    if line and line[1] and line = parseInt(line[1])
        contents_lines = file_contents.split "\n"
        first = if line-4 < 0 then 0 else line-4
        last = if line+3 > contents_lines.size then contents_lines.size else line+3
        console.log """
        Error compiling #{file_name}:
        #{error.message}
        """
        index = 0
        for line in contents_lines[first...last]
            index++
            line_number = first + 1 + index
            console.log "#{(' ' for [0..(3-(line_number.toString().length))]).join('')} #{line}"
    else
        console.log """
        Error compiling #{file_name}:
        #{error.message}
        """