import 'package:flutter/material.dart';

import '../utils/helper_functions.dart';

class HeaderCards extends StatelessWidget {
  final tideData;
  HeaderCards({@required this.tideData});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 5.0,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Current time: ' + Helper.formatDate(DateTime.now()),
            ),
          ),
        ),
        // Card(
        //   elevation: 5.0,
        //   child: Padding(
        //     padding: const EdgeInsets.all(20.0),
        //     child: Text(
        //       'Last Refresh: ' + Helper.formatDate(tideData.lastFetched),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
