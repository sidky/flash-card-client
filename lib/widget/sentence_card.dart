import 'dart:ui';

import 'package:flash_card/data/card.dart';
import 'package:flash_card/widget/deutsch_tts.dart';
import 'package:flash_card/widget/ui_state.dart';
import 'package:flutter/material.dart';

abstract class _AbstractSentenceCardUIState extends FlashCardUIState {

  @override
  bool canMoveNext() => true;

  @override
  Color cardColor() => Color.fromARGB(255, 0xff, 0xeb, 0xcd);
}

class SentenceCardUIState extends _AbstractSentenceCardUIState {

  final SentenceCard _card;

  SentenceCardUIState(this._card);

  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(sentence, style: TextStyle(fontSize: 25),),
            DeutscheTTS(sentence)
          ],
        )
      )
    );
  }

  @override
  FlashCardUIState flip() => SentenceCardAnswerUIState(_card);

  String get sentence => _card.question != null && _card.question.isNotEmpty ? _card.question : _card.answer;
}

class SentenceCardAnswerUIState extends _AbstractSentenceCardUIState {
  final SentenceCard _card;

  SentenceCardAnswerUIState(this._card);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(child: Text(
            _primaryAnswer,
            style: TextStyle(fontSize: 25),
          )),
        ),
        Visibility(
          visible: _shouldShowAnswer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Padding(
                  child: Text("Answer", style: TextStyle(fontSize: 25.0),),
                  padding: EdgeInsets.all(15.0),
                ),
                onTap: () {
                  displayAnswer(ctx);
                },
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  FlashCardUIState flip() => SentenceCardUIState(_card);

  String get _primaryAnswer => _card.question != null && _card.question.isNotEmpty ? _card.translation : _card.answerTranslation;

  bool get _shouldShowAnswer => _card.question != null && _card.question.isNotEmpty && _card.answer != null && _card.answer.isNotEmpty;

  void displayAnswer(BuildContext ctx) {
    showModalBottomSheet(context: ctx, builder: (BuildContext ctx) {
      return Padding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(_card.answer, style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
            DeutscheTTS(_card.answer),
            Text(_card.answerTranslation, style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),)
          ],
        ),
        padding: EdgeInsets.all(10.0),
      );
    });
  }
}