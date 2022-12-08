import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form',
      home: Scaffold(
        appBar: AppBar(
            //title: Text('Form'),
            ),
        body: Center(
            //child: ChangeForm('null',null),
            ),
      ),
    );
  }
}

class ChangeForm extends StatefulWidget {
  ChangeForm(this.message, this.callback);
  String message;

  final Function callback;

  @override
  _ChangeFormState createState() => _ChangeFormState(message, callback);
}

class _ChangeFormState extends State<ChangeForm> {
  _ChangeFormState(message, this.callback);
  String message = '';
  String _text = '';
  final Function callback;

  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: <Widget>[
            Text(
              "$_text",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500),
            ),
            new TextField(
              enabled: true,
              style: TextStyle(color: Colors.red),
              obscureText: false,
              maxLines: 1,
              maxLength: 12,
              //パスワード
              onChanged: _handleText,
              decoration: const InputDecoration(
                icon: Icon(Icons.library_music),
                hintText: 'Please input the name of artist',
                labelText: 'Artist name *',
              ),
              onSubmitted: (value) => {
                //spotify.dartに値を渡す
                message = _text,
                callback(),
                print('onsubmittedしたテキスト${message}')
              },
            ),
          ],
        ));
  }
}
