import 'dart:ui';

import 'package:flash_card/data/card.dart';
import 'package:flash_card/widget/deutsche_tts_text.dart';
import 'package:flash_card/widget/ui_state.dart';
import 'package:flutter/material.dart';

abstract class _AbstractVerbCardUIState extends FlashCardUIState {
  @override
  bool canMoveNext() => true;

  @override
  Color cardColor() => Color.fromARGB(255, 244, 137, 66);
}

class VerbCardUIState extends _AbstractVerbCardUIState {

  final VerbFormCard _card;
  final String _pronoun;

  VerbCardUIState(this._card, this._pronoun);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      alignment: FractionalOffset.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DeutscheTTSText(
            _card.word,
            style: TextStyle(fontSize: 40),
          ),
          Text(
            _question,
            style: TextStyle(fontSize: 40),
          )
        ],
      ),
    );
  }

  @override
  FlashCardUIState flip() => VerbCardAnswerUIState(_card, _pronoun);

  String get _question => '$_pronoun ________';
}

class VerbCardAnswerUIState extends _AbstractVerbCardUIState {

  final VerbFormCard _card;
  final String _pronoun;

  VerbCardAnswerUIState(this._card, this._pronoun);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Center(
            child: DeutscheTTSText(
              _answer,
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
        Visibility(
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Padding(
                    child: Text("Others", style: TextStyle(fontSize: 25.0)),
                    padding: EdgeInsets.all(15.0)),
                onTap: () {
                  displayOthers(ctx);
                },
              )
            ],
          ),
          visible: _card.forms.isNotEmpty,
        )
      ],
    );
  }

  @override
  FlashCardUIState flip() => VerbCardUIState(_card, _pronoun);

  String get _answer => '$_pronoun ${_card.forms[_pronoun]}';

  void displayOthers(BuildContext context) {
    double fontSize = 15.0;
    List<Widget> forms = List();
    _card.forms.forEach((key, value) {
      forms.add(
        Row(
          children: <Widget>[
            Text(key, style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
            Padding(padding: EdgeInsets.all(2.0),),
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: DeutscheTTSText(value, style: TextStyle(fontSize: fontSize), speech: '${_keyToSpeak(key)} $value', iconSize: 10.0,),
            )

          ]
        )
      );
    });

    var pronouns = _card.forms.keys.toList();

    var builder = ListView.builder(itemCount: pronouns.length, itemBuilder: (BuildContext ctx, int index) {
      var key = pronouns[index];
      var value = _card.forms[key];
      return Row(
          children: <Widget>[
            Text(key, style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
            Padding(padding: EdgeInsets.all(2.0),),
            DeutscheTTSText(value, style: TextStyle(fontSize: fontSize), speech: '${_keyToSpeak(key)} $value', iconSize: fontSize,),
          ]
      );
    });

    showModalBottomSheet(context: context, builder: (BuildContext ctx) {
      return builder.build(context);
    });
  }

  String _keyToSpeak(String key) => key == "sie_plural" ? "sie" : key;
}