import 'package:flutter/material.dart';

class BoxFolder extends StatelessWidget {
  const BoxFolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          for (var i = 0; i < 4; i++)
            SizedBox(
              width: 300,
              height: 100,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: Column(children: [
                  Text('hello'),
                ]),
              ),
            ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
