import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphic/graphic.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class VisChart extends StatefulWidget {
  const VisChart({Key? key}) : super(key: key);
  @override
  State<VisChart> createState() => _VisChartState();
}

//---link
//https://pub.dev/packages/syncfusion_flutter_charts

class _VisChartState extends State<VisChart> {
  //const VisChart({Key? key}) : super(key: key);
  var sadf = 0;
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];
  // List<_LineData> chartData = [];

  List<_LineData> chartData = [
    _LineData('2010', 5),
    _LineData('2011', 28),
    _LineData('2012', 34),
    _LineData('2013', 32),
    _LineData('2014', 40)
  ];

  //List<_LineData> chartData = <_LineData>[];
//floating buttonが押された
  List<List<dynamic>> _data = [];
  List<List<dynamic>> _linedata = [];
  List<List<dynamic>> csvData = []; //song name
  List<List<dynamic>> danceData = []; //danceabiligy

  //popularity
  final popularity = [];
  final track_list = [];

  Future<List<List<dynamic>>> processCsv(filename) async {
    var result = await DefaultAssetBundle.of(context).loadString(
      filename,
    );
    return const CsvToListConverter().convert(result, eol: "\n");
  }

/* うまくグラフに追加できない */
  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("/twice_spotify_pop.csv");
    final _popData = await rootBundle.loadString("/twice_spotify_pop.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData);
    List<List<dynamic>> _poplistData =
        const CsvToListConverter().convert(_popData);
    // print('${_listData[0]}');
    // print('${_listData[0][2]}');
    for (var i = 0; i < _listData.length; i++) {
      track_list.add(_listData[0][i]);
      popularity.add(_poplistData[0][i]);
    }
    for (int i = 0; i < _listData.length; i++) {
      chartData.add(_LineData(_listData[0][i], _poplistData[0][0]));
    }
    setState(() {
      // _data = _listData;
      // _linedata = _poplistData;
    });
  }

  Future<void> Processed_csv() async {
    csvData = await processCsv("twice_name.csv") as List<List>;
    danceData = await processCsv("twice_spotify_pop.csv") as List<List>;
    print(csvData[3][1]);
    print(danceData[3][1]);
    setState(() {});
    Add_list();
  }

  void Add_list() {
    for (var i = 0; i < 2; i++)
      chartData.add(_LineData('2015', danceData[i][1]));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Processed_csv();
    // _loadCSV(); //機能しない
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(children: [
        Expanded(
          flex: 5, // 割合.
          child: SizedBox(
            child: Column(children: [
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Half yearly sales'),
                  series: <ChartSeries<_LineData, String>>[
                    LineSeries<_LineData, String>(
                        dataSource: chartData,
                        xValueMapper: (_LineData chartData, _) =>
                            chartData.year,
                        yValueMapper: (_LineData chartData, _) =>
                            chartData.sales,
                        name: 'Sales',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ]),
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
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
              FloatingActionButton(onPressed: () {
                print(csvData[1][1]);
                //  _loadCSV();
              })
            ]),
          ),
        ),
        Expanded(
          flex: 5, // 割合.
          child: Text('hello'),
        ),
      ]),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _LineData {
  _LineData(this.year, this.sales);
  final String year;
  final double sales;
}
