import 'package:react_stream/react.dart';
import 'dart:html' as html;
import 'dart:async';
import 'package:stream_transformers/stream_transformers.dart';

class Message extends GlobalEvent {
  final User owner;
  final List<User> receivers;
  final String text;

  Message(this.owner, this.receivers, this.text);
  
  toString() => 'from $owner, to $receivers: $text';
}

class CloseEvent extends GlobalEvent {
  CloseEvent(this.toBeClosed);
  
  ReactComponent toBeClosed;
}

class User {
  String name;
  String imageUrl;
  List<User> friends = [];
  User(this.name, this.imageUrl);
  toString() => name;
}

class ChatAppComponent extends ReactComponent {
  ChatAppComponent(this.user) : super({}) {
    chatbox = new ChatboxComponent(user, user.friends);
    
//    lifeCycle$.where((e) => e is WillUnmountEvent);
    
    globalEvent$.where((e) => e is CloseEvent && e.toBeClosed == chatbox).listen((e) {
      _shouldDisplayChatbox = false;
      repaint(); 
    });
    
    _button.mouse$.listen((e) {
      _shouldDisplayChatbox = true;
      repaint();
    });
  }
  User user;
  bool _shouldDisplayChatbox  = true;
  List<ChatboxComponent> chatboxes = [];
  ChatboxComponent chatbox;
  DomElement _button = button(className:'btn btn-default', children:'open chatbox', listenTo:['onClick']);
  
  @override
  ReactElement render() {
    return div(className: 'app', children: [
      nav(className:'navbar navbar-default', children: [
        div(className:'navbar-header', children: 
          a(className: 'navbar-brand', children: 'FakeBook')  
        ),
        div(className:'navbar-left navbar-text', children: [
          img(width:20, height:20, src:user.imageUrl),
          '$user',
          new Notification(user)            
        ]
        )
      ]),
      new FriendListComponent(user),
      _shouldDisplayChatbox ? chatbox : _button
    ]);
  }
}

class FriendListComponent extends ReactComponent {
  FriendListComponent(this.user) : super({});
  User user;
  
  
  @override
  ReactElement render() {
    return div(className:'friends', children:[
      p(children:'Friends:'),
      div(children: user.friends.map((f) =>
        button(className:'btn btn-default', children:[
          img(width:25, height:25, src:f.imageUrl),
          f.name
        ])
      ))
    ]); 
  }
}

class ChatboxComponent extends ReactComponent {
  ChatboxComponent(this.owner, this.receivers) : super({}) {
    
    var enter$ = _input.keyboard$
          .where((e) => e.keyCode == html.KeyCode.ENTER && e.target.value != '');

   
    lifeCycle$.where((e) => e is WillMountEvent).listen((onData) {
      publishStream(_input.keyboard$.where((e) => e.keyCode != html.KeyCode.ENTER).map((e) 
                  => new GlobalEvent(details:{'owner': owner, 'isTyping': true})));    
      
      publishStream(_input.focus$.map((e) 
                   => new GlobalEvent(details:{'owner': owner, 'readMessages': true})));
        
         
      publishStream(_input.keyboard$.transform(new Debounce(new Duration(milliseconds:1000)))
      .transform(new Merge(_input.keyboard$.where((e) => e.keyCode == html.KeyCode.ENTER)))
      .map((e) => new GlobalEvent(details:{'owner': owner, 'isTyping': false})));
      
      publishStream(_closeBtn.mouse$.map((e) => new CloseEvent(this)));
      
    });
    
    globalEvent$.where((e) => e is Message).listen((m) {
      messages.add(m);
      scrollToBottom();
      repaint();
    });
   
    enter$.listen((e) {
      text = e.target.value;
      publishEvent(new Message(owner, receivers, e.target.value));
      e.target.value = '';
    });
    
    globalEvent$.where((e) => e.details.containsKey('isTyping')
                            && receivers.contains(e.details['owner']))
    .listen((e) {
      _updateString(e.details['owner'], e.details['isTyping']);
    });
 }
  
  User owner;
  List<User> receivers;
  List<Message> messages = new List();
  
  DomElement _body;
  
  DomElement _input = input(className:'form-control', listenTo:['onKeyUp', 'onFocus']);
  String _typingString = "";
  
  scrollToBottom() {
    _body.renderedNode.scrollTop = _body.renderedNode.scrollHeight;
  }
   
  _updateString(owner, isTyping) {
    _typingString = isTyping ? " " + owner.name + " is typing..." : '';
    repaint();
  }
  
  DomElement _closeBtn = button(className:'close', children:'×', listenTo:['onClick']);
  
  @override
  ReactElement render() {
    _body = div(className: 'panel-body', children: messages.map((m) {
      return m.owner == owner ? 
          div(className: 'message me', children: [
            span(className:'text', children: m.text),
          ])
        : div(className: 'message friend', children: [
          img(width:25, height:25, src:m.owner.imageUrl),
          span(className:'text', children: m.text),
        ]); 
    }));
    
    return 
    div(className: 'panel panel-primary', children: [
      div(className: 'panel-heading', children: [
        receivers.join(', '),
        _closeBtn
      ]),
      span(className:'glyphicon glyphicon-pencil', children: '$_typingString'),
      _body,
      _input
    ]);
  }
}

class Notification extends ReactComponent {  
  Notification(this.owner) : super({}) {
    
    lifeCycle$.where((e) => e is WillMountEvent).listen((_) {
      
      globalEvent$.where((e) => e is Message).where((e) => e.receivers.contains(owner))
                  .listen((e) => _update(_counter + 1));
    
      globalEvent$.where((e) => e.details.containsKey('readMessages') 
                             && e.details['owner'] == owner)
                  .listen((e) => _update(0));
  
    });
  }
  User owner;

  num _counter = 0; 
  
  _update(c) {
    _counter = c;
    repaint();
  }

  @override
  ReactElement render() {
    return span(className:'notification', children: [
      span(className:'glyphicon glyphicon-comment'),
      _counter > 0 ? span(className:'counter', children:'$_counter') : null
    ]);
  }
}

main() {
  var kors = new User('Kors', 'image/kors.jpeg');
  var ani = new User('Ani', 'image/ani.jpg');
  var georgi = new User('Georgi', 'image/georgi.jpeg');
  
  html.DivElement div = new html.DivElement();
  div.scrollTop = div.scrollHeight;
  
  kors.friends = [ani, georgi];
  ani.friends = [kors, georgi];
  georgi.friends = [kors, ani];
  
  var app1 = new ChatAppComponent(kors);  
  render(app1, html.document.querySelector('#app1'));
  
  var app2 = new ChatAppComponent(ani);  
  render(app2, html.document.querySelector('#app2'));
  
  var app3 = new ChatAppComponent(georgi);  
  render(app3, html.document.querySelector('#app3'));
  
}