import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tide_time/utils/data_collector.dart';
import 'package:tide_time/utils/helper_functions.dart';
import 'package:tide_time/widgets/tide_card.dart';

import 'models/tide_data.dart';
import 'widgets/header_cards.dart';
import 'widgets/next_tide_card.dart';
import 'widgets/waves.dart';

// void main() {
//   runApp(MyApp());
// }

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tide Information',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Bognor Regis Tide Times'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DataCollector _dataCollector = DataCollector();
  TideData _tideData;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    _dataCollector.readData().then((rawData) {
      setState(() {
        _tideData = TideData.fromJson(rawData);
      });
    });
  }

  void forceFetch() {
    _dataCollector.forceFetch().then((rawData) {
      setState(() {
        _tideData = TideData.fromJson(rawData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int waveHeight =
        Helper.waveHeight(size, _tideData == null ? 0.5 : _tideData.tideScaled);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.title),
            IconButton(
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              onPressed: () => showAboutDialog(
                context: context,
                applicationName: "Bognor Tide Times",
                applicationVersion: '1.0.0',
                applicationIcon: Icon(Icons.info_outline),
                children: [
                  Text('By Matthew Ifould'),
                  Text('Dedicated to my wonderful parents')
                ],
              ),
            ),
            GestureDetector(
              onLongPress: forceFetch,
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: refreshData,
              ),
            )
          ],
        ),
      ),
      body: _tideData == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                WaveBody(
                  size: size,
                  color: Colors.lightBlue.shade100,
                  yOffset: waveHeight,
                ),
                WaveBody(
                  size: size,
                  color: Colors.lightBlueAccent.shade100,
                  xOffset: 100,
                  yOffset: waveHeight,
                ),
                Column(
                  children: <Widget>[
                    HeaderCards(tideData: _tideData),
                    Expanded(
                      child: ListView.builder(
                          itemCount: _tideData.extremes.length,
                          itemBuilder: (context, index) {
                            Extreme current = _tideData.extremes[index];
                            DateTime localTime = current.dateTime;
                            return TideCard(
                                index: index,
                                localTime: localTime,
                                current: current);
                          }),
                    ),
                    NextTideCard(tideData: _tideData),
                  ],
                ),
              ],
            ),
    );
  }
}
