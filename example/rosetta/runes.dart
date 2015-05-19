import 'dart:html';
import 'keychar.dart';
import 'package:react_stream/react.dart';
import 'package:stream_transformers/stream_transformers.dart';
import 'components.dart';


main() {

  /**********************
      define components
   **********************/
  var keyboard = new KeyboardComponent(elderFuthark);
  var detail = new DetailComponent();
  var button = document.querySelector('button');

  /**********************
      render components
   **********************/
  render(detail, querySelector('#detail'));
  render(keyboard, querySelector('#keyboard'));


  /**********************
      connect components
   **********************/
  // listen to keypresses and convert them to Rune objects
  document.onKeyPress
    .map((e) => new String.fromCharCode(e.charCode))
    .map((char) => elderFuthark.firstWhere((r) => r.keyChar == char, orElse: () => null))
    .where((r) => r != null)

    // merge with the character click stream from the keyboard component
    .transform(new Merge(keyboard.char$))

    // highlight the keyboard keys and update the detail component
    .listen((rune) {
      keyboard.highLight = rune;
      detail.rune = rune;
    }
  );

  // toggle hint when this button is clicked
  button.onClick
    .transform(new Scan(false, (p,c) => !p)).listen((showHint) {
    keyboard.hint = showHint;
  });
}

