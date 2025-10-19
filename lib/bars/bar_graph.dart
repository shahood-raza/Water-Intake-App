import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:water_intake_app/bars/bar_data.dart';

class BarGraph extends StatelessWidget {
  final double maxY;
  final double sunWaterAmt;
  final double monWaterAmt;
  final double tueWaterAmt;
  final double wedWaterAmt;
  final double thurWaterAmt;
  final double friWaterAmt;
  final double satWaterAmt;

  const BarGraph({
    super.key,
    required this.maxY,
    required this.sunWaterAmt,
    required this.monWaterAmt,
    required this.tueWaterAmt,
    required this.wedWaterAmt,
    required this.thurWaterAmt,
    required this.friWaterAmt,
    required this.satWaterAmt,
  });

  @override
  Widget build(BuildContext context) {
    BarData barData = BarData(
      sunWaterAmt: sunWaterAmt,
      monWaterAmt: monWaterAmt,
      tueWaterAmt: tueWaterAmt,
      wedWaterAmt: wedWaterAmt,
      thurWaterAmt: thurWaterAmt,
      friWaterAmt: friWaterAmt,
      satWaterAmt: satWaterAmt,
    );
    barData.initBarData();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: 0,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getBottomTitleWiget,
              ),
            ),
          ),

          barGroups: barData.barData
              .map(
                (data) => BarChartGroupData(
                  x: data.x,
                  barRods: [
                    BarChartRodData(
                      toY: data.y,
                      width: 18,
                      color: Colors.lightBlue[500],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
  // to create custom widget of title bottomof graph (ye chezz ushi ma define krksty thy lekin alg karhy readability ke liye)
  Widget getBottomTitleWiget(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: Color.fromARGB(255, 24, 23, 23),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    // to store days value in a text widget
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('S', style: style);
        break;
      case 1:
        text = Text('M', style: style);
        break;
      case 2:
        text = Text('T', style: style);
        break;
      case 3:
        text = Text('W', style: style);
        break;
      case 4:
        text = Text('T', style: style);
        break;
      case 5:
        text = Text('F', style: style);
        break;
      case 6:
        text = Text('S', style: style);
        break;
      default:
        text = Text('');
    }
    return SideTitleWidget(meta: meta, child: text);
  }
}
