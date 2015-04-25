import 'package:react_stream/react.dart';
import 'dart:html';

class Component extends ReactComponent {
  Component(Map props) : super(props);

  @override
  ReactElement render() {
    return 
    div({'className': 'black'}, [
      div({'className': 'green'}, 
        button({}, 'test2')),
      button({}, 'test3')
    ]);
  }
}

main() {
  var container = document.querySelector('#container');
  
  var element = button({}, ['test']);
  element.uiEvent$.listen((e) => print(e.nativeEvent));
  
  render(element, container);
  
  var mycomp = new Component({});
  mycomp.lifeCycle$.listen(print);
  mycomp.uiEvent$.listen(print);

  var container2 = document.querySelector('#container2');
  render(mycomp, container2);

  // to check if the lifeCycle$ continues...
  unmountComponentAt(container2); 
  render(mycomp, container2);
}