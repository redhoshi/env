import 'dart:async';
import 'data.dart';

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

  //折線に縦にdanceability, 横に曲名を格納
  List<_LineData> lineData = [];
  List<ChartData> chartData = [];
  //List<TempoData> tempoData = [];

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
  final tempo = [];
  final relaseChannel = StreamController<GestureSignal>.broadcast();

  final heatmapChannel = StreamController<Selected?>.broadcast();

  //Read CSV

  Future<List> processCsv(filename) async {
    var result = await DefaultAssetBundle.of(context).loadString(
      filename,
    );
    return const CsvToListConverter().convert(result, eol: "\n");
  }

  //Return CSVdata
  Future<void> Processed_csv() async {
    // csvData = await processCsv("twice_name.csv") as List<List>;
    // danceData = await processCsv("twice_spotify_pop.csv") as List<List>;
    allData = await processCsv("assets/twice_release_year3.csv") as List<List>;
    // yearData = await processCsv("twice_year.csv") as List<List>;
    allData.isEmpty ? null : Add_list();
    /* print(
        '${danceData[4][1]}, ${csvData[4][1]}, ${yearData[1][1]}, all:,${allData[1][4]},${allData[1][16]},,${allData[1][11]},${allData[0][7]}');*/
    setState(() {});
  }

  //Add Data to Each Chart
  void Add_list() {
    /*
    for (var i = 1; i < danceData.length; i++)
      lineData.add(_LineData(allData[i][15], danceData[i][1]));
    for (var i = 1; i < danceData.length; i++)
      tempo.addAll([
        [allData[i][4], allData[i][16], allData[i][1]]
      ]);*/
    for (var i = 1; i < allData.length; i++)
      chartData.add(ChartData(allData[i][15], allData[i][3], allData[i][4],
          allData[i][6], allData[i][7]));
    print('tempo::$chartData');
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
              Text('Band chart'),
              new SizedBox(
                width: 400,
                height: 400,
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.top,
                      title: LegendTitle(),
                    ),
                    series: <ChartSeries>[
                      StackedColumn100Series<ChartData, num>(
                          dataSource: chartData, //
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
              ),
              Text('Band and Bar chart'),
              new SizedBox(
                width: 400,
                height: 160,
                child: Chart(
                  padding: (_) => const EdgeInsets.fromLTRB(40, 5, 10, 0),
                  rebuild: false,
                  data: release_pop,
                  variables: {
                    'time': Variable(
                      accessor: (List datum) => datum[6].toString(),
                      scale: OrdinalScale(tickCount: 3),
                    ),
                    'end': Variable(
                      accessor: (List datum) => datum[3] as num,
                      scale: LinearScale(min: 5, tickCount: 5),
                    ),
                  },
                  elements: [
                    LineElement(
                      size: SizeAttr(value: 1),
                    )
                  ],
                  axes: [
                    Defaults.horizontalAxis
                      ..label = null
                      ..line = null,
                    Defaults.verticalAxis
                      ..gridMapper = (_, index, __) =>
                          index == 0 ? null : Defaults.strokeStyle,
                  ],
                  selections: {
                    'touchMove': PointSelection(
                      on: {
                        GestureType.scaleUpdate,
                        GestureType.tapDown,
                        GestureType.longPressMoveUpdate
                      },
                      dim: Dim.x,
                    )
                  },
                  crosshair: CrosshairGuide(
                    followPointer: [true, false],
                    styles: [
                      StrokeStyle(color: const Color(0xffbfbfbf), dash: [4, 2]),
                      StrokeStyle(color: const Color(0xffbfbfbf), dash: [4, 2]),
                    ],
                  ),
                  gestureChannel: relaseChannel,
                ),
              ),
              new SizedBox(
                width: 400,
                height: 160,
                child: Chart(
                  padding: (_) => const EdgeInsets.fromLTRB(40, 0, 10, 20),
                  rebuild: false,
                  data: release_pop,
                  variables: {
                    'time': Variable(
                      accessor: (List datum) => datum[6].toString(), //一定
                      scale: OrdinalScale(tickCount: 3),
                    ),
                    'volume': Variable(
                      accessor: (List datum) => datum[0] as num, //一定
                    ),
                  },
                  elements: [
                    IntervalElement(
                      size: SizeAttr(value: 1),
                    )
                  ],
                  axes: [
                    Defaults.horizontalAxis,
                  ],
                  selections: {
                    'touchMove': PointSelection(
                      on: {
                        GestureType.scaleUpdate,
                        GestureType.tapDown,
                        GestureType.longPressMoveUpdate
                      },
                      dim: Dim.x,
                    )
                  },
                  crosshair: CrosshairGuide(
                    followPointer: [true, false],
                    styles: [
                      StrokeStyle(color: const Color(0xffbfbfbf), dash: [4, 2]),
                      StrokeStyle(color: const Color(0xffbfbfbf), dash: [4, 2]),
                    ],
                  ),
                  gestureChannel: relaseChannel,
                ),
              ),
              /* SfCartesianChart(
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
                  ]),*/
            ]),
          ),
        ),
        Expanded(
          flex: 5, // 割合.
          child: new SizedBox(
              child: Column(
            children: [
              new SizedBox(
                height: 40,
              ),
              Text('Scatter chart'),
              new SizedBox(
                width: 400,
                height: 360,
                child: Chart(
                  data: test_data, //popuData,scatterData
                  variables: {
                    '0': Variable(
                      accessor: (List datum) => datum[1] as num, //liveness
                    ),
                    '1': Variable(
                      accessor: (List datum) => datum[2] as num, //acousticness
                    ),
                    '2': Variable(
                      accessor: (List datum) => datum[0] as num, //popularity
                    ),
                    '4': Variable(
                      accessor: (List datum) => datum[3].toString(),
                    ),
                  },
                  elements: [
                    PointElement(
                      size: SizeAttr(variable: '2', values: [5, 20]),
                      color: ColorAttr(
                        variable: '4',
                        values: Defaults.colors10,
                        updaters: {
                          'choose': {true: (_) => Colors.red}
                        },
                      ),
                      shape: ShapeAttr(variable: '4', values: [
                        CircleShape(hollow: true),
                        SquareShape(hollow: true),
                      ]),
                    )
                  ],
                  axes: [
                    Defaults.horizontalAxis,
                    Defaults.verticalAxis,
                  ],
                  coord: RectCoord(
                    horizontalRange: [0.05, 0.95],
                    verticalRange: [0.05, 0.95],
                    horizontalRangeUpdater: Defaults.horizontalRangeSignal,
                    verticalRangeUpdater: Defaults.verticalRangeSignal,
                  ),
                  selections: {'choose': PointSelection(toggle: true)},
                  tooltip: TooltipGuide(
                    anchor: (_) => Offset.zero,
                    align: Alignment.bottomRight,
                    multiTuples: true,
                  ),
                ),
              ),
              Text('Circular heatmap'),
              new SizedBox(
                width: 400,
                height: 400,
                child: Chart(
                  data: heatmapData, //tempoData(llist諸々),tempo(finalのlist)
                  variables: {
                    'key': Variable(
                      accessor: (List datum) => datum[1].toString(),
                    ),
                    'song name':
                        Variable(accessor: (List datum) => datum[3].toString()),
                    'popularity': Variable(
                      accessor: (List datum) => datum[0] as num,
                    ),
                  },
                  elements: [
                    PolygonElement(
                      shape: ShapeAttr(value: HeatmapShape(sector: true)),
                      color: ColorAttr(
                        variable: 'popularity',
                        values: [
                          const Color(0xffbae7ff),
                          const Color(0xff1890ff),
                          const Color(0xff0050b3)
                        ],
                        updaters: {
                          'tap': {false: (color) => color.withAlpha(70)}
                        },
                      ),
                      selectionChannel: heatmapChannel,
                    )
                  ],
                  coord: PolarCoord(),
                  selections: {'tap': PointSelection()},
                  tooltip: TooltipGuide(
                    anchor: (_) => Offset.zero,
                    align: Alignment.bottomRight,
                  ),
                ),
              ),
            ],
          )),
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
