import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loops/model/Project.dart';

class HomeRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Project>> getProjects() async {
    late List<Project> dataRef = <Project>[];
    late Project singleProject;

    QuerySnapshot querySnapshot = await firestore.collection('projects').get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((element) {
        if (element.exists) {
          singleProject = Project(
              id: element.id.toString(),
              name: element.get('name'),
              projectGoal: element.get('projectGoal'),
              oneLiner: element.get('oneLiner'),
              startDate: element.get('startDate'),
              endDate: element.get('endDate'),
              taskCompleted: element.get('taskCompleted'),
              taskToDo: element.get('taskToDo'),
              currentSprintId: element.get('currentSprintId'));
          dataRef.add(singleProject);
        }
      });
    }

    return dataRef;

    //write the query to retrieve data from database
    //map that data onto a list of Projects
    //give back the List of Projects to Controller
    //Controller passes them onto a ListView builder and the ListView builder in the widgets renders the projects
  }

  Future<void> saveNewlyCreatedProject({
      required String name, required String oneLiner, required String projectGoal, required String startDate, required String endDate}) async {
    await firestore.collection('projects').add({
      'name': name,
      'oneLiner': oneLiner,
      'startDate': startDate,
      'endDate': endDate,
      'projectGoal': projectGoal,
      'id': 0,
      'taskCompleted': 0,
      'taskToDo': 0
    }).then((value) => print(value.id));
  }
}
