import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:tide_time/models/tide_data.dart';

class Helper {
  static String formatDate(DateTime datetime) =>
      DateFormat('HH:mm - dd/MM/yy').format(datetime);

  static String nextTideText(TideData tideData) {
    return 'Next ' +
        (tideData.tideIncoming ? 'High' : 'Low') +
        ' Tide: ' +
        (tideData.timeUntilNextTide.inHours > 0
            ? tideData.timeUntilNextTide.inHours.toString() + 'hrs '
            : '') +
        (tideData.timeUntilNextTide.inMinutes % 60).toString() +
        'mins';
  }

  // returns height at which the waves should be displayed based on screensize
  static int waveHeight(Size size, double scale) =>
      ((1 - scale) * (size.height - 150)).floor();
}
