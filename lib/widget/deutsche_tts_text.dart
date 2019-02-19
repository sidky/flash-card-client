import 'package:flash_card/widget/deutsch_tts.dart';
import 'package:flutter/material.dart';

class DeutscheTTSText extends StatelessWidget {

  final String text;
  final TextStyle style;
  final String speech;
  final double iconSize;

  DeutscheTTSText(this.text, {this.style, this.speech, this.iconSize = 24.0});

  @override
  Widget build(BuildContext context) {
    var textToSpeak = this.speech != null ? this.speech : this.text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(text, style: style, maxLines: 5, overflow: TextOverflow.fade,),
        DeutscheTTS(textToSpeak, iconSize: this.iconSize,),
      ],
    );
  }

}