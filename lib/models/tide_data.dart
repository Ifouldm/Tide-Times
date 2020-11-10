class TideData {
  final DateTime lastFetched;
  final List<Extreme> extremes;
  final String units;

  Duration avgTimeBetweenTides = Duration(hours: 12);

  TideData({this.lastFetched, this.extremes, this.units = 'm'}) {
    extremes
        .removeWhere((extreme) => extreme.dateTime.isBefore(DateTime.now()));
  }

  Duration get timeUntilNextTide =>
      nextTide.dateTime.difference(DateTime.now());

  bool get tideIncoming => nextTide.state == TideState.HighTide;

  Extreme get nextTide => extremes.first;

  // returns a value between 0 and 1 based on where the tide currently is
  double get tideScaled {
    double ratio = timeUntilNextTide.inMinutes / avgTimeBetweenTides.inMinutes;
    ratio = ratio > 1 ? 1 : ratio;
    ratio = ratio < 0 ? 0 : ratio;
    // if the next tide is low invert the result
    if (tideIncoming) ratio = 1 - ratio;
    return ratio;
  }

  // Factory to parse data from Json to TideData objects
  factory TideData.fromJson(rawData) {
    // create list of extremes from json data
    List<dynamic> ext = rawData['extremes'];
    List<Extreme> extremes =
        ext.map((extreme) => Extreme.fromJson(extreme)).toList();
    // return tide data with embedded extremes
    return TideData(
      lastFetched: DateTime.parse(rawData['datetime']),
      extremes: extremes,
      units: rawData['unit'],
    );
  }

  @override
  String toString() {
    return 'TideData{lastFetched: $lastFetched, extremes: $extremes, units: $units}';
  }
}

class Extreme {
  final DateTime dateTime;
  final double height;
  final TideState state;

  Extreme({this.dateTime, this.height = 0, this.state = TideState.LowTide});

  // Factory to parse data from Json to Extreme objects
  factory Extreme.fromJson(rawData) {
    return Extreme(
        dateTime: DateTime.parse(rawData['datetime']).toLocal(),
        height: rawData['height'],
        state: rawData['state'] == 'HIGH TIDE'
            ? TideState.HighTide
            : TideState.LowTide);
  }

  @override
  String toString() {
    return 'Extreme{dateTime: $dateTime, height: $height, state: $state}';
  }
}

enum TideState { HighTide, LowTide }
