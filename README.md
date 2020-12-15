# Tide Times

A simple application to display local tide times

This project is a demonstration project to show local tide times. Enter API key and latitude, longitude details into the [constants](https://github.com/Ifouldm/Tide-Times/blob/master/lib/utils/constants.dart) file. There are a number of improvements that could be impletemented but the raw application was created from scratch in day as a self-imposed challenge.

The application queries the [RapidAPI Tides](https://rapidapi.com/apihood/api/tides/details) API to get the next x days tides, due to the limitations on this API this data is stored locally and only requeried at set intervals to reduce the number of requests.

- [x] Prototype user interface
- [x] Display data from local JSON file
- [x] Query remote API for data
- [x] Refresh button
- [x] Refresh button (long press manually refreshs data from remote)
- [x] Display background graphic to visualise current tide

There are a number of improvements and features that would be useful to this application but it was designed to be a quick prototype app and the only feature I regret not implementing it would be:
- [ ] Change location in application


## Dependencies

- [Flutter Dot Env](https://pub.dev/packages/flutter_dotenv)
- [HTTP](https://pub.dev/packages/http)

## Images

![Tide Times Mobile Application](https://i.imgur.com/OIMLREV.png "Tide Times Mobile Application")

## Run Application

Run main.dart in android studio

or

```sh
flutter run lib/main.dart
```
