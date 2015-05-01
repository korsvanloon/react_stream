import 'package:react_stream/react.dart';
import 'dart:html';
import 'dart:async';

class MessageEvent extends SyntheticEvent {
  MessageEvent(this.text, this.owner, SyntheticEvent event) : super.fromEvent(event);

  String text;
  String owner;
}

class InputComponent extends ReactComponent {
  InputComponent(this.owner) : super({}) {
    var s = _input.keyboard$
          .where((e) => e.keyCode == KeyCode.ENTER && e.target.value != '')
          .map((e) => new MessageEvent(e.target.value, owner, e));
    
    globalEventCtrl.addStream(s);

    s.listen((e) {
      e.target.value = '';
      messages.add(e);
      repaint();
    });
    
  }
  String owner;
  List<MessageEvent> messages = new List();
  
  DomElement _input = input({'className': 'form-control'}, [], ['onKeyUp']);
  
  @override
  ReactElement render() {
    var i = 0;
    return 
    div({'key':'sfsdf'}, [
      div({'key':'asdf'}, messages.map((m) => div({'key': '${i++}'}, m.text))),
      _input
    ]);
  }
}

class Notification extends ReactComponent {  
  Notification() : super({}) {
    globalEvent$.where((e) => e is MessageEvent).listen(_update);
  }
  
  num _counter = 0; 
  
  _update(_) {
    _counter++;
    repaint();
  }

  @override
  ReactElement render() {
    return div({}, '$_counter');
  }
}

main() {
  
  var inputComp = new InputComponent('Kors');
  globalEvent$.where((e) => e is MessageEvent).listen((e) => print(e.text));
  
//  inputComp.message$.listen((e) => print(e.message));
  
//  inputComp.message$.listen((e) => print(e.message.length));
  
  render(inputComp, document.querySelector('#app'));
  
  render(new Notification(), document.querySelector('#notification'));
}