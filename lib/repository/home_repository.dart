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
          singleProject = Project.fromJson(element);
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

  Future<void> saveNewlyCreatedProject(
      {required Project projectToBeSaved}) async {
    await firestore
        .collection('projects')
        .add(projectToBeSaved.toJson())
        .then((value) => print(value.id));
  }
}
