import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../../model/Sprint.dart';

/**

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;
  final Sprint thisSprint;

  SimpleTimeSeriesChart(this.thisSprint, {required this.animate, required this.seriesList});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData(List<Sprint> toConvertSprints) {
    List<charts.Series<TimeSeriesSprints, DateTime>> toReturnProjectBurndown = [];

    toConvertSprints.map((e) {toReturnProjectBurndown.add(TimeSeriesSprints(DateTime.parse(e.startDate!), e.getBurndown));});

    return SimpleTimeSeriesChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSprints, DateTime>> _createSampleData() {

    final data = [
      TimeSeriesSprints(DateTime(2017, 9, 19), 5),
      TimeSeriesSprints(DateTime(2017, 9, 26), 25),
      TimeSeriesSprints(DateTime(2017, 10, 3), 100),
      TimeSeriesSprints(DateTime(2017, 10, 10), 75),
    ];

    return [
      charts.Series<TimeSeriesSprints, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSprints sales, _) => sales.time,
        measureFn: (TimeSeriesSprints sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSprints {
  final DateTime time;
  final int sales;

  TimeSeriesSprints(this.time, this.sales);
}

    **/