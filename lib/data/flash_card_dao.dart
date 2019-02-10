import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'card.dart';

import 'dart:math';

class FlashCardDAO {

  List<WordCard> _words = List();

  final FirebaseApp app;

  final Random rng = Random();

  FirebaseDatabase _db;

  FlashCardDAO(this.app);

  Future<void> initialize() async {
    await FirebaseDatabase.instance.setPersistenceEnabled(true);

    _db = FirebaseDatabase(app: this.app);

    var wordRef = _db.reference().child("words");

    await wordRef.once().then((snapshot) {
      Map values = snapshot.value;

      _words.clear();
      values.forEach((key, value) {
        _words.add(_getCardFromMap(key, values));
      });
    });

    wordRef.onChildAdded.listen((event) {
      _words.add(_getCard(event.snapshot));
    });

    wordRef.onChildRemoved.listen((event) {
      var word = event.snapshot.key;
      _words.removeAt(_words.indexWhere((card) => card.word == word));
    });

    wordRef.onChildChanged.listen((event) {
      var changed = _getCard(event.snapshot);
      var index = _words.indexWhere((card) => card.word == changed.word);

      if (index >= 0) {
        _words[index] = changed;
      } else {
        _words.add(changed);
      }
    });
  }

  Future<WordCard> randomFlashCard() async {
    final FirebaseDatabase db = FirebaseDatabase(app: this.app);

    WordCard card = await db.reference().child("words").once()
        .then((onValue) {
          Map data = onValue.value;
          var length = data.length;
          var index = rng.nextInt(length);
          print(length);
          print(data);
          var key = data.keys.toList().elementAt(index);
          Map values = data[key];

          WordType wordType = parseWordType(values['type']);

          Map relatedWordMap = values['related'];
          List<RelatedWord> relateds = List();

          if (relatedWordMap != null) {
            relatedWordMap.forEach((key, value) {
              RelatedType type = parseRelatedWordType(key);
              relateds.add(RelatedWord(type, value));
            });
          }

          return WordCard(key, values['value'], wordType, relateds);
        });
    return card;
  }

  WordCard _getCard(DataSnapshot snapshot) {
    var word = snapshot.key;
    Map values = snapshot.value;

    return _getCardFromMap(word, values);
  }

  WordCard _getCardFromMap(String word, Map values) {
    String translation = values['value'];
    WordType wordType = values['type'];
    Map relatedWordMap = values['related'];
    List<RelatedWord> relateds = List();

    if (relatedWordMap != null) {
      relatedWordMap.forEach((key, value) {
        RelatedType type = parseRelatedWordType(key);
        relateds.add(RelatedWord(type, value));
      });
    }

    return WordCard(word, translation, wordType, relateds);
  }
}