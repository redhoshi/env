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
  List<_LineData> lineData = [];
  List<ChartData> chartData = [];

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
    print(
        '${danceData[4][1]}, ${csvData[4][1]}, ${yearData[1][1]}, all:,${allData[0][3]},${allData[0][4]},,${allData[0][6]},${allData[0][7]}');
    setState(() {});
  }

  //Add Data to Each Chart
  void Add_list() {
    for (var i = 1; i < danceData.length; i++)
      lineData.add(_LineData(allData[i][15], danceData[i][1]));
    for (var i = 1; i < danceData.length; i++)
      chartData.add(ChartData(allData[i][15], allData[i][3], allData[i][4],
          allData[i][6], allData[i][7]));
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
                  legend: Legend(
                    isVisible: true,
                    // Legend title
                    title: LegendTitle(
                        text: 'Features',
                        textStyle: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w900)),
                  ),
                  series: <ChartSeries>[
                    StackedColumn100Series<ChartData, num>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        name: 'danceability'),
                    StackedColumn100Series<ChartData, num>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y2,
                        name: 'energy'),
                    StackedColumn100Series<ChartData, num>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y3,
                        name: 'speechiness'),
                    StackedColumn100Series<ChartData, num>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y4,
                        name: 'acousticness')
                  ]),
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Danceability per year'),
                  series: <ChartSeries>[
                    ScatterSeries<_LineData, num>(
                        dataSource: lineData,
                        xValueMapper: (_LineData lineData, _) => lineData.year,
                        yValueMapper: (_LineData lineData, _) => lineData.sales,
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

class ChartData {
  ChartData(this.x, this.y, this.y2, this.y3, this.y4);
  final num x;
  final double y;
  final double y2;
  final double y3;
  final double y4;
}
