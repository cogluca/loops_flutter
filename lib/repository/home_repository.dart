import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:loops/model/Project.dart';
import 'package:loops/presentation/login/controllers/login.controller.dart';

class HomeRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///Gets projects from database through asynchronous call and iterates on result to serialize them from the retrieved json onto Project models
  Future<List<Project>> getProjects() async {
    late List<Project> dataRef = <Project>[];
    late Project singleProject;
    String userUid = Get
        .find<LoginController>()
        .loggedInUser
        .userUid;

    QuerySnapshot querySnapshot = await firestore.collection('projects').where(
        'ownerId', isEqualTo: userUid).get();

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

  ///Saves a newly created project aggregated on the controlled and passed as argument [projectToBeSaved]
  Future<void> saveNewlyCreatedProject(
      {required Project projectToBeSaved}) async {
    await firestore
        .collection('projects')
        .add(projectToBeSaved.toJson())
        .then((value) => print(value.id));
  }


  Future<void> markProjectAsCompleted({required String id}) async {
    await firestore.collection('projects').doc(id).update({
      'completed': true,
    });
  }

  Future<void> deleteProject({required String id}) async {
    await firestore.collection('projects').doc(id).delete();
  }

  /**
   *
   * Possible batch execution template to emulate for subsequent Task and Sprint documents under the Project in deletion
   *
  Future<void> deleteProjectTaskReferences(id) async {
    var snapshot = await firestore.collection('task').where(
        'projectId', isEqualTo: id).get();
    const MAX_WRITES_PER_BATCH = 500; /** https://cloud.google.com/firestore/quotas#writes_and_transactions */

    const batches = chunk(snapshot.docs, MAX_WRITES_PER_BATCH);
    const commitBatchPromises = [];

    batches.forEach(batch => {
    const writeBatch = firestore.batch();
    batch.forEach(doc => writeBatch.delete(doc.ref));
    commitBatchPromises.push(writeBatch.commit());
    });

    await Promise.all(commitBatchPromises);
  }

  */


}
