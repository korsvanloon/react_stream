import 'dart:html';
import 'keychar.dart';
import 'package:react_stream/react.dart';
import 'package:stream_transformers/stream_transformers.dart';
import 'dart:async';

TranslatedFragmentsComponent fragments;
KeyboardComponent keyboard;
LanguageSwitchComponent languageSwitch;
TranslateInputComponent translateInput;

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
  translateInput = new TranslateInputComponent( languages.first );
  languageSwitch = new LanguageSwitchComponent( languages );
  keyboard = new KeyboardComponent( languages.first.characters );
  fragments = new TranslatedFragmentsComponent();


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
}

class KeyboardComponent extends ReactComponent {
  KeyboardComponent(characters) :
    this._characters = characters,
    this._hint = false;

  List<KeyBoardChar> _characters;

  set characters(List<KeyBoardChar> c) {
    _characters = c;
    repaint();
  }

  bool _hint;

  KeyBoardChar _highLight;
  set highLight(KeyBoardChar char) {
    _highLight = char;
    repaint();
  }

  set hint(bool h) {
    _hint = h;
    repaint();
  }

  var _keyboard = [r"qwertyuiop[]",r"asdfghjkl;'\",r"`zxcvbnm,./"];

  @override
  ReactElement render() {
    return div(className: 'keyboard', content: _keyboard.map((line) {
      return div(className:'line', content: line.split('').map((key) {
        var keyboardChar = _characters.firstWhere((r) => r.keyChar == key, orElse: () => null);
        var letter = keyboardChar != null ? (_hint ? keyboardChar.letter : keyboardChar.char) : '';
        var hl = keyboardChar == _highLight ? 'highlight' : '';
        return span(className: hl, content: letter);
      }));
    }));
  }
}

class Language {
  String name;
  List<KeyBoardChar> characters;
  Language(this.name, this.characters);
}

class LanguageSwitchComponent extends ReactComponent {

  LanguageSwitchComponent(this._languages) {
    _div = div(listenTo:['onClickCapture'], content: _languages.map((l) {
      return button(className: '', content:l.name);
    }));
  }

  Stream<Language> get selected$ => _div.mouse$.map((e) => _languages.firstWhere((l) => l.name == e.target.text));

  List<Language> _languages;

  DomElement _div;

  @override
  ReactElement render() {
    return _div;
  }
}

class TranslateInputComponent extends ReactComponent {
  TranslateInputComponent(this.language);
  Language language;

  ready() {
    // prevent disabled keys
    _textarea.keyboard$.where((e) => e.type == 'keypress' && !_isValidKeyCode(e.charCode))
    .listen((e) {
      e.nativeEvent.preventDefault();
      return;
    });
  }

  DomForm _textarea = textarea(listenTo:['onKeyPress','onKeyDown','onKeyUp']);

  set value(v) => _textarea.value = v;
  get value => _textarea.value;

  Stream<bool> get shouldShowHint$ => _textarea.keyboard$
    .map((e) => e.type == 'keydown' && e.altKey);

  Stream<Translation> get translation$ => _textarea.keyboard$
    .where((e) => e.type == 'keyup')
    .map((e) => new Translation(language, e.target.value, _translate(e.target.value)));

  Stream<KeyBoardChar> get char$ => _textarea.keyboard$
    .where((e) => e.type == 'keypress' && language.characters.map((c) => c.keyChar).contains(e.key))
//    .distinct()
    .map((e) => language.characters.firstWhere((r) {
      return r.keyChar == e.key;
    }));

  String _translate(String text) {
    return text.split('').map((char) {
      if([' ','\n'].contains(char)) return char;
      return language.characters.firstWhere((r) => r.keyChar == char).char;
    }).join();
  }
  bool _isValidKeyCode(int charCode) {
    var char = new String.fromCharCode(charCode).toLowerCase();
    var inKeyboard = language.characters.map((r) => r.keyChar).contains(char);
    return inKeyboard
        || (!["'"].contains(char) && charCode < 44); //exception for weird characters
  }

  @override
  ReactElement render() {
    return _textarea;
  }
}

class Translation {
  Translation(this.language, this.original, this.text);
  final Language language;
  String text;
  String original;
}

class TranslatedFragmentsComponent extends ReactComponent {
  TranslatedFragmentsComponent();

  void update(Translation translation) {
    // same language: update fragment
    if(_currentText != null && translation.language == _currentText.language) {
      _currentText.text = translation.text;
      _currentText.original = translation.original;
    }
    // other language: create new fragment
    else {
      _texts.add(translation);
//        texts.insert(texts.indexOf(currentText), t);
      _currentText = translation;
    }
    repaint();
  }

  domReady() {
    selected$.listen((translation) {
      _currentText = translation;
      repaint();
    });
    ;
  }

  Stream<Translation> get selected$ => _div.mouse$.map((e) => _texts.firstWhere((t) => t.text == e.target.text));

  DomElement _div = div(listenTo:['onClickCapture']);
  List<Translation> _texts = <Translation>[];
  Translation _currentText;

  @override
  ReactElement render() {
    return _div..content = _texts.map((tf) {
      var selected = tf == _currentText ? ' selected' : '';
      return span(className: tf.language.name + selected, content: tf.text);
    });
  }
}