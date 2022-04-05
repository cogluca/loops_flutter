import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Task.dart';

class Sprint {


  final String? id;
  final String? startDate;
  final String? endDate;
  int totalStoryPoints = 0;
  int totalStoryPointsAchieved = 0;
  List<Task> listOfTasks;
  bool? completed = false;


  Sprint(
      {this.id, required this.startDate, required this.endDate, required this.listOfTasks, required this.completed});


  int get getTotalStoryPoints {
    int storyPoints = 0;
    listOfTasks.forEach((element) {
      storyPoints += element.storyPoints;
    });
    return storyPoints;
  }

  int get getTotalStoryPointsAchieved {
    int storyPointsAchieved = 0;
    listOfTasks.forEach((element) {
      if (element.completed) {
        storyPointsAchieved += element.storyPoints;
      }
    });
    return storyPointsAchieved;
  }


  dynamic toJson() =>
      {
        'startDate'
            : startDate,
        'endDate': endDate,
        'totalStoryPoints': totalStoryPoints,
        'totalStoryPointsAchieved': totalStoryPointsAchieved
      };


}


//how should I address Sprint - General tasks ? There is an id on tasks referring to Sprint Id
//should the Sprint model contain a List of Tasks retrieved dynamically ?
//Where do I retrieve Sprint data ?