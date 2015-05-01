import 'package:react_stream/react.dart';
import 'dart:html';
import 'dart:async';
import 'package:stream_transformers/stream_transformers.dart';

class Message extends GlobalEvent {
  final String owner;
  final List<String> receivers;
  final String text;
  
  Message(this.owner, this.receivers, this.text);
  
  toString() => 'from $owner, to $receivers: $text';
}

class ChatAppComponent extends ReactComponent {
  ChatAppComponent(this.user, this.friends) : super({});
  String user;
  List<String> friends;

  @override
  ReactElement render() {
    var asdfas = new ChatboxComponent(user, friends);
    return div(className: 'app', children: [
        nav(className:'navbar navbar-default', children: [
          div(className:'navbar-header', children: 
            a(className: 'navbar-brand', children: 'FakeBook')  
          ),
          p(className:'navbar-text', children: user),
          div(className:'navbar-text ', children:
            new Notification(user, friends)            
          )
        ]),
        asdfas
    ]);
  }
}

class ChatboxComponent extends ReactComponent {
  ChatboxComponent(this.owner, this.receivers) : super({}) {
    
    var enter$ = _input.keyboard$
          .where((e) => e.keyCode == KeyCode.ENTER && e.target.value != '');
    

    lifeCycle$.where((e) => e is WillMountEvent).listen((onData) {
      globalEvent$.listen((m) {
        messages.add(m);
        repaint();
        scrollToBottom();
      }); 
    });
    
    publishStream(_input.focus$.map((e) 
        => new GlobalEvent(details:{'owner': owner, 'readMessages': true})));

    enter$.listen((e) {
      text = e.target.value;
      publishEvent(new Message(owner, receivers, e.target.value));
      e.target.value = '';
    });
  }
  
  String owner;
  List<String> receivers;
  List<Message> messages = new List();
  
  DomElement _body;
  
  DomElement _input = input(className:'form-control', listenTo:['onKeyUp', 'onFocus']);
  
  scrollToBottom() {
//    _body.renderedNode.scrollTop = _body.renderedNode.scrollHeight;
  }
  
  @override
  ReactElement render() {
    _body = div(className: 'panel-body', children: messages.map((m) {
      return m.owner == owner ? 
          div(className: 'message me', children: [
            span(className:'text', children: m.text),
            '[me]',
          ])
        : div(className: 'message friend', children: [
          '[${m.owner}]',
          span(className:'text', children: m.text),
        ]); 
    }));
    
    return 
    div(className: 'panel panel-primary', children: [
      div(className: 'panel-heading', children: receivers.join(', ')),
      _body,
      _input
    ]);
  }
}

class Notification extends ReactComponent {  
  Notification(this.owner, this.friends) : super({}) {
    globalEvent$.where((e) => e is Message).where((e) => friends.contains(e.owner))
    .listen((e) => _update(_counter + 1));
    
    globalEvent$.where((e) => e.details.containsKey('readMessages') 
                           && e.details['owner'] == owner)
      .listen((e) => _update(0));
  }
  String owner;
  List<String> friends;
  
  num _counter = 0; 
  
  _update(c) {
    _counter = c;
    repaint();
  }

  @override
  ReactElement render() {
    return button(className:'btn btn-default', children:
      span(className:'glyphicon glyphicon-comment', children:' $_counter')
    );
  }
}

main() {
  globalEvent$.listen((e) => print(e));
  
  var app1 = new ChatAppComponent('Kors', ['Ani', 'Georgi']);  
  render(app1, document.querySelector('#app1'));
  
  var app2 = new ChatAppComponent('Ani', ['Kors', 'Georgi']);  
  render(app2, document.querySelector('#app2'));
  
  var app3 = new ChatAppComponent('Georgi', ['Ani', 'Kors']);  
  render(app3, document.querySelector('#app3'));
  
}