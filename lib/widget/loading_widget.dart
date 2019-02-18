import 'package:flash_card/widget/ui_state.dart';
import 'package:flutter/material.dart';

class LoadingUIState extends FlashCardUIState {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }

  @override
  FlashCardUIState flip() => this;

  @override
  bool canMoveNext() => false;

  @override
  Color cardColor() => Color.fromRGBO(255, 255, 255, 1.0);
}

