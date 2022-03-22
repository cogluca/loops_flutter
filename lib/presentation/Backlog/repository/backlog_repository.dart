import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loops/models/Task.dart';

class BacklogRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Task>> retrieveTasks(String id) async {
    List<Task> tasksToReturn = <Task>[];

    QuerySnapshot querySnapshot = await firestore.collection('task').where('projectId', isEqualTo: id).get();

    querySnapshot.docs.forEach((element) {
      if (element.exists) {
        Task singleTask = Task(
            element.id,
            element.get('name'),
            element.get('projectId'),
            element.get('epicId'),
            element.get('teamId'),
            element.get('teamMemberId'),
            element.get('startDate'),
            element.get('endDate'));
        tasksToReturn.add(singleTask);
      }
    });

    return tasksToReturn;
  }

  Future<void> orderTasks() async {}

  Future<void> addNewTask(String projectId, String createdProjectName,
      String startDate, String endDate) async {
    firestore.collection('task').add({
      'name': createdProjectName,
      'startDate': startDate,
      'endDate': endDate,
      'teamId': '',
      'projectId': projectId,
      'epicId': '',
      'teamMemberId': ''
    });
  }
}
