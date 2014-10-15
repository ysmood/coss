(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
// Generated by CoffeeScript 1.8.0

/**
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
 */
var coss;

coss = function(source, indent) {
  var compile_arr, compile_obj, k, node, ret, type_error, _i, _len;
  if (indent == null) {
    indent = '    ';
  }
  compile_obj = function(node, parents) {
    var children, leaf, props, sel;
    props = '';
    children = '';
    parents += ' ';
    for (sel in node) {
      leaf = node[sel];
      if (typeof leaf === 'object') {
        if (sel.charAt(0) === '&') {
          children += compile_obj(leaf, parents.slice(0, -1) + sel.slice(1));
        } else {
          children += compile_obj(leaf, parents + sel);
        }
      } else {
        props += "" + indent + sel + ": " + leaf + ";\n";
      }
    }
    return "" + parents + "{\n" + props + "}\n" + children;
  };
  compile_arr = function(node, parents) {
    var children, defs, leaf, props, sel, _i, _len, _ref;
    props = '';
    children = '';
    parents += node[0] + ' ';
    _ref = node.slice(1);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      leaf = _ref[_i];
      defs = leaf[1];
      if (typeof defs === 'object') {
        sel = leaf[0];
        if (sel.charAt(0) === '&') {
          leaf[0] = sel.slice(1);
          children += compile_arr(leaf, parents.slice(0, -1));
        } else {
          children += compile_arr(leaf, parents);
        }
      } else {
        props += "" + indent + leaf[0] + ": " + defs + ";\n";
      }
    }
    return "" + parents + "{\n" + props + "}\n" + children;
  };
  type_error = function() {
    throw new Error('The type of source is incorrect.');
  };
  if (typeof source === 'object') {
    ret = '';
    if (typeof source.length === 'number') {
      for (_i = 0, _len = source.length; _i < _len; _i++) {
        node = source[_i];
        if (typeof node === 'object') {
          ret += compile_arr(node, '');
        } else {
          type_error();
        }
      }
    } else {
      for (k in source) {
        node = source[k];
        if (typeof node === 'object') {
          ret += compile_obj(node, k);
        } else {
          type_error();
        }
      }
    }
    return ret;
  } else {
    return type_error();
  }
};

module.exports = coss;

},{}]},{},[1]);