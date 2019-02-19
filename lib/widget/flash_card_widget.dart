import 'dart:math';

import 'package:flash_card/data/card.dart';
import 'package:flash_card/data/flash_card_dao.dart';
import 'package:flash_card/data/tts_helper.dart';
import 'package:flash_card/widget/loading_widget.dart';
import 'package:flash_card/widget/sentence_card.dart';
import 'package:flash_card/widget/ui_state.dart';
import 'package:flash_card/widget/verb_card.dart';
import 'package:flash_card/widget/word_card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class FlashCardWidget extends StatefulWidget {

  final FlashCardDAO _dao;

  FlashCardWidget(this._dao, {Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _FlashCardState(_dao); // _FlashCardStateImpl();
}

class _FlashCardState extends State<FlashCardWidget> {
  final FlashCardDAO _dao;
  TTSHelper _ttsHelper = TTSHelper();

  _FlashCardState(this._dao) {
    _uiState = LoadingUIState();
  }

  @override
  void initState() {
    super.initState();
    next();
    _ttsHelper.initState();
  }

  FlashCardUIState _uiState;

  void update(FlashCardUIState newState) {
    setState(() {
      _uiState = newState;
    });
  }

  void next() {
    update(LoadingUIState());
    _dao.randomCard().then((card) {
      if (card is WordCard) {
        update(WordCardUIState(card));
      } else if (card is VerbFormCard) {
        VerbFormCard verb = card;
        int numPronouns = verb.forms.keys.length;
        int index = Random().nextInt(numPronouns);
        String pronoun = verb.forms.keys.elementAt(index);
        update(VerbCardUIState(verb, pronoun));
      } else if (card is SentenceCard) {
        update(SentenceCardUIState(card));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_uiState.canMoveNext()) {
          print("next");
          next();
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        print("flip");
        update(_uiState.flip());
      },
      child: Container(
          color: _uiState.cardColor(),
          child: _uiState.build(context)
      ),
    );
  }
}
