import 'dart:html';
import 'package:react_stream/react.dart';
import 'package:stream_transformers/stream_transformers.dart';
import 'dictionary.dart';
import 'components.dart';


main() {

  /**********************
      define components
   **********************/
  var search = new SearchComponent();
  var parsedDictionary = dictionary.map((i) => new Meaning.fromJson(i)).toList();
  var wordlist = new WordListComponent(parsedDictionary, numberResults: 6);

  /**********************
      render components
   **********************/
  render(search, querySelector('#search'));
  render(wordlist, querySelector('#wordlist'));


  /**********************
      connect components
   **********************/
  search.word$.listen((v) {
    wordlist.wordFilter = v;
  });
  search.meaning$.listen((v) {
    wordlist.meaningFilter = v;
  });

  document.onKeyDown
    .where((e) => [KeyCode.LEFT, KeyCode.RIGHT].contains(e.keyCode) && !(e.target is InputElement))
    .listen((e) {
      if(e.keyCode == KeyCode.LEFT)
        wordlist.prev();
      else
        wordlist.next();
  });
}