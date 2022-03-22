import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loops/models/Project.dart';

class HomeRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Project>> getProjects() async {

    late List<Project> dataRef = <Project>[];
    late Project singleProject;

    QuerySnapshot querySnapshot = await firestore.collection('projects').get();

    if(querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((element) {

        if (element.exists) {
          singleProject = Project(
            element.id.toString(),
              element.get('name'),
              element.get('startDate'),
              element.get('endDate'),
              element.get('taskCompleted'),
              element.get('taskToDo'));
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

  Future<void> saveNewlyCreatedProject(String name, String startDate, String endDate) async {

    await firestore.collection('projects').add(
      {
        'name': name,
        'startDate': startDate,
        'endDate': endDate,
        'id': 0,
        'taskCompleted': 0,
        'taskToDo': 0
      }
    ).then((value) => print(value.id));


  }

}
