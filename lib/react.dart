library react;

import 'dart:js';
import 'dart:html';
import 'dart:async';

part 'src/event.dart';

JsObject _react = context['React'];
StreamController<SyntheticEvent> globalEventCtrl =
    new StreamController.broadcast();
Stream<SyntheticEvent> get globalEvent$ => globalEventCtrl.stream;

void render(ReactElement element, HtmlElement container) {
  _react.callMethod('render', [element.toJs(), container]);
}

bool unmountComponentAt(HtmlElement container) {
  return _react.callMethod('unmountComponentAtNode', [container]);
}

//HtmlElement findDomNode(ReactComponent component) {
//  return _react.callMethod('findDOMNode', [component.toJs()]);
//}

/// Basic wrapper for Reacts virtual DOM nodes and component.
abstract class ReactElement {
  JsObject _js;
  Map props;
  List<ReactElement> children = [];
  String text = '';

  // TODO: convert to js from local properties
  JsObject toJs() {
    return _js;
  }
}

///
abstract class ReactComponent extends ReactElement {
  StreamController<LifeCycleEvent> _lifeCycleCtrl;
  Stream<LifeCycleEvent> get lifeCycle$ => _lifeCycleCtrl.stream;
  Function _repaint;
  
  ReactComponent(Map props) {
    _lifeCycleCtrl = new StreamController();

    var methods = {
      'render': () => render().toJs(),
      'getInitialState': new JsFunction.withThis((jsThis) {
        _repaint = () => jsThis.callMethod('setState', [new JsObject.jsify({})]);
      }),
      'componentWillMount': () => _lifeCycleCtrl.add(new WillMountEvent()),
      'componentDidMount': () => _lifeCycleCtrl.add(new DidMountEvent()),
      'componentWillReceiveProps':
          (newProps) => _lifeCycleCtrl.add(new WillReceivePropsEvent(newProps)),
      'componentWillUpdate': (jsThis, nextProps, nextState) =>
          _lifeCycleCtrl.add(new WillUpdateEvent(nextProps, nextState)),
      'componentDidUpdate': (jsThis, prevProps, prevState) =>
          _lifeCycleCtrl.add(new DidUpdateEvent(prevProps, prevState)),
      'componentWillUnmount': () => _lifeCycleCtrl.add(new WillUnmountEvent()),
    };
    
    JsObject jsClass =
        _react.callMethod('createClass', [new JsObject.jsify(methods)]);
    
    _js = _react.callMethod(
        'createElement', [jsClass, new JsObject.jsify(props), _toJs(children)]);
  }
  
//  void repaint() => _jsClass.callMethod('setState', [new JsObject.jsify({})]);
  void repaint() => _repaint();

  ReactElement render();
}

class DomElement extends ReactElement {
  StreamController<SyntheticEvent> _uiEventCtrl;
  
  Stream<SyntheticEvent> get _uiEvent$ =>
      _uiEventCtrl.stream;
  
  Stream<SyntheticKeyboardEvent> get keyboard$ => _uiEvent$.where((e) => e is SyntheticKeyboardEvent);
  Stream<SyntheticFocusEvent> get focus$ => _uiEvent$.where((e) => e is SyntheticFocusEvent);
  Stream<SyntheticFormEvent> get form$ => _uiEvent$.where((e) => e is SyntheticFormEvent);
  Stream<SyntheticMouseEvent> get mouse$ => _uiEvent$.where((e) => e is SyntheticMouseEvent);
      
  DomElement(String tagName, props, children, List<String> listenTo) {
    _uiEventCtrl = new StreamController.broadcast();
    this.props = props;

    if (listenTo != null) {
      listenTo.forEach((s) => props[s] = _addHandler(s, _uiEventCtrl));
    }

    _js = _react.callMethod(
        'createElement', [tagName, new JsObject.jsify(props), _toJs(children)]);
  }

  publish({String type, EventMap map}) {
    var s = _uiEvent$;
    if (type != null) {
      s = s.where((e) => e.type == type);
    }
    if (map != null) {
      s = s.map(map);
    }
    s.listen(globalEventCtrl.add);
  }

  _addHandler(String name, StreamController ctrl) {
    if (_keyboardEvents.contains(name)) {
      return (e, [id]) => ctrl.add(new SyntheticKeyboardEvent.fromJs(e));
    } else if (_focusEvents.contains(name)) {
      return (e, [id]) => ctrl.add(new SyntheticFocusEvent.fromJs(e));
    } else if (_formEvents.contains(name)) {
      return (e, [id]) => ctrl.add(new SyntheticFormEvent.fromJs(e));
    } else if (_mouseEvents.contains(name)) {
      return (e, [id]) => ctrl.add(new SyntheticMouseEvent.fromJs(e));
    }
  }
}

typedef SyntheticEvent EventMap(SyntheticEvent e);

DomElement button(Map props, children, [listenTo]) =>
    new DomElement('button', props, children, listenTo);
DomElement div(Map props, children, [listenTo]) =>
    new DomElement('div', props, children, listenTo);
DomElement input(Map props, children, [listenTo]) =>
    new DomElement('input', props, children, listenTo);

_toJs(tree) {
  if (tree is ReactElement) {
    return tree.toJs();
  }
  if (tree is List) {
    return new JsObject.jsify(tree.map(_toJs));
  }
  return tree;
}
