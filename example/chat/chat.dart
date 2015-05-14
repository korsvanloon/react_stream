import 'package:react_stream/react.dart';
import 'dart:html' as html;
import 'dart:async';
import 'package:stream_transformers/stream_transformers.dart';

class MessageEvent extends GlobalEvent {
  final User owner;
  final Set<User> receivers;
  final String text;

  MessageEvent(this.owner, this.receivers, this.text);
  
  toString() => 'from $owner, to $receivers: $text';
}

class OnlineEvent extends GlobalEvent {
  OnlineEvent(this.user, this.isOnline);
  User user;
  bool isOnline;
}

class TypingEvent extends GlobalEvent {
  TypingEvent(this.owner, this.isTyping);
  bool isTyping;
  User owner;
}

class CloseEvent extends GlobalEvent {
  CloseEvent(this.toBeClosed);
  
  ReactComponent toBeClosed;
}

class UpdateFriendsEvent extends GlobalEvent {
  UpdateFriendsEvent(this.user, this.friend, this.added);
  User user;
  User friend;
  bool added;
}

class User {
  String name;
  String imageUrl;
  Set<User> friends = new Set();
  User(this.name, this.imageUrl);
  toString() => name;
}

class ChatAppComponent extends ReactComponent {
  ChatAppComponent(this.user) {
    chatbox = new ChatboxComponent(user, user.friends);
    friendList = new FriendListComponent(user);
    
    lifeCycle$.where((e) => e is WillMountEvent).listen((_) {
      publishStream(chatbox.lifeCycle$
        .where((e) => e is WillUnmountEvent || e is WillMountEvent)
        .map((e) => new OnlineEvent(user, e is WillMountEvent))
      );
    });
    
    globalEvent$.where((e) => e is CloseEvent && e.toBeClosed == chatbox).listen((e) {
      _shouldDisplayChatbox = false;
      repaint(); 
    });
    
    _button.mouse$.listen((e) {
      _shouldDisplayChatbox = true;
      repaint();
    });
  }
  
  //TODO: is this a good idea?
  List<Stream> publish() => [
    chatbox.lifeCycle$
      .where((e) => e is WillUnmountEvent || e is WillMountEvent)
      .map((e) => new OnlineEvent(user, e is WillMountEvent))
          
  ];
  User user;
  bool _shouldDisplayChatbox  = true;
  ChatboxComponent chatbox;
  DomElement _button = button(className:'btn btn-default', content:'open chatbox', listenTo:['onClick']);
  FriendListComponent friendList;
  
  @override
  ReactElement render() {
    return div(className: 'app', content: [
      nav(className:'navbar navbar-default', content: [
        div(className:'navbar-header', content: 
          a(className: 'navbar-brand', content: 'FakeBook')  
        ),
        div(className:'navbar-left navbar-text', content: [
          img(width:20, height:20, src:user.imageUrl),
          '$user',
          new Notification(user)            
        ]
        )
      ]),
      friendList,
      _shouldDisplayChatbox ? chatbox : _button
    ]);
  }
}

class FriendListComponent extends ReactComponent {
  FriendListComponent(this.user) {
    _checked = new Map.fromIterable(user.friends, value: (u) => false);
    
    
    _checkboxesDiv = div(className:'checkbox', listenTo:['onChangeCapture'], 
        content: user.friends.map((f) =>
        label(className: '', content: [
          checkbox(name: f.name, checked: _checked[f]),
          img(width:25, height:25, src:f.imageUrl),
          f.name
        ])
    ));
    
//    globalEvent$.where((e) => e is UpdateFriendsEvent).listen((e) {
//      var _user = e.friend == user ? e.user : e.friend;
//      _checked[_user] = e.added;
//      repaint();
//    });
    
//    lifeCycle$.where((e) => e is WillMountEvent).listen((_) {
//      publishStream(_checkboxesDiv.form$.map((e) => new UpdateFriendsEvent(user,
//          user.friends.firstWhere((f) => f.name == e.target.name), e.target.checked)));      
//    });
  }
  User user;
  
  DomElement _checkboxesDiv;
  Map<User, bool> _checked;
  
  @override
  ReactElement render() {
    return div(className:'friends', content:[
      p(content:'Friends:'),
      _checkboxesDiv
    ]); 
  }
}

