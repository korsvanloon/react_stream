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
    _onReceivePropsController.close();
    if(stateStream != null) {
      _stateSubscription.cancel();
    }
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
  StreamSubscription _stateSubscription; // TODO: should this be a list of subscriptions?
  
  @override
  Map getInitialState() {
    var initialState = {};

    if(stateStream != null) {
      _stateSubscription = stateStream.listen((state) {
        initialState = state;
        setState(state);
      });
    }
    return initialState;
  }

}