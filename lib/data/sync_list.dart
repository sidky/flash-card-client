import 'package:flash_card/data/card.dart';

class SyncList<T extends HasKey> {
  final List<T> _items = List();

  List<T> get items => _items;

  clear() {
    _items.clear();
  }

  addAll(List<T> items) {
    _items.clear();
    _items.addAll(items);
  }

  onAdd(T item) {
    _items.add(item);
  }

  onRemove(T item) {
    _items.removeWhere((it) => it.key == item.key);
  }

  onChanged(T item) {
    var index = _items.indexWhere((it) => it.key == item.key);
    if (index >= 0) {
      _items[index] = item;
    } else {
      _items.add(item);
    }
  }

  int get length => _items.length;

  T operator [](int index) => _items[index];

  void operator []=(int index, T value) => _items[index] = value;
}