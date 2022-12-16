import 'dart:js_util';

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

  //折線に縦にdanceability, 横に曲名を格納
  List<_LineData> chartData = [];

//floating buttonが押された
  List<List<dynamic>> _data = [];
  List<List<dynamic>> _linedata = [];
  List<List<dynamic>> csvData = []; //song name
  List<List<dynamic>> danceData = []; //danceabiligy
  List<List<dynamic>> allData = [];
  List<List<dynamic>> yearData = [];

  //popularity
  final popularity = [];
  final track_list = [];

  //Read CSV
  Future<List> processCsv(filename) async {
    var result = await DefaultAssetBundle.of(context).loadString(
      filename,
    );
    return const CsvToListConverter().convert(result, eol: "\n");
  }

  //Return CSVdata
  Future<void> Processed_csv() async {
    csvData = await processCsv("twice_name.csv") as List<List>;
    danceData = await processCsv("twice_spotify_pop.csv") as List<List>;
    allData = await processCsv("twice_release_year.csv") as List<List>;
    yearData = await processCsv("twice_year.csv") as List<List>;
    danceData.isEmpty ? null : Add_list();
    print('${danceData[4][1]}, ${csvData[4][1]}, ${yearData[1][1]}');
    setState(() {});
  }

  //Add Data to Each Chart
  void Add_list() {
    for (var i = 1; i < danceData.length; i++)
      chartData.add(_LineData(allData[i][15], danceData[i][1]));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Processed_csv();
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
                  title: ChartTitle(text: 'Dannceability per year'),
                  series: <ChartSeries>[
                    ScatterSeries<_LineData, num>(
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
  final num year;
  final double sales;
}
