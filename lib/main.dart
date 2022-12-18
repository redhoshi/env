import 'dart:convert';
import 'dart:html';

import 'package:env/pages/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'box_folder.dart';
import 'spotify.dart';
import 'title.dart';
import 'pages/vis_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: Stack(children: [
          //screenSize.width > 768 ? const CommonDrawer() : Container(),
          SingleChildScrollView(
              child: Stack(children: [
            Container(
              color: Colors.indigo,
              height: screenSize.height * 0.07,
              width: screenSize.width,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    SizedBox(
                      width: screenSize.width / 10,
                    ),
                    Icon(Icons.edgesensor_high_rounded,
                        color: Colors.white, size: 20),
                    SizedBox(
                      width: screenSize.width / 100,
                    ),
                    Text("Visualization",
                        style: TextStyle(color: Colors.white)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {},
                            onHover: (value) {
                              setState(() {});
                            },
                            child: Text(
                              '',
                              style: TextStyle(),
                            ),
                          ),
                          SizedBox(width: screenSize.width / 20),
                          InkWell(
                            onTap: () {},
                            onHover: (value) {
                              setState(() {});
                            },
                            child: Text(
                              '',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenSize.height / 10,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: screenSize.height * 0.08, //0.25
                    left: screenSize.width * 0.05),
                child: Column(children: [
                  //BoxFolder(),
                  //Titler(),
                  VisChart(),
                  //SpotifyChart(),
                ])),
          ]))
        ]),
      ),
      body: Center(),
    );
  }
}
