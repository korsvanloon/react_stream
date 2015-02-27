import 'package:observe/observe.dart';
import 'package:observe/mirrors_used.dart'; // for smaller code

class Monster extends Object with ChangeNotifier {
  int _health = 100;
  @reflectable get health => _health;
  @reflectable set health(val) {
    _health = notifyPropertyChange(#health, _health, val);
  }

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
  // Schedules asynchronous delivery of these changes
  obj.damage(10);
  obj.damage(20);
  print('done!');
}