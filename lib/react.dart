library react;

import 'dart:js';
import 'dart:html';
import 'dart:async';

part 'src/event.dart';

JsObject _react = context['React'];

void render(ReactElement element, HtmlElement container) {
  _react.callMethod('render', [element.toJs(), container]);
}

bool unmountComponentAt(HtmlElement container) {
  return _react.callMethod('unmountComponentAtNode', [container]);
}

//HtmlElement findDomNode(ReactComponent component) {
//  return _react.callMethod('findDOMNode', [component.toJs()]);
//}

abstract class ReactElement {
  JsObject _js;
  Map props;
  List children = [];
//  String text = '';
  StreamController<SyntheticEvent> _uiEventCtrl;
  Stream<SyntheticEvent> get uiEvent$ => _uiEventCtrl.stream;  
  
  ReactElement() {
    _uiEventCtrl = new StreamController();
  }
  
  // TODO: convert to js from local properties
  JsObject toJs() {
   return _js;  
  }
  
}

abstract class ReactComponent extends ReactElement {
  
  StreamController<LifeCycleEvent> _lifeCycleCtrl; 
  Stream<LifeCycleEvent> get lifeCycle$ => _lifeCycleCtrl.stream; 
  
  ReactComponent(Map props) : super() {
    
    _lifeCycleCtrl = new StreamController();
    props['onClick'] = (e, id) => _uiEventCtrl.add(new SyntheticEvent.fromJs(e));
    
    var methods = {
      'render': () => this.render().toJs(),
      'componentWillMount': () => _lifeCycleCtrl.add(new WillMountEvent()),
      'componentDidMount': () => _lifeCycleCtrl.add(new DidMountEvent()),
      'componentWillReceiveProps': (newProps) => _lifeCycleCtrl.add(new WillReceivePropsEvent(newProps)),
      'componentWillUpdate': (nextProps, nextState) => _lifeCycleCtrl.add(new WillUpdateEvent(nextProps, nextState)),
      'componentDidUpdate': (prevProps, prevState) => _lifeCycleCtrl.add(new DidUpdateEvent(prevProps, prevState)),
      'componentWillUnmount': () => _lifeCycleCtrl.add(new WillUnmountEvent())
    };
    JsObject jsClass = _react.callMethod('createClass', [new JsObject.jsify(methods)]);
    _js = _react.callMethod('createElement', [jsClass, new JsObject.jsify(props), new JsObject.jsify(children)]);
  }

  ReactElement render();
}

class DomElement extends ReactElement {
  
  DomElement(String tagName, Map props, children) {
    
    props['onClick'] = (e, id) => _uiEventCtrl.add(new SyntheticEvent.fromJs(e));
    _js = _react.callMethod('createElement', [tagName, new JsObject.jsify(props), _toJs(children)]);
  }
}

DomElement button(Map props, children) => new DomElement('button', props, children);
DomElement div(Map props, children) => new DomElement('div', props, children);

_toJs(tree) {
  if(tree is ReactElement) {
    return tree.toJs();
  }
  if(tree is List) {
    return new JsObject.jsify(tree.map(_toJs));
  }
  return tree;
}

