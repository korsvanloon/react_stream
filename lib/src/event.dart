part of react;


class SyntheticEvent {
  final bool bubbles, cancelable, defaultPrevented, isTrusted;
  final num eventPhase, timeStamp;
  final HtmlElement currentTarget, target;
  final UIEvent nativeEvent;
  final String type;
  
  SyntheticEvent({this.bubbles, this.cancelable, this.currentTarget, this.defaultPrevented,
    this.eventPhase, this.isTrusted, this.nativeEvent, this.target, this.timeStamp, this.type});
  
  factory SyntheticEvent.fromJs(JsObject e) => new SyntheticEvent(
        bubbles: e['bubbles'],
        cancelable: e["cancelable"],
        currentTarget: e["currentTarget"],
        defaultPrevented: e["defaultPrevented"], 
        eventPhase: e["eventPhase"], 
        isTrusted: e["isTrusted"], 
        nativeEvent: e["nativeEvent"],
        target: e["target"], 
        timeStamp: e["timeStamp"], 
        type: e["type"]    
    );
}


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