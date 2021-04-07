import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flcharts/sensordata.g.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charts Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage();
          }
          return Scaffold(
            body: Container(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('messages').orderBy('timeStamp').limitToLast(60).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List<Sensordata> sensorData = <Sensordata>[];

                snapshot.data.docs.forEach((element) {
                  sensorData.add(Sensordata.fromJson(element.data()));
                });
                return Container(
                  child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(dateFormat: DateFormat.Hms()),
                    series: <ChartSeries>[
                      LineSeries<Sensordata, dynamic>(
                        dataSource: sensorData,
                        xValueMapper: (Sensordata data, _) => data.timeStamp,
                        yValueMapper: (Sensordata data, _) => data.memUsage,
                      ),
                      LineSeries<Sensordata, dynamic>(
                        dataSource: sensorData,
                        xValueMapper: (Sensordata data, _) => data.timeStamp,
                        yValueMapper: (Sensordata data, _) => data.memTotal,
                      ),
                    ],
                  ),
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final String year;
  final double sales;

  ChartData(this.year, this.sales);
}
