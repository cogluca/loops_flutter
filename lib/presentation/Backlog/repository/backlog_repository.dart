import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loops/models/Task.dart';

class BacklogRepository {

  FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<List<Task>> retrieveTasks(int id) async {

      List<Task> tasksToReturn = <Task> [];

     QuerySnapshot querySnapshot = await firestore.collection('task').where('id', isEqualTo: id).get();

     querySnapshot.docs.forEach((element) {

       if (element.exists) {
         Task singleTask = Task(
             element.get('id'),
             element.get('name'),
             element.get('projectId'),
             element.get('epicId'),
             element.get('teamId'),
             element.get('teamMemberId'));
         tasksToReturn.add(singleTask);
       }

     });

     return tasksToReturn;



  }

}