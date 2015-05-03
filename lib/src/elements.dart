part of react;

/// Basic wrapper for Reacts virtual DOM nodes and component.
abstract class ReactElement {
  JsObject _js;
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
    _lifeCycleCtrl = new StreamController.broadcast();

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
      
  DomElement(String tagName, Map props, children, List<String> listenTo) {
    _uiEventCtrl = new StreamController.broadcast();

    if (listenTo != null) {
      listenTo.forEach((s) => props[s] = _addHandler(s, _uiEventCtrl));
    }

    _js = _react.callMethod(
        'createElement', [tagName, new JsObject.jsify(props), _toJs(children)]);
  }
  
//  HtmlElement get renderedNode => _js['_owner']['_instance'].callMethod('getDOMNode', []);

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

//typedef SyntheticEvent EventMap(SyntheticEvent e);

DomElement button({String className, Function click, children, List<String> listenTo}) =>
    new DomElement('button', {'className': className, 'onClick': click}, children, listenTo);

DomElement a({String className, String href:'#', children, List<String> listenTo}) =>
    new DomElement('a', {'className': className, 'href': href}, children, listenTo);

DomElement div({String className, children, List<String> listenTo}) =>
    new DomElement('div', {'className': className}, children, listenTo);

DomElement nav({String className, children, List<String> listenTo}) =>
    new DomElement('nav', {'className': className}, children, listenTo);

DomElement p({String className, children, List<String> listenTo}) =>
    new DomElement('p', {'className': className}, children, listenTo);

DomElement span({String className, children, List<String> listenTo}) =>
    new DomElement('span', {'className': className}, children, listenTo);

DomElement input({String className, children, List<String> listenTo}) =>
    new DomElement('input', {'className': className}, children, listenTo);

DomElement img({String className, String src, int width: 50, int height: 50, children, List<String> listenTo}) {
  if(src == null) {
    src = 'http://placehold.it/${width}x${height}';
  }
  
  return new DomElement('img', {'className': className, 'src': src, 'width': width, 'height': height}, 
      children, listenTo);
}
