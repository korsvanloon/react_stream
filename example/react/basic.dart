import 'package:react_stream/react.dart';
import 'dart:html';

class MessageEvent extends SyntheticEvent {
  String message;
  MessageEvent(this.message, SyntheticEvent event) : super.fromEvent(event);
}

class Component extends ReactComponent {
  Component(Map props) : super(props);
  
  String message = 'bladiebla';
  var inputComponent = new InputComponent({});

  @override
  ReactElement render() {
    return 
    div({'className': 'black'}, [
      div({'className': 'green'}, 
        button({}, 'test2', ['onClick'])..publish(type: 'click', map:(e) => new MessageEvent(message, e)) ),
//        button({}, 'test2', ['onClick'])..click$.map((e) => new MessageEvent(message, e)).pipe(globalEventCtrl) ),
      button({}, 'test3'),
      inputComponent
    ]);
  }
}

class InputComponent extends ReactComponent {
  InputComponent(Map props) : super(props);
  
  @override
  ReactElement render() {
    return
    input({},[], ['onKeyUp'])..publish()
    ;
  }
}

main() {
//  globalEvent$.listen((e) => print('global ${e.target}'));
  globalEvent$.where((e) => e is MessageEvent).listen((e) => print('global ${e.text}'));
  globalEvent$.listen((e) => print('global ${e.type}'));
  
  var container = document.querySelector('#container');
  
  var element = button({}, ['test']);
  element._uiEvent$.listen((e) => print(e.nativeEvent));
  
  render(element, container);
  
  var mycomp = new Component({});
  mycomp.lifeCycle$.listen(print);

  var container2 = document.querySelector('#container2');
  render(mycomp, container2);

  // to check if the lifeCycle$ continues...
  unmountComponentAt(container2); 
  render(mycomp, container2);
}