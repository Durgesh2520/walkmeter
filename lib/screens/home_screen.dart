import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walkmeter_app/screens/login_screen.dart';
import 'package:fit_kit/fit_kit.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _list = [];
  static bool needToShowAllData = false;
  bool dayToday = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text("Walkmater"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: (){
            FirebaseAuth.instance.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen() ));
            });
          }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification:(overscroll) {
                overscroll.disallowGlow();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Welcome to the Walkmeter Tracker',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Need to display full data'),
                        Checkbox(
                            value: needToShowAllData,
                            onChanged: (value) {
                              setState(() {
                                needToShowAllData = value;

                                _list.clear();
                              });
                              readData();
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            onPressed: () async {
                              setState(() {
                                _list.clear();
                                dayToday = false;
                              });

                              readData();
                            },
                            child: Text(
                              'Click Me For yesterday\'s Data.',
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: () async {
                              setState(() {
                                _list.clear();
                                dayToday = true;
                              });

                              readData();
                            },
                            child: Text(
                              'Click Me For Today\'s Data.',
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_list.length > 0) ..._list
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> readPermissions() async {
    try {
      final responses = await FitKit.hasPermissions([

        DataType.STEP_COUNT,
        DataType.DISTANCE,
        DataType.STAND_TIME,
        DataType.EXERCISE_TIME,

      ]);

      if (!responses) {
        final value = await FitKit.requestPermissions([

          DataType.STEP_COUNT,
          DataType.DISTANCE,
          DataType.STAND_TIME,
          DataType.EXERCISE_TIME,

        ]);

        return value;
      } else {
        return true;
      }
    } on UnsupportedException catch (e) {
      // thrown in case e.dataType is unsupported
      print(e);
      return false;
    }
  }

  void readData() async {
    bool permissionsGiven = await readPermissions();

    if (permissionsGiven) {
      DateTime current = DateTime.now();
      DateTime dateFrom;
      DateTime dateTo;
      if (!dayToday) {
        dateFrom = DateTime.now().subtract(Duration(
          hours: current.hour + 24,
          minutes: current.minute,
          seconds: current.second,
        ));
        dateTo = dateFrom.add(Duration(
          hours: 23,
          minutes: 59,
          seconds: 59,
        ));
      } else {
        dateFrom = current.subtract(Duration(
          hours: current.hour,
          minutes: current.minute,
          seconds: current.second,
        ));
        dateTo = DateTime.now();
      }

      for (DataType type in DataType.values) {
        try {
          final results = await FitKit.read(
            type,
            dateFrom: dateFrom,
            dateTo: dateTo,
          );

          print(type);
          print(results);
          addWidget(type, results);
        } on Exception catch (ex) {
          print(ex);
        }
      }
    }
  }

  void addWidget(DataType type, List<FitData> data) {
    if (type == DataType.STEP_COUNT) {
      int total = 0;
      for (FitData datasw in data) {
        total += datasw.value;
      }
      print("-------------------------- $total");
    }
    Widget widget = Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$type'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (data.length > 0)
                  ? Column(
                children: map(
                    list: data,
                    handler: (index, FitData datas) {
                      return Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  '${DateFormat("dd-MM HH:mm").format(datas.dateFrom).toString()}',
                                  softWrap: true,
                                ),
                              ),
                              Text('to'),
                              Expanded(
                                child: Text(
                                  '${DateFormat("dd-MM HH:mm").format(datas.dateTo).toString()}',
                                  softWrap: true,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${datas.value is double ? datas.value.toStringAsFixed(1) : datas.value} ${getBaseUnit(type)}',
                                  softWrap: true,
                                ),
                              )
                            ]),
                      );
                    }),
              )
                  : Text(' No Data Available'),
            ),
          ],
        ));

    setState(() {
      _list.add(widget);
    });
  }

  static List<T> map<T>({@required List list, @required Function handler}) {
    List<T> result = [];

    int lengthToDisplay =
    list.length > 5 && !needToShowAllData ? 5 : list.length;

    if (list.length > 0) {
      for (var i = 0; i < lengthToDisplay; i++) {
        result.add(handler(i, list[i]));
      }
    }

    return result;
  }

  static String getBaseUnit(DataType type) {
    switch (type) {
      case DataType.STEP_COUNT:
        return 'count';
      case DataType.DISTANCE:
        return 'meter';
      default:
        return 'UnKnown';
    }
  }
}
