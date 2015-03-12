import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";
import 'package:react_stream/react_stream.dart';

var simpleComponent = react.registerComponent(() => new SimpleComponent());
class SimpleComponent extends StreamComponent {
    
  SimpleComponent() {
    onMounted.listen((_) => print('didmount'));
    onUnmounted.listen((_) => print('unmounted'));
  }
  
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