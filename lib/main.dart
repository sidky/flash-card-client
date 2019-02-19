import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/flash_card_dao.dart';
import 'package:flash_card/widget/flash_card_widget.dart';
import 'app_config.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(name: 'flashcard',
      options: const FirebaseOptions(
        googleAppID: googleAppID,
        apiKey: apiKey,
        databaseURL: databaseURL
      ));
  runApp(MyApp(FlashCardDAO(app)));
}

class MyApp extends StatelessWidget {

  final FlashCardDAO dao;

  MyApp(this.dao);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

//    dao.randomFlashCard().then((card) {
//      print(card.word);
//    });

    return MaterialApp(
      title: 'Flash Card',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Flash Card')),
        body: FlashCardWidget(dao),
      ),
    );
  }
}