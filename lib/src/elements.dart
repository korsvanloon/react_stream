part of react;

/// Basic wrapper for Reacts virtual DOM nodes and Components.
abstract class ReactElement {
  JsObject _js;
  List _children;
  String _text = '';

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
  
  ReactComponent([Map props = const{}]) {
    _lifeCycleCtrl = new StreamController.broadcast();

    var methods = {
      'render': () => render().toJs(),
      'getInitialState': new JsFunction.withThis((jsThis) {
        _repaint = () => jsThis.callMethod('setState', [new JsObject.jsify({})]);
      }),
      'componentWillMount': () {
        _lifeCycleCtrl.add(new WillMountEvent()); 
        ready();
      },
      'componentDidMount': () {
        _lifeCycleCtrl.add(new DidMountEvent());
        domReady();
      },
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
        'createElement', [jsClass, new JsObject.jsify({}), _toJs(_children)]);

  }
  
  void repaint() => _repaint();

  void ready() {}
  void domReady() {}

  ReactElement render();
}

class DomElement extends ReactElement {
  final String tagName;
  Map _props;
  StreamController<SyntheticEvent> _uiEventCtrl;
  
  Stream<SyntheticEvent> get _uiEvent$ =>
      _uiEventCtrl.stream;
  
  Stream<SyntheticKeyboardEvent> get keyboard$ => _uiEvent$.where((e) => e is SyntheticKeyboardEvent);
  Stream<SyntheticFocusEvent> get focus$ => _uiEvent$.where((e) => e is SyntheticFocusEvent);
  Stream<SyntheticFormEvent> get form$ => _uiEvent$.where((e) => e is SyntheticFormEvent);
  Stream<SyntheticMouseEvent> get mouse$ => _uiEvent$.where((e) => e is SyntheticMouseEvent);
      
  DomElement(this.tagName, this._props, content, List<String> listenTo) {
    _uiEventCtrl = new StreamController.broadcast();

    if (listenTo != null) {
      listenTo.toSet().forEach((s) => _props[s] = _addHandler(s, _uiEventCtrl));
    }
    this.content = content;
  }
  
//  HtmlElement get renderedNode => _js['_owner']['_instance'].callMethod('getDOMNode', []);

  get content => _children == null ? _text : _children;
  set content(c) {
    if(c is String) {
      _children = null;
      text = c;
    }
    else if(c is List) {
      _text = '';
      children = c;
    }
    else if(c is ReactElement) {
      _text = '';
      children = [c];
    }
    else {
      _text = '';
      _children = null;
      _js = _react.callMethod('createElement', [tagName, new JsObject.jsify(_props), _toJs(c)]);
    }
  }

  List get children => _children;
  set children(List c) {
    if(_text != '') throw '$this can only have either text or children';
    _children = c;
    _js = _react.callMethod('createElement', [tagName, new JsObject.jsify(_props), _toJs(c)]);
  }

  String get text => _text;
  set text(String c) {
    if(_children != null) throw '$this can only have either text or children';
    _text = c;
    _js = _react.callMethod('createElement', [tagName, new JsObject.jsify(_props), _toJs(c)]);
  }

  _addHandler(String name, StreamController ctrl) {
    var _name = name.split('Capture')[0];
    if (_keyboardEvents.contains(_name)) {
      return (e, [id]) => ctrl.add(new SyntheticKeyboardEvent.fromJs(e));
    } else if (_focusEvents.contains(_name)) {
      return (e, [id]) => ctrl.add(new SyntheticFocusEvent.fromJs(e));
    } else if (_formEvents.contains(_name)) {
      return (e, [id]) => ctrl.add(new SyntheticFormEvent.fromJs(e));
    } else if (_mouseEvents.contains(_name)) {
      return (e, [id]) => ctrl.add(new SyntheticMouseEvent.fromJs(e));
    } else {
      throw 'Unknown handler: $name';
    }
  }
}

class DomForm extends DomElement {
  DomForm(String tagName, Map props, content, List<String> listenTo)
    : super(tagName, props, content, listenTo..add('onChange')) {

    // Super hack, I can't access the native HtmlElement otherwise...
    // I tried everything...
    form$.first.then((e) {
      native = e.target;
    });
  }

  HtmlElement native;

  String get value => native != null ? native.value : '';
  set value(v) { if(native != null) native.value = v; }
}

DomElement button({String className, Function click, content, List<String> listenTo}) =>
    new DomElement('button', {'className': className, 'onClick': click}, content, listenTo);

DomElement a({String className, String href:'#', content, List<String> listenTo}) =>
    new DomElement('a', {'className': className, 'href': href}, content, listenTo);

DomElement div({String className, content, List<String> listenTo}) =>
    new DomElement('div', {'className': className}, content, listenTo);

DomElement ul({String className, content, List<String> listenTo}) =>
    new DomElement('ul', {'className': className}, content, listenTo);

DomElement li({String id, String className, content, List<String> listenTo}) =>
    new DomElement('li', {'id': id,'className': className}, content, listenTo);

DomElement h1({String className, content, List<String> listenTo}) =>
    new DomElement('h1', {'className': className}, content, listenTo);

DomElement h2({String className, content, List<String> listenTo}) =>
    new DomElement('h2', {'className': className}, content, listenTo);

DomElement h3({String className, content, List<String> listenTo}) =>
    new DomElement('h3', {'className': className}, content, listenTo);

DomElement h4({String className, content, List<String> listenTo}) =>
    new DomElement('h4', {'className': className}, content, listenTo);

DomElement nav({String className, content, List<String> listenTo}) =>
    new DomElement('nav', {'className': className}, content, listenTo);

DomElement p({String className, content, List<String> listenTo}) =>
    new DomElement('p', {'className': className}, content, listenTo);

DomElement span({String className, content, List<String> listenTo}) =>
    new DomElement('span', {'className': className}, content, listenTo);

DomElement pre({String className, content, List<String> listenTo}) =>
    new DomElement('pre', {'className': className}, content, listenTo);

DomForm input({String className, content, List<String> listenTo}) =>
    new DomForm('input', {'className': className}, content, listenTo);

DomForm textarea({String className, content, List<String> listenTo}) =>
    new DomForm('textarea', {'className': className}, content, listenTo);

DomForm checkbox({String className, name, bool checked, content, List<String> listenTo}) =>
    new DomForm('input', {'className': className, 'type': 'checkbox', 'name': name, 'checked': checked},
        content, listenTo);

DomForm range({String className, name, bool checked, content, List<String> listenTo}) =>
    new DomForm('input', {'className': className, 'type': 'range', 'name': name}, content, listenTo);

DomElement label({String className, content, List<String> listenTo}) =>
    new DomElement('label', {'className': className}, content, listenTo);

DomElement img({String className, String src, int width: 50, int height: 50, content, List<String> listenTo}) {
  if(src == null) {
    src = 'http://placehold.it/${width}x${height}';
  }
  return new DomElement('img', {'className': className, 'src': src, 'width': width, 'height': height}, 
      content, listenTo);
}
