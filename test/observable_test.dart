import 'package:observe/observe.dart';
import 'package:observe/mirrors_used.dart'; // for smaller code

class Monster extends Object with Observable {
  @observable int health = 100;

  void damage(int amount) {
    print('$this takes $amount damage!');
    health -= amount;
  }

  toString() => 'Monster with $health hit points';
}

main() {
  var obj = new Monster();
  obj.changes.listen((records) {
    print('Changes to $obj were: $records');
  });
  // No changes are delivered until we check for them
  obj.damage(10);
  obj.damage(20);
  print('dirty checking!');

  Observable.dirtyCheck();
  print('done!');
}