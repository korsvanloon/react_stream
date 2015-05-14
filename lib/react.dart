library react;

import 'dart:js';
import 'dart:html';
import 'dart:async';
import 'package:stream_transformers/stream_transformers.dart';
//import 'package:stream_ext/stream_ext.dart';

part 'src/events.dart';
part 'src/elements.dart';


void render(ReactElement element, HtmlElement container) {
  _react.callMethod('render', [element.toJs(), container]);
}

bool unmountComponentAt(HtmlElement container) {
  return _react.callMethod('unmountComponentAtNode', [container]);
}

HtmlElement _findDomNode(JsObject element) {
  return _react.callMethod('findDOMNode', [element]);
}

JsObject get _refs => _react['refs'];

JsObject _react = context['React'];

_toJs(tree) {
  if (tree is ReactElement) {
    return tree.toJs();
  }
  if (tree is Iterable) {
    
    return new JsObject.jsify(tree.map(_toJs));
  }
  return tree;
}
