import 'dart:html';
import 'keychar.dart';
import 'package:react_stream/react.dart';
import 'package:stream_transformers/stream_transformers.dart';
import 'components.dart';

main() {

  var languages = <Language>[
    new Language('Elder Futhark', elderFuthark),
    new Language('Younger Futhark', youngerFuthark),
    new Language('Anglo Futhorc', angloFuthorc),
    new Language('Medieval Runes', medievalRunes),
    new Language('Latin', latin),
  ];

  /**********************
      define components
   **********************/
  var translateInput = new TranslateInputComponent( languages.first );
  var languageSwitch = new LanguageSwitchComponent( languages );
  var keyboard = new KeyboardComponent( languages.first.characters );
  var fragments = new TranslatedFragmentsComponent();


  /**********************
      render components
   **********************/
  render(fragments, querySelector('#fragments'));
  render(languageSwitch, querySelector('#languageSwitch'));
  render(keyboard, querySelector('#keyboard'));
  render(translateInput, querySelector('#smartTextArea'));


  /**********************
      connect components
   **********************/
  // update the translation fragments when the user types
  translateInput.translation$.listen(fragments.update);

  // handle switching of languages
  languageSwitch.selected$
    // merge with translation selections
    .transform(new Merge(fragments.selected$.map((t) => t.language)))
    .distinct()
    .listen((language) {
      translateInput.language = language;
      keyboard.characters = language.characters;
    });

  // update the text inside the textarea when a different text-fragment is selected
  fragments.selected$.listen((translation) {
    translateInput.value = translation.original;
  });

  // let the keyboard show hints when alt is pressed inside the textarea
  translateInput.shouldShowHint$.listen((b) {
    keyboard.hint = b;
  });

  // highlight keyboard characters when typing
  translateInput.char$.listen((c) {
    keyboard.highLight = c;
  });

  keyboard.char$.listen(print);
}

