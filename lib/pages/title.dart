import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Titler extends StatelessWidget {
  const Titler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(children: [
        Expanded(
          flex: 5, // 割合.
          child: SizedBox(
            child: Column(children: [
              Text(
                'Visualized Spotify API',
                style: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text('This is a visualization class project.'),
              SizedBox(
                height: 40,
              ),
              FloatingActionButton.extended(
                tooltip: 'Press this button!',
                icon: Icon(Icons.add), //アイコンは無しでもOK
                label: Text('Add'),
                backgroundColor: Colors.indigo,
                onPressed: () {},
              ),
            ]),
          ),
        ),
        Expanded(
          flex: 5, // 割合.
          child: Text('hello'),
        )
        /*
        SizedBox(
          child: Text('HI'),
        ),
        SizedBox(
          child: Text('HI'),
        ),*/
      ]),
    );
  }
}
