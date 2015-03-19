import 'package:react_stream/react_stream.dart';
import 'dart:html';
import 'dart:convert';

class ParentComponent extends StreamComponent {
  
  @override
  render() {
    // TODO: implement render
  }
}

class ChildComponent extends StreamComponent {
  
  @override
  render() {
    // TODO: implement render
  }
}
DivElement result;

main() {
  
  var url = 'wss://ws.blockchain.info/inv';
  var ws = new WebSocket(url);
  ws.onMessage.listen(handleMessage);
  
  querySelector('#btn').onClick.listen((e) => ws.sendString('{"op":"unconfirmed_sub"}')); 
  result = querySelector('#result');
//  ws.sendString('testing');
}

handleMessage(e) {
  var data = JSON.decode(e.data)['x'];
  double output = data['inputs'][0]['prev_out']['value'] / 100000000;
//  result.append(new PreElement()..text = JSON.encode(data));
  result.append(new PreElement()..text = 'BTC: $output');
}

/*
{
   "op":"utx",
   "x":{
      "lock_time":0,
      "ver":1,
      "size":223,
      "inputs":[
         {
            "sequence":4294967295,
            "prev_out":{
               "spent":true,
               "tx_index":80993498,
               "type":0,
               "addr":"1CNtWiRfoc2LUizsUXFw9kvrzCrmQbNSmf",
               "value":3914335525,
               "n":1,
               "script":"76a9147ccd1e7f8aa987cead009f50ac0019f03f65e85b88ac"
            },
            "script":"47304402204e395c832f9394b4be996e709f6d8a4e35ba2dc4825883cf01962ba89493070302201221368ccfd4892c5756eb23c38e2794aef78cb0a8bae674b462f41b8b22d11a0121024964494f9c5643376ab8c35012825157c291507d074915fc73cec593e11ef254"
         }
      ],
      "time":1426765250,
      "tx_index":81003898,
      "vin_sz":1,
      "hash":"a86f7e01d6010c1d85768da2c804327b3cca7e6fdddad22a4cfd5ee0301f3d58",
      "vout_sz":2,
      "relayed_by":"5.9.97.106",
      "out":[
         {
            "spent":false,
            "tx_index":81003898,
            "type":0,
            "addr":"345X5Yu2bZbE96yobDjm3PHiWCoewCysjf",
            "value":19274082,
            "n":0,
            "script":"a9141a31bd86ee5c7a513831f86c12f923a5fb78492787"
         },
         {
            "spent":false,
            "tx_index":81003898,
            "type":0,
            "addr":"18pqUuU1HDPAL6a9XEHpmemVDVwQaEqVnm",
            "value":3895051443,
            "n":1,
            "script":"76a91455d4e6935b40c51c1f1f5cb1b4651385e15eb5b388ac"
         }
      ]
   }
}
*/