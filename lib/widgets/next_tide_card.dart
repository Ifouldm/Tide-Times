import 'package:flutter/material.dart';
import 'package:tide_time/models/tide_data.dart';

import '../utils/helper_functions.dart';

class NextTideCard extends StatelessWidget {
  final TideData tideData;

  NextTideCard({@required this.tideData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20.0),
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            tideData.tideIncoming
                ? Icon(
                    Icons.arrow_upward,
                    color: Colors.red,
                    size: 30.0,
                  )
                : Icon(Icons.arrow_downward, color: Colors.blue),
            Text(
              Helper.nextTideText(tideData),
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
