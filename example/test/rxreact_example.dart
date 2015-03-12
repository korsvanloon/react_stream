import 'package:react_stream/react_stream.dart';
import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import 'dart:async';
import 'dart:html';

class MyComponent extends StreamComponent {
  
  MyComponent() {
    onMounted.listen((_) => print('didmount'));
    onUnmounted.listen((_) => print('unmounted'));
    propsStream.listen(print);
  }
  
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
MyComponent c = new MyComponent();
var simpleComponent = react.registerComponent(() => c);

void main() {
  setClientConfiguration();
  var mountedNode = querySelector('#content');
  
  var propsButton = (querySelector('#setprops') as ButtonElement);
  propsButton.disabled = true;
    
  querySelector('#mount').onClick.listen(
    (_) { 
//      var c = (simpleComponent({}) as MyComponent);
      react.render(simpleComponent({'id': 'red'}), mountedNode);
//      c.props
//      c.callMethod('setProps', [{}]);
      propsButton.disabled = false;
      propsButton.onClick.listen((_) {
        c.props['class'] = 'red';
      });
    });
    
  querySelector('#unmount').onClick.listen(
    (_) => react.unmountComponentAtNode(mountedNode));
  
//  simpleComponent.props['class'] = 'red';

//  react.render(simpleComponent({}), mountedNode);
}