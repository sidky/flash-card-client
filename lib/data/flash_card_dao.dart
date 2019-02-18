import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_card/data/sync_list.dart';
import 'card.dart';

import 'dart:math';

class FlashCardDAO {

  final SyncList<WordCard> _words = SyncList();
  final SyncList<VerbFormCard> _verbs = SyncList();

  final FirebaseApp app;

  final Random rng = Random();

  FirebaseDatabase _db;

  FlashCardDAO(this.app);

  bool _initialized = false;

  Future<void> initialize() async {
    _db = FirebaseDatabase(app: this.app);

    var isPersistant = await _db.setPersistenceEnabled(true);
    print('Persistant: $isPersistant');
    await _db.setPersistenceCacheSizeBytes(10000000);

    _addListeners("words", _words, _getCardFromMap);
    _addListeners("verbs", _verbs, _getVerbFromMap);

    // Verbs
    var verbRef = _db.reference().child("verbs");
    await verbRef.once().then((snapshot) {
    });

    _initialized = true;
  }

  void _addListeners<T extends HasKey>(String child, SyncList<T> list, T converter(String key, dynamic value)) async {
    var ref = _db.reference().child(child);
    var items = await ref.once().then((snapshot) {
      Map values = snapshot.value;

      List<T> items = List();
      values.forEach((key, value) => items.add(converter(key, value)));
      return items;
    });
    list.addAll(items);

    ref.onChildAdded.listen((event) {
      var snapshot = event.snapshot;
      var item = converter(snapshot.key, snapshot.value);
      list.onAdd(item);
    });

    ref.onChildRemoved.listen((event) {
      var snapshot = event.snapshot;
      var item = converter(snapshot.key, snapshot.value);
      list.onRemove(item);
    });

    ref.onChildChanged.listen((event) {
      var snapshot = event.snapshot;
      var item = converter(snapshot.key, snapshot.value);
      list.onChanged(item);
    });
  }

  Future<WordCard> randomFlashCard() async {
    if (!_initialized) {
      await initialize();
    }
    var length = _words.length;
    var index = rng.nextInt(length);

    return _words[index];
  }

  Future<HasKey> randomCard() async {
    if (!_initialized) {
      await initialize();
    }

    var total = _words.length + _verbs.length;
    var index = rng.nextInt(total);

    if (index < _words.length) {
      return _words[index];
    } else {
      return _verbs[index - _words.length];
    }
  }

  WordCard _getCardFromMap(String word, dynamic values) {
    Map map = values;
    String translation = map['value'];
    WordType wordType = parseWordType(map['type']);
    Map relatedWordMap = map['related'];
    List<RelatedWord> relateds = List();

    if (relatedWordMap != null) {
      relatedWordMap.forEach((key, value) {
        RelatedType type = parseRelatedWordType(key);
        relateds.add(RelatedWord(type, value));
      });
    }

    return WordCard(word, translation, wordType, relateds);
  }

  VerbFormCard _getVerbFromMap(String word, dynamic values) {
    final Map map = values;
    final String translation = map['value'];
    Map forms = map['forms'];

    Map<String, String> pronouns = Map();

    forms.forEach((key, value) {
      pronouns[key] = value as String;
    });

    return VerbFormCard(word, translation, pronouns);
  }
}