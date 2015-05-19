import 'package:react_stream/react.dart';
import 'dart:html' as html;
import 'components.dart';

main() {
  var kors = new User('Kors', 'image/kors.jpeg');
  var ani = new User('Ani', 'image/ani.jpg');
  var georgi = new User('Georgi', 'image/georgi.jpeg');
  
  html.DivElement div = new html.DivElement();
  div.scrollTop = div.scrollHeight;
  
  kors.friends.addAll([ani, georgi]);
  ani.friends.addAll([kors, georgi]);
  georgi.friends.addAll([kors, ani]);
  
  var app1 = new ChatAppComponent(kors);  
  var app2 = new ChatAppComponent(ani);
  var app3 = new ChatAppComponent(georgi);

  render(app1, html.document.querySelector('#app1'));
  render(app2, html.document.querySelector('#app2'));
  render(app3, html.document.querySelector('#app3'));
}