class ChatboxComponent extends ReactComponent {
  ChatboxComponent(this.owner, this.receivers) {
    
    var enter$ = _input.keyboard$
          .where((e) => e.keyCode == html.KeyCode.ENTER && e.target.value != '');

   
    lifeCycle$.where((e) => e is WillMountEvent).listen((_) {
      publishStream(_input.keyboard$.where((e) => e.keyCode != html.KeyCode.ENTER).map((e) 
                  => new TypingEvent(owner, true)));    
      
      publishStream(_input.focus$.map((e) 
                   => new GlobalEvent(details:{'owner': owner, 'readMessages': true})));
        
         
      publishStream(_input.keyboard$.transform(new Debounce(new Duration(milliseconds:1000)))
      .transform(new Merge(_input.keyboard$.where((e) => e.keyCode == html.KeyCode.ENTER)))
      .map((e) => new TypingEvent(owner, false)));
      
      publishStream(_closeBtn.mouse$.map((e) => new CloseEvent(this)));
      
    });
    
    globalEvent$.where((e) => e is MessageEvent 
                           && (receivers.contains(e.owner) || owner == e.owner))
   .listen((m) {
      messages.add(m);
      scrollToBottom();
      repaint();
    });
   
    enter$.listen((e) {
      publishEvent(new MessageEvent(owner, receivers, e.target.value));
      e.target.value = '';
    });
    
    globalEvent$.where((e) => e is TypingEvent && receivers.contains(e.owner))
    .listen((e) {
      _updateString(e.owner, e.isTyping);
    });
    
    globalEvent$.where((e) => e is UpdateFriendsEvent).listen((e) {
      var _user = e.user == owner ? e.friend : e.user; 
      if(e.added) {
        receivers.add(_user);
      } else {        
        receivers.remove(_user);
      }
      repaint();
    });
    
    globalEvent$.where((e) => e is OnlineEvent && receivers.contains(e.user)).listen((e) {
      isOnline[e.user] = e.isOnline;
      repaint();
    });
    isOnline = new Map.fromIterable(receivers, value:(u) => true);
 }
  
  User owner;
  Set<User> receivers;
  List<MessageEvent> messages = new List();
  Map<User, bool> isOnline;
  
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
  
  DomElement _closeBtn = button(className:'close', content:'×', listenTo:['onClick']);
  
  @override
  ReactElement render() {
    _body = div(className: 'panel-body', content: messages.map((m) {
      return m.owner == owner ? 
          div(className: 'message me', content: [
            span(className:'text', content: m.text),
          ])
        : div(className: 'message friend', content: [
          img(width:25, height:25, src:m.owner.imageUrl),
          span(className:'text', content: m.text),
        ]); 
    }));
    
    return 
    div(className: 'panel panel-primary', content: [
      div(className: 'panel-heading', content: [
        span(content: receivers.map((u) => [
          span(className: isOnline[u] ? 'online' : 'offline', content: ' ❋ '), 
          u.name
        ])),
        _closeBtn
      ]),
      span(className:'glyphicon glyphicon-pencil', content: '$_typingString'),
      _body,
      _input
    ]);
  }
}

class Notification extends ReactComponent {  
  Notification(this.owner) {
    
    lifeCycle$.where((e) => e is WillMountEvent).listen((_) {
      
      globalEvent$.where((e) => e is MessageEvent).where((e) => e.receivers.contains(owner))
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
    return span(className:'notification', content: [
      span(className:'glyphicon glyphicon-comment'),
      _counter > 0 ? span(className:'counter', content:'$_counter') : null
    ]);
  }
}

main() {
  var kors = new User('Kors', 'image/kors.jpeg');
  var ani = new User('Ani', 'image/ani.jpg');
  var georgi = new User('Georgi', 'image/georgi.jpeg');
  
  html.DivElement div = new html.DivElement();
  div.scrollTop = div.scrollHeight;
  
  kors.friends.addAll([ani, georgi]);
  ani.friends.addAll([kors, georgi]);
  georgi.friends.addAll([kors, ani]);
  
  var app1 = new ChatAppComponent(kors);  
  render(app1, html.document.querySelector('#app1'));
  
  var app2 = new ChatAppComponent(ani);  
  render(app2, html.document.querySelector('#app2'));
  
  var app3 = new ChatAppComponent(georgi);  
  render(app3, html.document.querySelector('#app3'));
  
  globalEvent$.where((e) => e is OnlineEvent).listen((e) => print('${e.user} ${e.isOnline}'));
  
}