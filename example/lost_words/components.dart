library lost_words.components;
import 'package:react_stream/react.dart';
import 'dart:async';
import 'package:stream_transformers/stream_transformers.dart';
import 'dart:math' show min;


class SearchComponent extends ReactComponent {

  Stream<String> get word$ => _wordSearch.keyboard$
//    .transform(new Debounce(new Duration(milliseconds:300)))
    .map((e) => _wordSearch.value);

  Stream<String> get meaning$ => _meaningSearch.keyboard$
//    .transform(new Debounce(new Duration(milliseconds:300)))
    .map((e) => _meaningSearch.value);

  DomForm _wordSearch = input(className:'form-control', listenTo:['onKeyUp']);
  DomForm _meaningSearch = input(className:'form-control', listenTo:['onKeyUp']);
  @override
  render() {
    return div(className:'form-inline', content:[
      div(className:'form-group', content: [
        label(content: 'Woord'),
        _wordSearch,
      ]),
      div(className:'form-group', content: [
        label(content: 'Betekenis'),
        _meaningSearch,
      ]),
    ]);
  }
}

class WordListComponent extends ReactComponent {
  WordListComponent(this.dictionary, {this.numberResults: 10});
  final List<Meaning> dictionary;
  final int numberResults;

  String _wordFilter = '';
  set wordFilter(String s) {
    _wordFilter = s;
    _step = 0;
    repaint();
  }

  String _meaningFilter = '';
  set meaningFilter(String s) {
    _meaningFilter = s;
    _step = 0;
    repaint();
  }

  _filter(Meaning m) {
    return ( _wordFilter == '' || m.words.any((word) => word.toLowerCase().contains(_wordFilter))) &&
         (_meaningFilter == '' || m.meaning.any((meaning) => meaning.toLowerCase().contains(_meaningFilter)));
  }
  get filtered => dictionary.where(_filter);

  int _step = 0;
  next() {
    if(filtered.length / numberResults <= _step+1) return;

    _step++;
    repaint();
  }
  prev() {
    if(_step == 0) return;

    _step--;
    repaint();
  }

  @override
  render() {
    var skip = _step * numberResults;
    return div(className:'panel panel-default', content: [

      div(className: 'panel-heading', content: [
        '$skip - ${min(skip + numberResults, filtered.length)} of ${filtered.length}',
        span(className:'pull-right text-muted', content: 'gebruik links/rechts pijltjes voor vorige/volgende')
      ]),

      ul(className: 'list-group', content: filtered.skip(skip).take(numberResults).map((i) =>
        li(className:'list-group-item', content: [
          span(className: 'words', content: i.words.join(', ')),
          i.classification != null ? span(className:'classification', content:'(${i.classification})') : '',
          ol(className:'meanings', content: i.meaning.map((m) => li(content:m))),
          span(className: 'grey', content: i.explanation)
        ])
      ))
    ]);
  }

}



class Meaning {
  List<String> words;
  String classification;
  List<String> meaning;
  String explanation;

  Meaning.fromJson(Map json) {
    words = json['words'];
    classification = json['classification'];
    meaning = json['meaning'];
    explanation = json['explanation'];
  }

  Map get map => {
    'words': words,
    'classification': classification,
    'meaning': meaning,
    'explanation': explanation
  };
  @override
  toString() {
    return '\n$words '
    + (classification != null ? '($classification) ':'')
    + '$meaning' + (explanation != null ? explanation : '');
  }
}
