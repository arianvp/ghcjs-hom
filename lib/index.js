var VNode = require('vtree/vnode'),
    VText = require('vtree/vtext'),
    diff  = require('vtree/diff'),
    patch = require('vdom/patch'),
    raf   = require('raf');

global.node = function (tagName, props, children) {
  return new VNode(tagName, props, children);
};

global.text = function (text) {
  return new VText(text);
};

global.diff = diff;
global.patch = patch;
global.raf = raf;

global.createElement = require('vdom/create-element');