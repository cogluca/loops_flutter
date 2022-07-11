import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String _id;
  String _name;
  String _projectId;
  String _epicId;
  String _teamId;
  String _teamMemberId;
  String _startDate;
  String _endDate;
  String _oneLiner;
  String _fullDescription;
  String _sprintId;
  int _storyPoints;
  bool _completed;
  String _dateCompletion;
  String _dateInsertion;
  int _order;

  Task(
      this._id,
      this._name,
      this._projectId,
      this._epicId,
      this._teamId,
      this._teamMemberId,
      this._startDate,
      this._endDate,
      this._oneLiner,
      this._fullDescription,
      this._sprintId,
      this._storyPoints,
      this._completed,
      this._dateCompletion,
      this._dateInsertion,
      this._order);

  dynamic toJson() => {
        'id': id,
        'name': name,
        'projectId': projectId,
        'epicId': id,
        'teamId': teamId,
        'order': order,
        'teamMemberId': teamMemberId,
        'startDate': startDate,
        'endDate': endDate,
        'oneLiner': oneLiner,
        'fullDescription': fullDescription,
        'sprintId': sprintId,
        'storyPoints': storyPoints,
        'completed': completed,
        'dateInsertion': dateInsertion,
        'dateCompletion': dateCompletion,
      };

  factory Task.fromJson(QueryDocumentSnapshot jsonFormatTask) {
    return Task(
        jsonFormatTask.id,
        jsonFormatTask['name'],
        jsonFormatTask['projectId'],
        jsonFormatTask['epicId'],
        jsonFormatTask['teamId'],
        jsonFormatTask['teamMemberId'],
        jsonFormatTask['startDate'],
        jsonFormatTask['endDate'],
        jsonFormatTask['oneLiner'],
        jsonFormatTask['fullDescription'],
        jsonFormatTask['sprintId'],
        jsonFormatTask['storyPoints'],
        jsonFormatTask['completed'],
        jsonFormatTask['dateCompletion'],
        jsonFormatTask['dateInsertion'],
        jsonFormatTask['order']);
  }

  String get id => _id;

  String get name => _name;

  String get projectId => _projectId;

  String get epicId => _epicId;

  String get teamId => _teamId;

  String get teamMemberId => _teamMemberId;

  String get startDate => _startDate;

  String get endDate => _endDate;

  String get oneLiner => _oneLiner;

  String get fullDescription => _fullDescription;

  String get sprintId => _sprintId;

  int get storyPoints => _storyPoints;

  bool get completed => _completed;

  String get dateCompletion => _dateCompletion;

  String get dateInsertion => _dateInsertion;

  int get order => _order;

  set id(String value) {
    _id = value;
  }

  set name(String value) {
    _name = value;
  }

  set projectId(String value) {
    _projectId = value;
  }

  set epicId(String value) {
    _epicId = value;
  }

  set teamId(String value) {
    _teamId = value;
  }

  set teamMemberId(String value) {
    _teamMemberId = value;
  }

  set startDate(String value) {
    _startDate = value;
  }

  set endDate(String value) {
    _endDate = value;
  }

  set oneLiner(String value) {
    _oneLiner = value;
  }

  set fullDescription(String value) {
    _fullDescription = value;
  }

  set sprintId(String value) {
    _sprintId = value;
  }

  set storyPoints(int value) {
    _storyPoints = value;
  }

  set completed(bool value) {
    _completed = value;
  }

  set dateCompletion(String value) {
    _dateCompletion = value;
  }

  set dateInsertion(String value) {
    _dateInsertion = value;
  }

  set order(int value) {
    _order = value;
  }
}
