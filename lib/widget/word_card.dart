import 'dart:ui';

import 'package:flash_card/data/card.dart';
import 'package:flash_card/widget/deutsche_tts_text.dart';
import 'package:flash_card/widget/ui_state.dart';
import 'package:flutter/material.dart';

abstract class _AbstractWordCardUIState extends FlashCardUIState {
  WordCard _card;

  _AbstractWordCardUIState(this._card);

  @override
  bool canMoveNext() => true;

  @override
  Color cardColor() {
    switch (_card.wordType) {
      case WordType.male: return Color.fromARGB(255, 135, 206, 255); // blue
      case WordType.female: return Color.fromARGB(255, 255, 0, 0);
      case WordType.plural: return Color.fromARGB(255, 255, 204, 51);
      case WordType.neutral: return Color.fromARGB(0, 255, 0, 255);
      default: return Color.fromARGB(255, 255, 255, 255); // white
    }
  }
}

class WordCardUIState extends _AbstractWordCardUIState {
  WordCardUIState(card) : super(card);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      alignment: FractionalOffset.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DeutscheTTSText(
            _card.word,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }

  @override
  FlashCardUIState flip() => WordAnswerUIState(_card);
}

class WordAnswerUIState extends _AbstractWordCardUIState {

  WordAnswerUIState(card) : super(card);

  @override
  Widget build(BuildContext ctx) {
    print(_card.toString());
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              _card.value,
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
        ),
        Visibility(
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                      child: Text("Related", style: TextStyle(fontSize: 25.0)),
                      padding: EdgeInsets.all(15.0)
                  ),
                  onTap: () {
                    displayRelated(ctx);
                  },)
              ],),
            visible: _card.relatedWords.isNotEmpty
        )
      ],
    );
  }

  @override
  FlashCardUIState flip() => WordCardUIState(_card);

  @override
  bool canMoveNext() => true;

  displayRelated(BuildContext context) {
    double fontSize = 25.0;
    showModalBottomSheet(context: context, builder: (BuildContext ctx) {
      return Padding(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _card.relatedWords.map((related) {
            return Row(
              children: <Widget>[
                Text(
                  relatedTypeName(related.type),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
                ),
                Spacer(),
                DeutscheTTSText(related.word, style: TextStyle(fontSize: fontSize))
              ],
            );
          }).toList(),
        ), padding: EdgeInsets.all(10.0),);
    });
  }
}