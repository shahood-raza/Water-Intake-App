import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:water_intake_app/models/water_model.dart';
import 'package:water_intake_app/utils/date_helper.dart';

class WaterProvider with ChangeNotifier {
  // to get model data
  List<WaterModel> waterData = [];

  //add water to firebase db
  void addWater(WaterModel water) async {
    // endpoint of firbase db and add a configuration to add somethig to db here its water.json
    final url = Uri.https(
      'water-intaker-c128a-default-rtdb.asia-southeast1.firebasedatabase.app',
      'water.json',
    );

    // to send data to server usinghhtp request
    // headers tells these are the types that are expected to be received
    // body requires something to be saved
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: json.encode({
        'amount': double.parse(water.amount.toString()),
        'unit': 'ml',
        'dateTime': DateTime.now().toString(),
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      waterData.add(
        WaterModel(
          id: data['name'],
          amount: water.amount,
          dateTime: water.dateTime,
          unit: 'ml',
        ),
      );
    }
    notifyListeners();
  }

  Future<List<WaterModel>> getWater() async {
    final url = Uri.https(
      'water-intaker-c128a-default-rtdb.asia-southeast1.firebasedatabase.app',
      'water.json',
    );

    final response = await http.get(url);

    if (response.statusCode == 200 && response.body != 'null') {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      for (var data in extractedData.entries) {
        waterData.add(
          WaterModel(
            id: data
                .key, // must add this because to add deletig items fucntionality
            amount: data.value['amount'],
            dateTime: DateTime.parse(data.value['dateTime']),
            unit: data.value['unit'],
          ),
        );
      }
    }
    notifyListeners();
    return waterData;
  }

  //get week day from datetime object
  String getWeekday(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  //get Start of week
  DateTime getStartOfWeek() {
    DateTime? startOfWeek;

    //get current date
    DateTime dateTime = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (getWeekday(dateTime.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = dateTime.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  void delete(WaterModel waterModel) {
    final url = Uri.https(
      'water-intaker-c128a-default-rtdb.asia-southeast1.firebasedatabase.app',
      'water/${waterModel.id}.json',
    );
    //delete from database
    http.delete(url);

    //remove from our list
    waterData.removeWhere((element) => element.id == waterModel.id);

    notifyListeners();
  }

  //calculate weekly water intake
  String calculateWeeklyWaterIntake(WaterProvider value) {
    double weeklyWaterIntake = 0;

    //loop through the waterdatalist
    for (var water in value.waterData) {
      weeklyWaterIntake += double.parse(water.amount.toString());
    }

    return weeklyWaterIntake.toStringAsFixed(2);
  }

  //calculate daily water summary

  Map<String, double> calculateDailyWaterSummary() {
    Map<String, double> dailyWaterSummary = {};

    for (var water in waterData) {
      String date = convertDateTimeToString(water.dateTime);
      double amount = double.parse(water.amount.toString());

      if (dailyWaterSummary.containsKey(date)) {
        double currentAmount = dailyWaterSummary[date]!;
        currentAmount += amount;
        dailyWaterSummary[date] = currentAmount;
      } else {
        dailyWaterSummary.addAll({date: amount});
      }
    }
    return dailyWaterSummary;
  }
}
