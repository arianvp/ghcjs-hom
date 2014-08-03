var VNode = require('vtree/vnode'),
    diff  = require('vtree/diff'),
    patch = require('vdom/patch'),
    raf   = require('raf');

global.node = function (tagName, props, children) {
  return new VNode(tagName, props, children);
};

global.diff = diff;
global.patch = patch;
global.raf = raf;