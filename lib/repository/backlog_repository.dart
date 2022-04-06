import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:loops/models/Task.dart';
import 'package:loops/services/calendar_client.dart';

class BacklogRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Task>> retrieveCompleteTasks(String projectId) async {
    List<Task> tasksToReturn = <Task>[];

    QuerySnapshot querySnapshot = await firestore
        .collection('task')
        .where('projectId', isEqualTo: projectId)
        .get();

    String sprintId = Get.find<GetStorage>().read('currentProjectSprintId');

    if (querySnapshot.size > 0) {
      querySnapshot.docs.forEach((element) {
        if(element.get('completed') != true) {
          Task singleTask = Task(
              id: element.id.toString(),
              name: element.get('name'),
              projectId: element.get('projectId'),
              epicId: element.get('epicId'),
              teamId: element.get('teamId'),
              teamMemberId: element.get('teamMemberId'),
              startDate: element.get('startDate'),
              endDate: element.get('endDate'),
              oneLiner: element.get('oneLiner'),
              fullDescription: element.get('fullDescription'),
              sprintId: element.get('sprintId'),
              storyPoints: element.get('storyPoints'),
              completed: element.get('completed'));
          tasksToReturn.add(singleTask);
        }});
    }

    return tasksToReturn;
  }

  Future<List<Task>> retrieveCurrentSprintTasks(String projectId) async {
    List<Task> tasksToReturn = <Task>[];

    String sprintId = Get.find<GetStorage>().read('currentProjectSprintId');

    QuerySnapshot querySnapshot = await firestore
        .collection('task')
        .where('sprintId', isEqualTo: sprintId)
        .get();


    if (querySnapshot.size > 0) {
      querySnapshot.docs.forEach((element) {
        if(element.get('completed') != true){
        if(sprintId == element.get('sprintId')) {
          Task singleTask = Task(
              id: element.id.toString(),
              name: element.get('name'),
              projectId: element.get('projectId'),
              epicId: element.get('epicId'),
              teamId: element.get('teamId'),
              teamMemberId: element.get('teamMemberId'),
              startDate: element.get('startDate'),
              endDate: element.get('endDate'),
              oneLiner: element.get('oneLiner'),
              fullDescription: element.get('fullDescription'),
              sprintId: element.get('sprintId'),
              storyPoints: element.get('storyPoints'),
              completed: element.get('completed'));
          tasksToReturn.add(singleTask);};
      }});
    }

    return tasksToReturn;
  }

  Future<void> orderTasks() async {}

  Future<void> addNewTask(
      String projectId,
      String createdProjectName,
      String startDate,
      String endDate,
      String oneLiner,
      String fullDescription,
      int storyPoints,
      String sprintId) async {
    print(sprintId);
    firestore.collection('task').add({
      'name': createdProjectName,
      'startDate': startDate,
      'endDate': endDate,
      'teamId': '',
      'projectId': projectId,
      'epicId': '',
      'order': 1,
      'teamMemberId': '',
      'oneLiner': oneLiner,
      'fullDescription': fullDescription,
      'storyPoints': storyPoints,
      'sprintId': sprintId,
      'completed': false,
    });
  }

  Future<void> reorderTasks(List<Task> reorderedList) async {}

  Future<void> markTaskAsCompleted(String taskId) async {
    await firestore.collection('task').doc(taskId).update({'completed': true});
  }

  Future<void> deleteTask(String taskId) async {
    await firestore.collection('task').doc(taskId).delete();
  }

  Future<void> sendMeetingInvite(
      {required String meetingTitle,
      required String meetingDescription,
      required String meetingLocation,
      required List<String> attendees,
      required bool nofityAttendees,
      required bool conferenceSupport,
      required DateTime meetingBeginning,
      required DateTime meetingEnding}) async {
    List<EventAttendee> meetingAttendees = [];
    attendees.forEach((person) {
      EventAttendee anAttendee = EventAttendee(email: person);
      meetingAttendees.add(anAttendee);
    });

    await Get.find<CalendarClient>().insert(
        title: meetingTitle,
        description: meetingDescription,
        location: meetingLocation,
        attendeeEmailList: meetingAttendees,
        shouldNotifyAttendees: nofityAttendees,
        hasConferenceSupport: conferenceSupport,
        startTime: meetingBeginning,
        endTime: meetingEnding);
  }

  Future<void> assignTaskToSprint() async {}
}
