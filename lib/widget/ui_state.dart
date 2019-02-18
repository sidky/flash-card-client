import 'package:flutter/material.dart';

abstract class FlashCardUIState {
  FlashCardUIState flip();
  bool canMoveNext();
  Widget build(BuildContext ctx);
  Color cardColor();
}

