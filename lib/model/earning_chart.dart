import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;

class EarningChart extends StatelessWidget {
  // final List<SubscriberSeries> data;

  // const EarningChart({required this.data});

  @override
  Widget build(BuildContext context) {
    // List<charts.Series<SubscriberSeries, String>> series = [
    //   charts.Series(
    //       id: "Subscribers",
    //       data: data,
    //       domainFn: (SubscriberSeries series, _) => series.year,
    //       measureFn: (SubscriberSeries series, _) => series.subscribers,
    //       colorFn: (SubscriberSeries series, _) => series.barColor
    //   )
    // ];
    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
             const Text(
                "Earning Chart",
              ),
              // Expanded(
              //   child: charts.BarChart(series, animate: true),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
