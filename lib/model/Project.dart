class Project {

  final String? id;
  final String? name;
  final String? oneLiner;
  final String? startDate;
  final String? endDate;
  final int? taskCompleted;
  final int? taskToDo;
  final String? currentSprintId;
  final String? projectGoal;


  Project({this.id, this.name, this.oneLiner, this.startDate, this.endDate, this.taskCompleted, this.taskToDo, this.currentSprintId, this.projectGoal});


  dynamic toJson() => {
    'id': id.toString(),
    'name': name.toString(),
    'oneLiner': oneLiner.toString(),
    'startDate': startDate.toString(),
    'endDate': endDate.toString(),
    'taskCompleted': taskCompleted.toString(),
    'taskToDo': taskToDo.toString(),
    'currentSprintId': currentSprintId.toString(),
    'projectGoal': projectGoal.toString()
  };


  factory Project.fromJson(Map<String, dynamic> jsonProjectData) {

    return Project(
      id: jsonProjectData['id'],
      name: jsonProjectData['name'],
      oneLiner: jsonProjectData['oneLiner'],
      startDate: jsonProjectData['startDate'],
      endDate: jsonProjectData['endDate'],
      taskCompleted: jsonProjectData['taskCompleted'],
      taskToDo: jsonProjectData['taskToDo'],
      currentSprintId: jsonProjectData['currentSprintId'],
      projectGoal: jsonProjectData['projectGoal']
    );
  }







}