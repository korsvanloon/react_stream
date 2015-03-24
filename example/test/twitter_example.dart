import 'dart:html';
import 'dart:async';

main() {
  var request = new HttpRequest();
  var url = 'https://stream.twitter.com/1/statuses/sample.json';
  var authorization = 'OAuth oauth_consumer_key="PLLYguQdJqooNfAKwTlZe5MMi", oauth_nonce="be4ff4faa230bdcc40bae74a78792fa8", oauth_signature="oOHHZE9ywNy4e6HD9cJ6A9UOqbA%3D", oauth_signature_method="HMAC-SHA1", oauth_timestamp="1426778106", oauth_token="2238912169-ThdEALf8Wxbg1aCpIVEMWD64tphM1hXipLJe2MM", oauth_version="1.0"';
  
  request.open('GET', url);

  request.setRequestHeader('Authorization', authorization);
  request.setRequestHeader('User-Agent', 'OAuth gem v0.4.4');
  request.setRequestHeader('accept', '*/*');
  request.onProgress.listen(print);
  request.onLoad.listen((ProgressEvent event) => print(
      event));
  request.send();
//  HttpRequest.request(url).then((r) {
//    request.response;
//  });
}