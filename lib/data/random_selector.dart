import 'dart:math';

import 'package:flash_card/data/card.dart';
import 'package:flash_card/data/sync_list.dart';

class _WeightedList<T extends HasKey> {
  final SyncList<T> list;
  final int weight;

  const _WeightedList(this.list, this.weight);
}

class RandomSelector<T extends HasKey> {
  final List<_WeightedList<T>> _lists = List();
  final Random _rng = Random();

  addList(SyncList list, int weight) {
    _lists.add(_WeightedList(list, weight));
  }

  T randomItem() {
    var weight = _totalWeight();
    var selector = _rng.nextInt(weight);

    for (int i = 0; i < _lists.length; i++) {
      int listWeight = _lists[i].list.length * _lists[i].weight;
      if (selector < listWeight) {
        return _lists[i].list[selector ~/ _lists[i].weight];
      } else {
        selector -= listWeight;
      }
    }
    return null;
  }

  int _totalWeight() => _lists.fold(0, (total, wl) => total + wl.list.length * wl.weight);
}