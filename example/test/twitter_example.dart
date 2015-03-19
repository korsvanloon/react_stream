import 'dart:html';
import 'dart:async';

main() {
  var request = new HttpRequest();
  request.open('GET', 'https://stream.twitter.com/1/statuses/sample.json');
  request.onLoad.listen((event) => print(
      'Request complete ${event.target.reponseText}'));
  request.send();
}