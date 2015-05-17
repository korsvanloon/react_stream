import 'package:react_stream/react.dart';
import 'package:frappe/frappe.dart';
import 'dart:convert';
//import 'package:diff_match_patch/diff_match_patch.dart';
import '../lib/util.dart';
import 'dart:html';

class ApplicationComponent extends ReactComponent {
  ApplicationComponent(this._json$);

  EventStream _json$;
  EventStream _toggle$;

  bool _started = true;

  @override
  ready() {
    
    const MULTIPLIER = 5;        
    
    var sliderDuration = new EventStream(_range.form$)
       // Map the value of the slider onto a duration 
      .map((e) => new Duration(milliseconds: MULTIPLIER * int.parse(e.target.value)));
    
    // We actually wanted to merge a unit stream with the sliderduration,
    // but the merge method is bugged.
    var duration = new Subject<Duration>()
        // the initial value of the slider
        ..add(new Duration(milliseconds: MULTIPLIER*50))
        ..addStream(sliderDuration)

    ;
    
    // Convert the button events to a boolean toggle stream.
    _toggle$ = new EventStream(_button.mouse$)
      .scan(true, (prev, _) => !prev);

    // TODO: subscription.pause instead of when(_toggle$)
//    var subscription = _json$.listen();
//    subscription.pause();
    
    var tweet$ = duration.stream.asBroadcastStream()
        //change the speed of the stream
        .flatMapLatest((duration) => _json$.sampleEachPeriod(duration))
        // filter out the empty data created by flatmap/sample
        .where((e) => e.containsKey('created_at'))
        // only run when the button allows it
        .when(_toggle$)
      ;



    var lang$ = tweet$.map((data) => data['lang']);

    Subject onTweetClicked = new Subject();
    Subject onFilter = new Subject()..add((d) => true);

    _languageFilter = new LanguageFilterComponent(lang$, onFilter);
    _tweetList = new TweetListComponent(tweet$, onTweetClicked, onFilter.stream);
    _detail = new DetailComponent(onTweetClicked.stream);
  }

  @override
  domReady() {
    _toggle$.listen((s) { _started = s; repaint(); });
  }

  DomForm _range = range(listenTo:['onChange']);
  DomElement _button = button(className: 'btn btn-default btn-lg', listenTo:['onClick']);
  LanguageFilterComponent _languageFilter;
  TweetListComponent _tweetList;
  DetailComponent _detail;
  
  @override
  render() {
    var buttonText = _started ? 'Pauze' : 'Start';
      
    return 
    div(className: 'container', content:[
      _button..content = buttonText,
      _range,
      _languageFilter,
      _tweetList,
      _detail,
    ]);
  }
}

class TweetListComponent extends ReactComponent {

  TweetListComponent(this._tweet$, this._onTweetClicked, this._filter$);

  EventStream _tweet$;
  Function _onTweetClicked;
  EventStream _filter$;

  domReady() {
    _tweet$.scan([], (l, i) => l..insert(0, i))
      .listen((list) => tweets = list);

    _filter$.listen((f) => filter = f);

    _ul.mouse$.listen((e) {
      // TODO: fix this id thing

      var li = e.target;
      while(!(li is LIElement)) {
        li = li.parent;
      }

      var t = _tweets.firstWhere((t) => li.id == t['id_str']);
      selected = t;
      _onTweetClicked(t);
    });
  }

  Function _filter;
  set filter(Function f) {
    _filter = f;
    repaint();
  }

  List _tweets = [];
  set tweets(List t) {
    _tweets = t;
    repaint();
  }

  Map _selected = null;
  set selected(Map s) {
    _selected = s;
    repaint();
  }

  DomElement _ul = ul(className: 'col-sm-5 media-list', listenTo:['onClickCapture']);
  
  @override
  render() {
    return _ul..content = _tweets.where(_filter).map((t) =>

      li(id:t['id_str'], className: 'media ' + (t == _selected ? 'selected' : ''), content: [
          div(className: 'media-left', content:
            img(className: 'media-object', src: t['user']['profile_image_url'])
          ),
          div(className: 'media-body', content:[
            h4(className: 'media-heading', content:t['user']['name']),
            t['text']
          ])
        ])
      );
  }
}

class LanguageFilterComponent extends ReactComponent {
  LanguageFilterComponent(this._langStream, this._onLanguageSelected);

  EventStream _langStream;
  Function _onLanguageSelected;

  @override
  domReady() {
    
    _langStream.scan(_langs, (list, lang) {
        _add(lang, to:list);
        return list;
      })
      .listen((list) => langs = list);

    _ul.mouse$.listen((e) {
      var li = e.target;
      while(!(li is LIElement)) {
        li = li.parent;
      }
      var lang = _langs.firstWhere((l) => li.text.contains(l['lang']));
      _onLanguageSelected(_createFilterFunction(lang));
      selected = lang;
    });
  }
  
  _add(lang, {to}) {
    var l = to.firstWhere((e) => e['lang'] == lang, orElse: () => null);
    var all = to.firstWhere((e) => e['lang'] == 'all');
    all['count']++;
    if(l != null) {
      l['count']++;
    } else {
      to.add({'lang': lang, 'count': 1});
    }
  }
  
  _createFilterFunction(lang) => 
      (data) => lang['lang'] == 'all' || data['lang'] == lang['lang'];

  List _langs = [{'lang': 'all', 'count': 0}];
  set langs(List l) {
    l.sort((e1, e2) => e2['count'] - e1['count']);
    _langs = l;
    repaint();
  }

  Map _selected = null;
  set selected(Map l) {
    _selected = l;
    repaint();
  }

  DomElement _ul = ul(className: 'col-sm-2 list-group', listenTo:['onClick']);

  @override
  render() {
    return _ul..content = _langs.map((lang) =>
      li(className: 'list-group-item' + (_selected == lang ? ' selected' : ''), content: [
        lang['lang'],
        span(className:'badge', content: lang['count'])
      ])
    );
  }
}

class DetailComponent extends ReactComponent {
  DetailComponent(this._tweet$);
  EventStream _tweet$;
  var _encoder = new JsonUtf8Encoder(' ');

  ready() {
    _tweet$.listen((t) => tweetJson = t);
  }

  Map _tweetJson;
  set tweetJson(Map l) {
    _tweetJson = l;
    repaint();
  }

  @override
  render() {
    return pre(className: 'col-sm-5 details', content: UTF8.decode(_encoder.convert(_tweetJson))
    );
  }
}