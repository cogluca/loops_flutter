import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String _id;
  String _name;

  String _oneLiner;

  String _startDate;

  String _endDate;
  int _taskCompleted;
  int _taskToDo;
  String _currentSprintId;
  String _projectGoal;

  Project(
      this._id,
      this._name,
      this._oneLiner,
      this._startDate,
      this._endDate,
      this._taskCompleted,
      this._taskToDo,
      this._currentSprintId,
      this._projectGoal);

  dynamic toJson() => {
        'id': id,
        'name': name.toString(),
        'oneLiner': oneLiner.toString(),
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'taskCompleted': taskCompleted,
        'taskToDo': taskToDo,
        'currentSprintId': currentSprintId.toString(),
        'projectGoal': projectGoal.toString()
      };

  factory Project.fromJson(QueryDocumentSnapshot jsonProjectData) {
    return Project(
        jsonProjectData.id,
        jsonProjectData['name'],
        jsonProjectData['oneLiner'],
        jsonProjectData['startDate'],
        jsonProjectData['endDate'],
        jsonProjectData['taskCompleted'],
        jsonProjectData['taskToDo'],
        jsonProjectData['currentSprintId'],
        jsonProjectData['projectGoal']);
  }

  String get id => _id;

  String get name => _name;

  String get oneLiner => _oneLiner;

  String get startDate => _startDate;

  String get endDate => _endDate;

  int get taskCompleted => _taskCompleted;

  int get taskToDo => _taskToDo;

  String get currentSprintId => _currentSprintId;

  String get projectGoal => _projectGoal;

  set id(String value) {
    _id = value;
  }

  set name(String value) {
    _name = value;
  }

  set oneLiner(String value) {
    _oneLiner = value;
  }

  set startDate(String value) {
    _startDate = value;
  }

  set endDate(String value) {
    _endDate = value;
  }

  set taskCompleted(int value) {
    _taskCompleted = value;
  }

  set taskToDo(int value) {
    _taskToDo = value;
  }

  set currentSprintId(String value) {
    _currentSprintId = value;
  }

  set projectGoal(String value) {
    _projectGoal = value;
  }
}
