import 'package:react_stream/react_stream.dart';
import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import 'dart:async';
import 'dart:html';

class MyComponent extends StreamComponent {
  
  MyComponent() {
    onMounted.listen((_) => print('didmount'));
    onUnmounted.listen((_) => print('unmounted'));
    propsStream.listen(print); // doesn't work
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
var simpleComponentFactory = react.registerComponent(() => new MyComponent());

void main() {
  setClientConfiguration();
  var mountedNode = querySelector('#content');
  
  var propsButton = (querySelector('#setprops') as ButtonElement);
  propsButton.disabled = true;
  
  
  var input = react.render(react.input({"ref":"myInput"}), querySelector("#test"));
  
//  input.focus();
  print(input);
    
  querySelector('#mount').onClick.listen(
    (_) { 
      var props = {'text' : 'something'};
      
      MyComponent c = react.render(simpleComponentFactory(props), mountedNode);
      
      
      propsButton.disabled = false;
      propsButton.onClick.listen((_) {
        c.setProps({'text': 'something else'} );
      });
    });
    
  querySelector('#unmount').onClick.listen((_)  {
    react.unmountComponentAtNode(mountedNode);
    propsButton.disabled = true;
  });  
}