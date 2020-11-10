import 'package:flutter/material.dart';

import '../models/tide_data.dart';
import '../utils/helper_functions.dart';

class TideCard extends StatelessWidget {
  final int index;
  final DateTime localTime;
  final Extreme current;

  TideCard({this.index, this.localTime, this.current});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white.withOpacity(0.9)),
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(child: Text((index + 1).toString())),
        title: Text(
          'Tide: ' + Helper.formatDate(localTime),
          style: TextStyle(
              color: current.state == TideState.HighTide
                  ? Colors.red
                  : Colors.blue),
        ),
        subtitle:
            Text("Tide Height = ${current.height?.toStringAsPrecision(2)}m"),
        trailing: Text(
          current.state == TideState.HighTide ? "High Tide" : "Low Tide",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: current.state == TideState.HighTide
                  ? Colors.red
                  : Colors.blue),
        ),
      ),
    );
  }
}
