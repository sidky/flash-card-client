import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'card.dart';

import 'dart:math';

class FlashCardDAO {

  final FirebaseApp app;

  final Random rng = Random();

  FlashCardDAO(this.app);

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

          return WordCard(key, values['value'], wordType);
        });
    return card;
  }
}