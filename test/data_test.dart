import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tide_time/models/tide_data.dart';
import 'package:tide_time/utils/data_collector.dart';

void main() {
  testWidgets('Data tests', (WidgetTester tester) async {
    DataCollector dc = DataCollector();
    var data = await dc.readData();
    TideData td = TideData.fromJson(data);

    // Verify that our counter starts at 0.
    expect(td, !null);
    expect(td.units, 'm');
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
