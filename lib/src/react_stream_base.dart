// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library react_stream.base;
import 'dart:async';
import 'package:react/react.dart';

abstract class StreamComponent extends Component {
  //Lifecycle Streams  
  StreamController _onMountedController = new StreamController();
  StreamController _onMountingController = new StreamController();
  StreamController _onUnmountedController = new StreamController();
  StreamController _onUpdateController = new StreamController();
  StreamController _onUpdatedController = new StreamController();
  StreamController _onReceivePropsController = new StreamController();
  
  Stream get onMounted => _onMountedController.stream;
  Stream get onMounting => _onMountingController.stream;
  Stream get onUnmounted => _onUnmountedController.stream;
  Stream get onUpdate => _onUpdateController.stream;
  Stream get onUpdated => _onUpdatedController.stream;
  Stream get propsStream => _onReceivePropsController.stream;
  
  @override
  componentDidMount(rootNode) {
    _onMountedController.add(rootNode);
  }
  
  @override
  componentWillMount() {
    _onMountingController.add('');
  }
  
  
  @override
  componentWillUnmount() {
    _onUnmountedController.add('');
  }
  
  @override
  componentWillUpdate(nextProps, nextState) {
    _onUpdateController.add({'nextProps': nextProps, 'nextState': nextState});
  }
  
  @override
  componentDidUpdate(prevProps, prevState, /*DOMElement */ rootNode) {
    _onUpdatedController.add({'prevProps': prevProps, 'prevState': prevState, 'rootNode': rootNode});
  }
  
  @override
  componentWillReceiveProps(rootNode) {
    _onReceivePropsController.add(rootNode);
  }
  
  Stream get stateStream => null;
  
  @override
  Map getInitialState() {
    var initialState = {};

    if(stateStream != null) {
      stateStream.listen((state) {
        initialState = state;
        setState(state);
      });
    }
    
    
    return initialState;
  }

  // State stream
//  StreamController<Map> stateStreamController = new StreamController<Map>();
//  Stream<Map> get stateStream => stateStreamController.stream;

//  @override
//  setState(s) {
//   stateStreamController.add(s);
//   super.setState(s);
//  }

}

Stream<Map> stateStreamer(Duration interval, [int maxCount]) {
  StreamController<Map> controller;
  Timer timer;
  int counter = 0;
  
  void tick(_) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (maxCount != null && counter >= maxCount) {
      timer.cancel();
      controller.close();    // Ask stream to shut down and tell listeners.
    }
  }
  
  void startTimer() {
    timer = new Timer.periodic(interval, tick);
  }

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  controller = new StreamController<Map>(
      onListen: startTimer,
      onPause: stopTimer,
      onResume: startTimer,
      onCancel: stopTimer);

  return controller.stream;
}