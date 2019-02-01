import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'data/flash_card_dao.dart';
import 'data/card.dart';

class FlashCardWidget extends StatefulWidget {

  FlashCardDAO _dao;

  FlashCardWidget(this._dao, {Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _FlashCardState(_dao); // _FlashCardStateImpl();
}

class _FlashCardState extends State<FlashCardWidget> {
  FlashCardDAO _dao;

  _FlashCardState(this._dao) {
    _uiState = _LoadingUIState();
  }

  @override
  void initState() {
    next();
  }

  _FlashCardUIState _uiState;

  void update(_FlashCardUIState newState) {
    setState(() {
      _uiState = newState;
    });
  }

  void next() {
    update(_LoadingUIState());
    _dao.randomFlashCard().then((card) {
      update(_CardUIState(card));
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

abstract class _FlashCardUIState {
  _FlashCardUIState flip();
  bool canMoveNext();
  Widget build(BuildContext ctx);
  Color cardColor();
}

class _LoadingUIState extends _FlashCardUIState {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }

  @override
  _FlashCardUIState flip() => this;

  @override
  bool canMoveNext() => false;

  @override
  Color cardColor() => Color.fromRGBO(255, 255, 255, 1.0);
}

abstract class _AbstractWordCardUIState extends _FlashCardUIState {
  WordCard _card;

  _AbstractWordCardUIState(this._card);

  @override
  bool canMoveNext() => true;



  @override
  Color cardColor() {
    switch (_card.wordType) {
      case WordType.male: return Color.fromARGB(255, 0, 0, 255); // blue
      case WordType.female: return Color.fromARGB(255, 255, 0, 0);
      case WordType.plural: return Color.fromARGB(255, 255, 204, 51);
      case WordType.neutral: return Color.fromARGB(0, 255, 0, 255);
      default: return Color.fromARGB(255, 255, 255, 255); // white
    }
  }
}

class _CardUIState extends _AbstractWordCardUIState {
  _CardUIState(card) : super(card);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      alignment: FractionalOffset.center,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _card.word,
            style: TextStyle(
              fontSize: 40,
            ),
          )
        ],
      ),
    );
  }

  @override
  _FlashCardUIState flip() => _AnswerUIState(_card);
}

class _AnswerUIState extends _AbstractWordCardUIState {

  _AnswerUIState(card) : super(card);

  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Text(
        _card.value,
        style: TextStyle(
          fontSize: 40,
        ),
      ),
    );
  }

  @override
  _FlashCardUIState flip() => _CardUIState(_card);

  @override
  bool canMoveNext() => true;
}