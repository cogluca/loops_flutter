import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Task.dart';

class Sprint {

  String _id;
  String _startDate;
  String _endDate;
  int _totalStoryPoints = 0;
  int _totalStoryPointsAchieved = 0;
  List<Task> _listOfTasks;
  bool _completed = false;

  Sprint(this._id, this._startDate, this._endDate, this._listOfTasks,
      this._completed);

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

  int get getBurndown {
    return getTotalStoryPoints - getTotalStoryPointsAchieved;
  }

  dynamic toJson() => {
        'startDate': startDate,
        'endDate': endDate,
        'totalStoryPoints': totalStoryPoints,
        'totalStoryPointsAchieved': totalStoryPointsAchieved
      };

  factory Sprint.fromJson(DocumentSnapshot jsonRetrieved) {
    return Sprint(
      jsonRetrieved.id,
      jsonRetrieved['startDate'],
      jsonRetrieved['endDate'],
      [],
      jsonRetrieved['completed']
    );


  }

  factory Sprint.fromSingleJson(DocumentSnapshot jsonRetrieved) {
    return Sprint(
        jsonRetrieved.id,
        jsonRetrieved['startDate'],
        jsonRetrieved['endDate'],
        [],
        jsonRetrieved['completed']
    );
  }

  String get id => _id;

  String get startDate => _startDate;

  String get endDate => _endDate;

  int get totalStoryPoints => _totalStoryPoints;

  int get totalStoryPointsAchieved => _totalStoryPointsAchieved;

  List<Task> get listOfTasks => _listOfTasks;

  bool get completed => _completed;

  set listOfTasks(List<Task> value) {
    _listOfTasks = value;
  }
}

//how should I address Sprint - General tasks ? There is an id on tasks referring to Sprint Id
//should the Sprint model contain a List of Tasks retrieved dynamically ?
//Where do I retrieve Sprint data ?
