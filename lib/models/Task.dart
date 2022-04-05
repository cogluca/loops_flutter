import 'package:flutter/cupertino.dart';

class Task {
  final String id;
  final String name;
  final String projectId;
  final String epicId;
  final String teamId;
  final String teamMemberId;
  final String startDate;
  final String endDate;
  final String oneLiner;
  final String fullDescription;
  final String sprintId;
  final int storyPoints;
  final bool completed;

  Task(
      {required this.id,
      required this.name,
      required this.projectId,
      required this.epicId,
      required this.teamId,
      required this.teamMemberId,
      required this.startDate,
      required this.endDate,
      required this.oneLiner,
      required this.fullDescription,
      required this.sprintId,
      required this.storyPoints,
      required this.completed});

  dynamic toJson() => {
        'id': id,
        'name': name,
        'projectId': projectId,
        'epicId': id,
        'teamId': teamId,
        'teamMemberId': teamMemberId,
        'startDate': startDate,
        'endDate': endDate,
        'oneLiner': oneLiner,
        'fullDescription': fullDescription,
        'sprintId': sprintId,
        'storyPoints': storyPoints,
        'completed': completed,
      };

  factory Task.fromJson(Map jsonFormatTask) {
    return Task(
        id: jsonFormatTask['id'],
        name: jsonFormatTask['name'],
        projectId: jsonFormatTask['projectId'],
        epicId: jsonFormatTask['epicId'],
        teamId: jsonFormatTask['teamId'],
        teamMemberId: jsonFormatTask['teamMemberId'],
        startDate: jsonFormatTask['startDate'],
        endDate: jsonFormatTask['endDate'],
        oneLiner: jsonFormatTask['oneLiner'],
        fullDescription: jsonFormatTask['fullDescription'],
        sprintId: jsonFormatTask['sprintId'],
        storyPoints: jsonFormatTask['storyPoints'],
        completed: jsonFormatTask['completed']);
  }
}
