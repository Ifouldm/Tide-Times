import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

class DataCollector {
  final Logger log = Logger(printer: PrettyPrinter());
  DateTime lastFetched;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tide_data.json');
  }

  Future<dynamic> readData() async {
    final file = await _localFile;
    Map<String, dynamic> jsonData;

    // If no data file exists, fetch remote data and write to file
    if (await file.exists() == false) {
      log.i("No File, Fetching remote");
      try {
        String rawData = await _fetchRemoteData();
        writeData(rawData);
        jsonData = jsonDecode(rawData);
      } catch (e) {
        log.e("Error decoding remote json " + e.toString());
        return null;
      }
    }
    // Else get data from file
    else {
      log.i("File Present Accessing file");
      try {
        jsonData = jsonDecode(await file.readAsString());
      } catch (e) {
        log.e("Error decoding local json " + e.toString());
        file.delete(); // remove local file if corrupt / unusable
        return null;
      }
      // if the data is more than 1 day old
      DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
      if (DateTime.parse(jsonData['datetime']).isBefore(yesterday)) {
        log.i("Data old fecthing new");
        try {
          String rawData = await _fetchRemoteData();
          jsonData = jsonDecode(rawData);
          if (jsonData != null) writeData(rawData);
          lastFetched = DateTime.now();
        } catch (e) {
          log.e("Error updating local data " + e.toString());
        }
      }
    }
    return jsonData;
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  Future<String> _fetchRemoteData() async {
    Map<String, String> header = {
      "x-rapidapi-host": "tides.p.rapidapi.com",
      "x-rapidapi-key": kAPIKey
    };
    try {
      var response = await http.get(kURL + kOptions, headers: header);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        log.e("Error fetching remote data, server returned " +
            response.statusCode.toString());
        return null;
      }
    } catch (e) {
      log.e('Error fetching remote data ' + e.toString());
      return null;
    }
  }

  Future<String> _fetchRemoteDataDummy() async {
    return rootBundle.loadString('assets/tide_data.json');
  }

  Future<dynamic> forceFetch() async {
    Map<String, dynamic> jsonData;
    try {
      String rawData = await _fetchRemoteData();
      jsonData = jsonDecode(rawData);
      if (jsonData != null) writeData(rawData);
      lastFetched = DateTime.now();
    } catch (e) {
      log.e("Error updating local data (forceFetch) " + e.toString());
    }
    return jsonData;
  }
}
