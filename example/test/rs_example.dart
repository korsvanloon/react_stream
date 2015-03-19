import "package:react/react.dart" as react;
import "package:react/react_client.dart";
import "dart:html";
import "dart:convert";
import "dart:async";

class _GeocodesResultItem extends react.Component {
  String lat, lng, formatted;
  
  _GeocodesResultItem({this.lat, this.lng, this.formatted}) : super();

  render() {
    return new react.tr({}, [
      new react.td({}, lat),
      new react.td({}, lng),
      new react.td({}, formatted)
    ]);
  }
}

class _GeocodesResultList extends react.Component {
  
  Stream data;
  
  _GeocodesResultList({this.data}) : super();

  @override
  render() {
    
//    data.toList().then((addresses) {
//      
//    });
    
    return new react.div({'id': 'results'}, [
      new react.h2({}, "Results:"),
      new react.table({'className': 'table'}, [
        new react.thead({}, [
          new react.th({}, 'Latitude'),
          new react.th({}, 'Longitude'),
          new react.th({}, 'Address')
        ]),
        new react.tbody({},
          // addresses is a stream!!!!
          data.map(
            // Usecase for our custom component.
            (item) => new _GeocodesResultItem(
              lat: item['geometry']['location']['lat'],
              lng: item['geometry']['location']['lng'],
              formatted: item['formatted_address']
            )
          )
        )
      ])
    ]);
  }
}

class _GeocodesForm extends react.Component {
  
  Function onSubmit;
  
  _GeocodesForm({this.onSubmit}) : super();

  render() {
    return new react.div({}, [
      new react.h2({}, "Search"),
      new react.form({'onSubmit': onFormSubmit}, [
        new react.input({
          'type': 'text',
          'placeholder': 'Enter address',
          'ref': 'addressInput'
        }),
        new react.input({'type': 'submit'}),
      ])
    ]);
  }

  onFormSubmit(e) {
      e.preventDefault();
      var addr = ref('addressInput').value;
      ref('addressInput').value = "";
      onSubmit(addr);
    }
}

class _GeocodesHistoryItem extends react.Component {
  
  Function onReload;
  var query;
  var status;
  
  _GeocodesHistoryItem({this.onReload, this.query, this.status}) : super();

  reload(e) {
    onReload(query);
  }

  @override
  render() {
    return new react.li({}, [
      new react.button({'onClick': reload}, 'Reload'),
      " ($status) $query"
    ]);
  }
}

class _GeocodesHistoryList extends react.Component {
  
  Stream history;
  Function onReload;
  
  _GeocodesHistoryList({this.history, this.onReload}) : super() {
    history.listen((h) => render({history: h}));
  }
  

  @override
  render(props) {
    return new react.div({}, [
      new react.h3({}, "History:"),
      new react.ul({},
        props['history'].map(
          (e) => new _GeocodesHistoryItem(
//            key: key,
            query: e['query'],
            status: e['status'],
            onReload: onReload
          )
        )
      )
    ]);
  }
}

class _GeocodesApp extends react.Component {

  _GeocodesApp() : super();
  
  Stream get shownAddresses => addressController.stream;

  StreamController addressController = new StreamController();

  void newQuery(String addr) {

    addr = Uri.encodeQueryComponent(addr);
    var path = 'https://maps.googleapis.com/maps/api/geocode/json?address=$addr';

    HttpRequest.getString(path)
      .then((value) =>
        // Delay the answer 2 more seconds, for the test purposes
        new Future.delayed(new Duration(seconds:2), ()=>value)
      )
      .then((String raw) {
        var data = JSON.decode(raw);

        addressController.add(data['results']);
      });
  }

  @override
  render() {
    return new react.div({}, [
        new react.h1({}, "Geocode resolver"),
        new _GeocodesResultList(
          data: shownAddresses // stream?
        ),
        new _GeocodesForm(
          onSubmit: newQuery
        ),
        new _GeocodesHistoryList(
          history: shownAddresses, // stream
          onReload: newQuery
        )
    ]);
  }
}

void main() {
  setClientConfiguration();
  
  // Todo: automatic
  registerComponents([_GeocodesApp, _GeocodesForm, _GeocodesHistoryItem, 
                      _GeocodesHistoryList, _GeocodesResultItem, _GeocodesResultList]);
  
  
  react.render(new _GeocodesApp(), querySelector('#content'));
}