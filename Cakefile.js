// Generated by CoffeeScript 1.3.3
(function() {
  var Coffees, build, exec, fs, javascripts, parser, path, print_error, source_files, spawn, uglify, util, version, write_javascripts, _ref, _ref1;

  fs = require('fs');

  path = require('path');

  _ref = require('child_process'), spawn = _ref.spawn, exec = _ref.exec;

  Coffees = require('coffee-script');

  util = require('util');

  _ref1 = require('uglify-js'), parser = _ref1.parser, uglify = _ref1.uglify;

  javascripts = {
    'public/javascripts/main.js': ['src/coffee/basic.coffee', 'src/coffee/global.coffee']
  };

  Array.prototype.unique = function() {
    var key, output, value, _i, _ref2, _results;
    output = {};
    for (key = _i = 0, _ref2 = this.length; 0 <= _ref2 ? _i < _ref2 : _i > _ref2; key = 0 <= _ref2 ? ++_i : --_i) {
      output[this[key]] = this[key];
    }
    _results = [];
    for (key in output) {
      value = output[key];
      _results.push(value);
    }
    return _results;
  };

  source_files = function() {
    var all_sources, javascript, source, sources, _results;
    all_sources = [];
    _results = [];
    for (javascript in javascripts) {
      sources = javascripts[javascript];
      _results.push((function() {
        var _i, _len, _results1;
        _results1 = [];
        for (_i = 0, _len = sources.length; _i < _len; _i++) {
          source = sources[_i];
          all_sources.push(source);
          _results1.push(all_sources.unique());
        }
        return _results1;
      })());
    }
    return _results;
  };

  version = function() {
    return ("" + (fs.readFileSync('VERSION'))).replace(/[^0-9a-zA-Z.]*/gm, '');
  };

  write_javascripts = function(filename, body, trailing) {
    if (trailing == null) {
      trailing = '';
    }
    fs.writeFileSync(filename, "// compiled globaljs VERSION " + (version()) + ", author is Cyril Kong\n// powered by cake + coffee.\n" + body + trailing);
    return console.log("Generated " + filename);
  };

  task('cook', 'build form sources', build = function(cb) {
    var code, file_contents, file_name, javascript, source, sources, _i, _len, _results;
    file_name = null;
    file_contents = null;
    try {
      _results = [];
      for (javascript in javascripts) {
        sources = javascripts[javascript];
        code = '';
        for (_i = 0, _len = sources.length; _i < _len; _i++) {
          source = sources[_i];
          file_name = source;
          file_contents = "" + (fs.readFileSync(source));
          code += Coffees.compile(file_contents, {
            bare: true
          });
        }
        write_javascripts(javascript, code);
        if (process.env.MINIFY !== 'false') {
          _results.push(write_javascripts(javascript.replace(/\.js$/, '.min.js'), uglify.gen_code(uglify.ast_squeeze(uglify.ast_mangle(parser.parse(code)))), ';'));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    } catch (e) {
      return print_error(e, file_name, file_contents);
    }
  });

  task('eat', 'watch src files and build them', function() {
    var file, _i, _len, _ref2, _results;
    console.log('Watching in src');
    invoke('cook');
    _ref2 = source_files();
    _results = [];
    for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
      file = _ref2[_i];
      _results.push(function(file) {
        return fs.watchFile(file, function(curr, prev) {
          if (+curr.mtime !== +prev.mtime) {
            console.log("Modify detected in " + file);
            return invoke('cook');
          }
        });
      });
    }
    return _results;
  });

  print_error = function(error, file_name, file_contents) {
    var contents_lines, first, index, last, line, line_number, _i, _len, _ref2, _results;
    line = error.message.match(/line ([0-9]+):/);
    if (line && line[1] && (line = parseInt(line[1]))) {
      contents_lines = file_contents.split("\n");
      first = line - 4 < 0 ? 0 : line - 4;
      last = line + 3 > contents_lines.size ? contents_lines.size : line + 3;
      console.log("Error compiling " + file_name + ":\n" + error.message);
      index = 0;
      _ref2 = contents_lines.slice(first, last);
      _results = [];
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        line = _ref2[_i];
        index++;
        line_number = first + 1 + index;
        _results.push(console.log("" + (((function() {
          var _j, _ref3, _results1;
          _results1 = [];
          for (_j = 0, _ref3 = 3 - (line_number.toString().length); 0 <= _ref3 ? _j <= _ref3 : _j >= _ref3; 0 <= _ref3 ? _j++ : _j--) {
            _results1.push(' ');
          }
          return _results1;
        })()).join('')) + " " + line));
      }
      return _results;
    } else {
      return console.log("Error compiling " + file_name + ":\n" + error.message);
    }
  };

}).call(this);