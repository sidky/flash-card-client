import 'package:flash_card/data/tts_helper.dart';
import 'package:flutter/material.dart';

class DeutscheTTS extends StatelessWidget {
  final String _sentence;

  final TTSHelper _tts;

  final double iconSize;

  DeutscheTTS(this._sentence, {this.iconSize = 24.0}) : _tts = TTSHelper();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize,
      padding: EdgeInsets.all(5.0),
      icon: Icon(Icons.speaker),
      onPressed: () {
        _tts.speak(_sentence);
      },

    );

  }

}