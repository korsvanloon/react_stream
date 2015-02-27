import 'package:react_stream/react_stream.dart';
import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import 'dart:async';
import 'dart:html';

/*
var RxReact = require('rx-react');
var Rx = require('rx');

class MyComponent extends RxReact.Component {
  getStateStream() {
    return Rx.Observable.interval(1000).map(function (interval) {
      return {
        secondsElapsed: interval
      };
    });
  }

  render() {
    var secondsElapsed = this.state? this.state.secondsElapsed : 0;
    return (
      <div>Seconds Elapsed: {secondsElapsed}</div>
    );
  }
}
*/

class MyComponent extends StreamComponent {
  
  get stateStream => new Stream.periodic(new Duration(seconds: 1), (interval) => {
    'secondsElapsed' : interval
  });
  
  @override
  render() {
    var secondsElapsed = this.state.isNotEmpty ? this.state['secondsElapsed'] : 0;
    return react.div({}, [
      "Seconds Elapsed ${secondsElapsed}",
    ]);
  }
}
var simpleComponent = react.registerComponent(() => new MyComponent());

void main() {
  setClientConfiguration();
  var mountedNode = querySelector('#content');
  
  react.render(simpleComponent({}), mountedNode);
  
}