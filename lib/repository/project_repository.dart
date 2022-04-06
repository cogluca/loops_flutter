import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:loops/models/Sprint.dart';

import '../models/Task.dart';
import '../services/calendar_client.dart';

class ProjectRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Sprint>> retrieveSprint() async {

    List<Sprint> retrievedSprints = [];


    //TODO Nested api calls seems the worst shit that I could possibly do, really not concentrated, get the blob sort it by myself, unload complexity from network to a minimal computation on repository, minimum sorting ?

    QuerySnapshot querySnapshotOfSprint =
        await firestore.collection('sprint').get();

    if (querySnapshotOfSprint.size > 0) {

      querySnapshotOfSprint.docs.forEach((element) {
        Sprint aRetrievedSprint = Sprint(
            id: element.id,
            startDate: element.get('startDate'),
            endDate: element.get('endDate'),
            completed: element.get('completed'),
            listOfTasks: []);
        retrievedSprints.add(aRetrievedSprint);
      });
    } else {
      //allow to receive partial data, it isn't userfriendly to throw a brick into someone's face
      List<QueryDocumentSnapshot> queryDocumentSnapshot =
          querySnapshotOfSprint.docs;
      int size = queryDocumentSnapshot.length;
      throw 'Got some issues $size elements where retrieved';
    }

    for (var sprintElement in retrievedSprints) {
      QuerySnapshot querySnapshotOfTasks = await firestore
          .collection('task')
          .where('sprintId', isEqualTo: sprintElement.id)
          .get();

      if (querySnapshotOfTasks.size > 0) {
        for (var element in querySnapshotOfTasks.docs) {
          if (sprintElement.id == element.get('sprintId')) {
            Task aRetrievedTask = Task(
                id: element.id,
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
            sprintElement.listOfTasks.add(aRetrievedTask);
          }
        }
      }
    }

    //TODO FUCK IT TIRED SORT LISTS AND THEN CYCLE THROUGH NOT WITH TWO NESTED LOOPS, RECURSIVELY MAYBE AND FROM THERE ADD TASKS TO THE CORRECT LIST ELEMENTS, SHOULD BE A SCALABLE APPROACH TO REDUCE TIMES

    //retrievedSprints.sort((a,b) => a.id.length.compareTo(b.id.length));
    //tasksOfSprint.sort()

//Where do I go in the afterlife ? Beyond space and time

    //unicity of sprint is not granted, can assume unicity from Firestore generated ID

    return retrievedSprints;
  }

  Future<void> addNewSprint(Sprint sprintToAdd) async {
    await firestore.collection('sprint').add(sprintToAdd.toJson());
  }

  Future<Sprint> retrieveCurrentSprint(String currentSprintId) async {
    List<Task> tasksOfSprint = [];

    DocumentSnapshot documentSnapshot =
        await firestore.collection('sprint').doc(currentSprintId).get();

    QuerySnapshot tasksOfSprintSnapshot = await firestore
        .collection('task')
        .where('sprintId', isEqualTo: currentSprintId)
        .get();

    if (tasksOfSprintSnapshot.size > 0) {
      tasksOfSprintSnapshot.docs.forEach((element) {
        Task aRetrievedTask = Task(
            id: element.id,
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
        tasksOfSprint.add(aRetrievedTask);
      });
    }
    Sprint retrievedSprint = Sprint(
        startDate: documentSnapshot.get('startDate'),
        endDate: documentSnapshot.get('endDate'),
        listOfTasks: tasksOfSprint,
        completed: documentSnapshot.get('completed'));

    return retrievedSprint;
  }

  Future<void> turnSprintOff() async {
    String projectId = Get.find<GetStorage>().read('choosenProject');
    String sprintId = Get.find<GetStorage>().read('currentProjectSprintId');

    await firestore.collection('projects').doc(projectId).update({
      'currentSprintId': "",
    });

    await firestore
        .collection('sprint')
        .doc(sprintId)
        .update({'completed': true});

    Get.find<GetStorage>().write('currentProjectSprintId', 'none');
  }

  Future<String> startASprint(
      String sprintStartDate, String sprintEndDate) async {
    String sprintId = await firestore.collection('sprint').add({
      'startDate': sprintStartDate,
      'endDate': sprintEndDate,
      'completed': false,
      'totalStoryPoints': 0,
      'totalStoryPointsAchieved': 0,
    }).then((value) => value.id);

    print('current sprint id is ${sprintId}');

    String projectId = Get.find<GetStorage>().read('choosenProject');

    await firestore.collection('projects').doc(projectId).update({
      'currentSprintId': sprintId,
    });

    Get.find<GetStorage>().write('currentProjectSprintId', sprintId);

    return sprintId;
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
}
