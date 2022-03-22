class Project {

  final String _id;
  final String _name;
  final String _startDate;
  final String _endDate;
  final int _taskCompleted;
  final int _taskToDo;


  Project(this._id, this._name, this._startDate, this._endDate, this._taskCompleted, this._taskToDo);

  String get name => _name;

  String get startDate => _startDate;

  String get endDate => _endDate;

  int get taskCompleted => _taskCompleted;

  int get taskToDo => _taskToDo;

  String get id => _id;
}