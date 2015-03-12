// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library react_stream.test;

import 'package:unittest/unittest.dart';
import 'package:react_stream/react_stream.dart';
import 'package:react/react.dart' as react;
import "package:react/react_client.dart";
import "dart:html";

class MyElement extends StreamComponent {
  
  
  
  @override
  render() {
    // TODO: implement render
  }
}

//main() {
//  group('A group of tests', () {
//    MyElement myElement;
//    
//    myElement.stateStream.add();
//
//    setUp(() {
//      awesome = new MyElement();
//    });
//
//    test('First Test', () {
//      expect(awesome.isAwesome, isTrue);
//    });
//  });
//}


var simpleComponent = react.registerComponent(() => new SimpleComponent());
class SimpleComponent extends react.Component {
  componentWillMount() => print("mount");
  
  componentWillUnmount() => print("unmount");
  
  render() =>
    react.div({}, [
      "Simple component",
    ]);
}


void main() {
  print("What");
  setClientConfiguration();
  var mountedNode = querySelector('#content');
  
  querySelector('#mount').onClick.listen(
    (_) => react.render(simpleComponent({}), mountedNode));
    
                    
  querySelector('#unmount').onClick.listen(
      (_) => react.unmountComponentAtNode(mountedNode));
}