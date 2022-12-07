import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotify/spotify.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../key/apikey.dart';

String APIid = api_id;
String APIkey = api_key;

class SpotifyChart extends StatefulWidget {
//const SpotifyChart({Key? key}) : super(key: key);
  @override
  State<SpotifyChart> createState() => _SpotifyChartState();

  final String id = APIid;
  final String keySecret = APIkey;

  /*final String id = '4165b1eba92f4b719ae5d521185a203b';
  final String keySecret = 'eff32d955b304e8c8a425ea17708fba2';*/
}
/*
class key {
  static final id = '4165b1eba92f4b719ae5d521185a203b';
  static final key_secret = '4165b1eba92f4b719ae5d521185a203b';
}*/
//---link
//https://pub.dev/packages/syncfusion_flutter_charts

class _SpotifyChartState extends State<SpotifyChart> {
  late SpotifyApiCredentials credentials;
  late SpotifyApi spotify;

/*
  final credentials = SpotifyApiCredentials(key.id, key.key_secret);
  final spotify = SpotifyApi(credentials);
  final artist = await spotify.artists.get('0OdUWJ0sBjDrqHygGUXeCF');*/
  //const VisChart({Key? key}) : super(key: key);

  void initState() {
    super.initState();

    credentials = SpotifyApiCredentials(widget.id, widget.keySecret);
    spotify = SpotifyApi(credentials);

/*
    print(credentials);
    print('\nArtists:');
    var artists = await spotify.artists.list(['0OdUWJ0sBjDrqHygGUXeCF']);
    artists.forEach((x) => print(x.name));
    print('\nAlbum:');
    var album = await spotify.albums.get('2Hog1V8mdTWKhCYqI5paph');
    print(album.name);
    print('\nAlbum Tracks:');
    var tracks = await spotify.albums.getTracks(album.id!).all();
    tracks.forEach((track) {
      print(track.name);
    });*/
  }

  var sadf = 0;
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(children: [
        Expanded(
          flex: 5, // 割合.
          child: SizedBox(
            child: Column(children: [
              FloatingActionButton(onPressed: () async {
                final artist = spotify.artists.get('0OdUWJ0sBjDrqHygGUXeCF');
                print('\nAlbum:');
                var album = await spotify.albums.get('2Hog1V8mdTWKhCYqI5paph');
                print(album.name);
                print('\nAlbum Tracks:');
                var tracks = await spotify.albums.getTracks(album.id!).all();
                tracks.forEach((track) {
                  print(track.name);
                });
              }),
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Half yearly sales analysis'),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_SalesData, String>>[
                    LineSeries<_SalesData, String>(
                        dataSource: data,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: 'Sales',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ]),
            ]),
          ),
        ),
        Expanded(
          flex: 5, // 割合.
          child: Text('hello'),
        )
      ]),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
