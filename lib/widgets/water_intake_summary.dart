import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake_app/bars/bar_graph.dart';
import 'package:water_intake_app/providers/water_provider.dart';
import 'package:water_intake_app/utils/date_helper.dart';

class WaterIntakeSummary extends StatelessWidget {
  final DateTime startOfTheWeek;
  const WaterIntakeSummary({super.key, required this.startOfTheWeek});

  double calculateMaxAmountOfWater(
    WaterProvider waterData,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double? maxAmount = 100;

    //List of water data
    List<double> values = [
      waterData.calculateDailyWaterSummary()[sunday] ?? 0,
      waterData.calculateDailyWaterSummary()[monday] ?? 0,
      waterData.calculateDailyWaterSummary()[tuesday] ?? 0,
      waterData.calculateDailyWaterSummary()[wednesday] ?? 0,
      waterData.calculateDailyWaterSummary()[thursday] ?? 0,
      waterData.calculateDailyWaterSummary()[friday] ?? 0,
      waterData.calculateDailyWaterSummary()[saturday] ?? 0,
    ];

    // sort to smallest to largest
    values.sort();

    //get the largest value
    // increase the maxmamount by 1.2% of largest value
    maxAmount = values.last * 1.2;

    return maxAmount == 0 ? 100 : maxAmount;
  }

  //days

  @override
  Widget build(BuildContext context) {
    String sunday = convertDateTimeToString(
      startOfTheWeek.add(Duration(days: 0)),
    );
    String monday = convertDateTimeToString(
      startOfTheWeek.add(Duration(days: 1)),
    );
    String tuesday = convertDateTimeToString(
      startOfTheWeek.add(Duration(days: 2)),
    );
    String wednesday = convertDateTimeToString(
      startOfTheWeek.add(Duration(days: 3)),
    );
    String thursday = convertDateTimeToString(
      startOfTheWeek.add(Duration(days: 4)),
    );
    String friday = convertDateTimeToString(
      startOfTheWeek.add(Duration(days: 5)),
    );
    String saturday = convertDateTimeToString(
      startOfTheWeek.add(Duration(days: 6)),
    );

    return Consumer<WaterProvider>(
      builder: (context, value, child) {
        return SizedBox(
          height: 200,
          child: BarGraph(
            maxY: calculateMaxAmountOfWater(
              value,
              sunday,
              monday,
              tuesday,
              wednesday,
              thursday,
              friday,
              saturday,
            ),
            sunWaterAmt: value.calculateDailyWaterSummary()[sunday] ?? 0,
            monWaterAmt: value.calculateDailyWaterSummary()[monday] ?? 0,
            tueWaterAmt: value.calculateDailyWaterSummary()[tuesday] ?? 0,
            wedWaterAmt: value.calculateDailyWaterSummary()[wednesday] ?? 0,
            thurWaterAmt: value.calculateDailyWaterSummary()[thursday] ?? 0,
            friWaterAmt: value.calculateDailyWaterSummary()[friday] ?? 0,
            satWaterAmt: value.calculateDailyWaterSummary()[saturday] ?? 0,
          ),
        );
      },
    );
  }
}
