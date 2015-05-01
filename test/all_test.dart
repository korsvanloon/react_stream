// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library react_stream.test;
import 'dart:async';
import 'package:stream_transformers/stream_transformers.dart';


StreamController<Stream<int>> _globalEventCtrl =
    new StreamController.broadcast();

Stream<int> get globalEvent$ => _globalEventCtrl.stream.transform(new MergeAll());


void publish(Stream<int> stream) {
  _globalEventCtrl.add(stream);
}

main() {
  globalEvent$.listen(print);
  
  publish(new Stream.periodic(new Duration(milliseconds:500), (i) => i));
  publish(new Stream.periodic(new Duration(seconds:1), (i) => i*i));
//  publish(new Stream.fromIterable([5,6,7,8]));
}