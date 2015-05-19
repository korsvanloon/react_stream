import 'keychar.dart';
import 'dart:async';
import 'package:react_stream/react.dart';


class Language {
  Language(this.name, this.characters);
  final String name;
  final List<KeyBoardChar> characters;
}

class Translation {
  Translation(this.language, this.original, this.text);
  final Language language;
  String text;
  String original;
}

class KeyboardComponent extends ReactComponent {
  KeyboardComponent(this._characters);

  List<KeyBoardChar> _characters;
  // Replace the keyboard characterset
  set characters(List<KeyBoardChar> c) {
    _characters = c;
    repaint();
  }

  /// The clicked character objects.
  Stream<KeyBoardChar> get char$ => _div.mouse$
  .map((e) => _characters.firstWhere((c) => c.char == e.target.text, orElse: () => null))
  .where((c) => c != null);

  KeyBoardChar _highLight;
  // Highlight a key
  set highLight(KeyBoardChar char) {
    _highLight = char;
    repaint();
  }

  bool _hint = false;
  // Show / don't show the transliterations of the characters
  set hint(bool h) {
    _hint = h;
    repaint();
  }

  var _keyboard = [r"qwertyuiop[]",r"asdfghjkl;'\",r"`zxcvbnm,./"];

  DomElement _div = div(className: 'keyboard', listenTo:['onClick']);

  @override
  ReactElement render() {
    return _div..content =  _keyboard.map((line) {
      return div(className:'line', content: line.split('').map((key) {
        var keyboardChar = _characters.firstWhere((r) => r.keyChar == key, orElse: () => null);
        var letter = keyboardChar != null ? (_hint ? keyboardChar.letter : keyboardChar.char) : '';
        var hl = keyboardChar == _highLight ? 'highlight' : '';
        return span(className: hl, content: letter);
      }));
    });
  }
}

class LanguageSwitchComponent extends ReactComponent {
  LanguageSwitchComponent(this._languages);
  List<Language> _languages;

  /// A stream of clicked languages
  Stream<Language> get selected$ => _div.mouse$
    .map((e) => _languages.firstWhere((l) => l.name == e.target.text));

  DomElement _div = div(listenTo:['onClickCapture']);

  @override
  ReactElement render() {
    return _div..content = _languages.map((l) {
      return button(className: '', content:l.name);
    });
  }
}

class TranslateInputComponent extends ReactComponent {
  TranslateInputComponent(this.language);
  Language language;

  ready() {
    // prevent disabled keys from entering the textArea
    _textarea.keyboard$.where((e) => e.type == 'keypress' && !_isValidKeyCode(e.charCode))
    .listen((e) {
      e.nativeEvent.preventDefault();
      return;
    });
  }

  set value(v) => _textarea.value = v;
  get value => _textarea.value;

  /// Whenever alt is (being) pressed
  Stream<bool> get altDown$ => _textarea.keyboard$
    .map((e) => e.type == 'keydown' && e.altKey);

  Stream<Translation> get translation$ => _textarea.keyboard$
    .where((e) => e.type == 'keyup')
    .map((e) => new Translation(language, e.target.value, _translate(e.target.value)));

  /// Typed character objects
  Stream<KeyBoardChar> get char$ => _textarea.keyboard$
    .where((e) => e.type == 'keypress' && language.characters.map((c) => c.keyChar).contains(e.key))
    .distinct()
    .map((e) => language.characters.firstWhere((r) => r.keyChar == e.key));

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

  DomForm _textarea = textarea(listenTo:['onKeyPress','onKeyDown','onKeyUp']);

  @override
  ReactElement render() {
    return _textarea;
  }
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

  /// Stream of selected translation
  Stream<Translation> get selected$ => _div.mouse$
    .map((e) => _texts.firstWhere((t) => t.text == e.target.text));

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

class DetailComponent extends ReactComponent {

  Rune _rune;
  /// Set the rune to show its details
  set rune(Rune r) {
    _rune = r;
    repaint();
  }

  @override
  ReactElement render() {
    if(_rune == null) return div();

    return div(className:'', content:[
      h2(content: [_rune.char + ' ', span(className:'small', content: _rune.letter)]),
      p(content: [
        span(className:'label', content:'naam: '),
        '${_rune.name}: ${_rune.nameTranslation}']),
      p(content: [
        span(className:'label', content:'betekenis: '),
        _rune.meaning,
      ]),
    ]);
  }
}