import 'dart:html';
import 'dart:convert';

import 'package:react_stream/react.dart';
import 'package:frappe/frappe.dart';

import 'components.dart';
import 'dart:async';


WebSocket initWebSocket([int retrySeconds = 2]) {
  var reconnectScheduled = false;

  var ws = new WebSocket('ws://0.0.0.0:8888/ws');

  void scheduleReconnect() {
    if (!reconnectScheduled) {
      new Timer(new Duration(seconds: retrySeconds), () => initWebSocket(retrySeconds * 2));
    }
    reconnectScheduled = true;
  }

  ws.onOpen.listen((e) {
    ws.send('Hello from Dart!');
  });

  ws.onClose.listen((e) {
    print('closed');
  });

  ws.onError.listen((e) {
    scheduleReconnect();
  });
  
  return ws;
}

void main() {

  WebSocket ws = initWebSocket();
//  ws.onOpen.listen((e) => ws.send('Hello from Dart!'));
  
  var json$ = new EventStream(ws.onMessage)
      .map((e) => JSON.decode(e.data))
      .asBroadcastStream()
    ;

  render(new ApplicationComponent(json$), document.querySelector('#app'));
  
}