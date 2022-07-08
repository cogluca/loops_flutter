import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../model/Sprint.dart';

class BarChartSample2 extends StatefulWidget {
  List<Sprint> dataFromSprints;

  BarChartSample2(List<Sprint> value, {Key? key })
      : dataFromSprints = value,
        super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData( 5, 12);
    final barGroup2 = makeGroupData( 16, 12);
    final barGroup3 = makeGroupData( 18, 5);
    final barGroup4 = makeGroupData( 20, 16);
    final barGroup5 = makeGroupData( 17, 6);
    final barGroup6 = makeGroupData( 19, 1.5);
    final barGroup7 = makeGroupData( 10, 1.5);

    int barCounter = 0;


    /**widget.dataFromSprints.forEach((element) {
      print(element.listOfTasks.first.id);
    });
        */


    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

  }


  //TODO : Make the whole component responsive, dimensions are hardcoded
  @override
  Widget build(BuildContext context) {
    widget.dataFromSprints.sort((a,b){
      return DateTime.parse(a.startDate).compareTo(DateTime.parse(b.startDate));
    });

    return AspectRatio(
      aspectRatio: 2,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const <Widget>[

                  SizedBox(
                    width: 89,
                  ),

                  Text(
                    'Project Velocity',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: BarChart(BarChartData(
                  alignment: BarChartAlignment.start,
                    borderData: FlBorderData(
                        border: const Border(
                          top: BorderSide.none,
                          right: BorderSide.none,
                          left: BorderSide(width: 1),
                          bottom: BorderSide(width: 1),
                        )),
                    groupsSpace: 10,
                    barGroups:
                      widget.dataFromSprints.map((dataItem) => makeGroupData(dataItem.getTotalStoryPoints.toDouble(),dataItem.getTotalStoryPointsAchieved.toDouble())
                        ).toList()))
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }


  BarChartGroupData makeGroupData(double y1, double y2) {
    int barCounter = 0;
    return BarChartGroupData(barsSpace: 4, x: barCounter++, barRods: [
      BarChartRodData(
        toY: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        toY: y2,
        color: rightBarColor,
        width: width,
      ),
    ]);
  }


  int barCounter = 0;

}