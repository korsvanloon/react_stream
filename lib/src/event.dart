part of react;

class SyntheticEvent {
  final bool bubbles, cancelable, defaultPrevented, isTrusted;
  final num eventPhase, timeStamp;
  final HtmlElement currentTarget, target;
  final Event nativeEvent;
  final String type;

  SyntheticEvent(this.bubbles, this.cancelable, this.currentTarget,
      this.defaultPrevented, this.eventPhase, this.isTrusted, this.nativeEvent,
      this.target, this.timeStamp, this.type);

  SyntheticEvent.fromEvent(SyntheticEvent event)
      : bubbles = event.bubbles,
        cancelable = event.cancelable,
        currentTarget = event.currentTarget,
        defaultPrevented = event.defaultPrevented,
        eventPhase = event.eventPhase,
        isTrusted = event.isTrusted,
        nativeEvent = event.nativeEvent,
        target = event.target,
        timeStamp = event.timeStamp,
        type = event.type;

  SyntheticEvent.fromJs(JsObject e)
      : bubbles = e['bubbles'],
        cancelable = e["cancelable"],
        currentTarget = e["currentTarget"],
        defaultPrevented = e["defaultPrevented"],
        eventPhase = e["eventPhase"],
        isTrusted = e["isTrusted"],
        nativeEvent = e["nativeEvent"],
        target = e["target"],
        timeStamp = e["timeStamp"],
        type = e["type"];
}

class SyntheticKeyboardEvent extends SyntheticEvent {
  final bool altKey;
  final String char;
  final bool ctrlKey;
  final String locale;
  final num location;
  final String key;
  final bool metaKey;
  final bool repeat;
  final bool shiftKey;
  final num keyCode;
  final num charCode;

  SyntheticKeyboardEvent.fromJs(JsObject e)
      : altKey = e['altKey'],
        char = e['char'],
        ctrlKey = e['ctrlKey'],
        locale = e['locale'],
        location = e['location'],
        key = e['key'],
        metaKey = e['metaKey'],
        repeat = e['repeat'],
        shiftKey = e['shiftKey'],
        keyCode = e['keyCode'],
        charCode = e['charCode'],
        super.fromJs(e);
}

class SyntheticFocusEvent extends SyntheticEvent {
  final HtmlElement relatedTarget;

  SyntheticFocusEvent.fromJs(JsObject e)
      : relatedTarget = e['relatedTarget'],
        super.fromJs(e);
}

class SyntheticFormEvent extends SyntheticEvent {
  SyntheticFormEvent.fromJs(JsObject e) : super.fromJs(e);
}

class SyntheticMouseEvent extends SyntheticEvent {
  final bool altKey;
  final num button;
  final num buttons;
  final num clientX;
  final num clientY;
  final bool ctrlKey;
  final bool metaKey;
  final num pageX;
  final num pageY;
  final HtmlElement relatedTarget;
  final num screenX;
  final num screenY;
  final bool shiftKey;

  SyntheticMouseEvent.fromJs(JsObject e)
      : altKey = e['altKey'],
        button = e['button'],
        buttons = e['buttons'],
        clientX = e['clientX'],
        clientY = e['clientY'],
        ctrlKey = e['ctrlKey'],
        metaKey = e['metaKey'],
        pageX = e['pageX'],
        pageY = e['pageY'],
        relatedTarget = e['relatedTarget'],
        screenX = e['screenX'],
        screenY = e['screenY'],
        shiftKey = e['shiftKey'],
        super.fromJs(e);
}

//Set _syntheticClipboardEvents = new Set.from(["onCopy", "onCut", "onPaste",]);
Set _keyboardEvents = new Set.from(["onKeyDown", "onKeyPress", "onKeyUp",]);
Set _focusEvents = new Set.from(["onFocus", "onBlur",]);
Set _formEvents = new Set.from(["onChange", "onInput", "onSubmit",]);
Set _mouseEvents = new Set.from(["onClick", "onDoubleClick",
    "onDrag", "onDragEnd", "onDragEnter", "onDragExit", "onDragLeave",
    "onDragOver", "onDragStart", "onDrop", "onMouseDown", "onMouseEnter",
    "onMouseLeave", "onMouseMove", "onMouseOut", "onMouseOver", "onMouseUp",]);
//Set _syntheticTouchEvents = new Set.from(["onTouchCancel", "onTouchEnd",
//    "onTouchMove", "onTouchStart",]);
//Set _syntheticUIEvents = new Set.from(["onScroll",]);
//Set _syntheticWheelEvents = new Set.from(["onWheel",]);



//-------------------
// LIFE CYCLE EVENTS
//-------------------

abstract class LifeCycleEvent {}

class DidMountEvent extends LifeCycleEvent {}
class WillMountEvent extends LifeCycleEvent {}
class WillUnmountEvent extends LifeCycleEvent {}
class WillUpdateEvent extends LifeCycleEvent {
  var nextProps, nextState;
  WillUpdateEvent(this.nextProps, this.nextState);
}
class DidUpdateEvent extends LifeCycleEvent {
  var prevProps, prevState;
  DidUpdateEvent(this.prevProps, this.prevState);
}
class WillReceivePropsEvent extends LifeCycleEvent {
  var newProps;
  WillReceivePropsEvent(this.newProps);
}
