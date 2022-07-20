import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:loops/error_handling/Failure.dart';
import 'package:loops/model/Sprint.dart';

import '../model/Task.dart';
import '../services/calendar_client.dart';

class ProjectRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Sprint>> retrieveSprint({required String projectId}) async {
    List<Sprint> retrievedSprints = [];

    //TODO Nested api calls seems the worst shit that I could possibly do, really not concentrated, get the blob sort it by myself, unload complexity from network to a minimal computation on repository, minimum sorting ?

    QuerySnapshot querySnapshotOfSprint =
        await firestore.collection('sprint').where('projectId', isEqualTo: projectId).get();

    if (querySnapshotOfSprint.size > 0) {
      querySnapshotOfSprint.docs.forEach((element) {
        Sprint aRetrievedSprint = Sprint.fromSingleJson(element);
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
            Task aRetrievedTask = Task.fromJson(element);
            sprintElement.listOfTasks.add(aRetrievedTask);
          }
        }
      }
    }

    return retrievedSprints;
  }

  Future<void> addNewSprint(Sprint sprintToAdd) async {
    await firestore.collection('sprint').add(sprintToAdd.toJson());
  }

  Future<Sprint> retrieveCurrentSprint(String currentSprintId) async {
    List<Task> tasksOfSprint = [];

    DocumentSnapshot documentSnapshot =
        await firestore.collection('sprint').doc(currentSprintId).get().onError((error, stackTrace) => throw Failure('Empty sprint data'));

    QuerySnapshot tasksOfSprintSnapshot = await firestore
        .collection('task')
        .where('sprintId', isEqualTo: currentSprintId)
        .get();

    if (tasksOfSprintSnapshot.size > 0) {
      tasksOfSprintSnapshot.docs.forEach((element) {
        Task aRetrievedTask = Task.fromJson(element);
        tasksOfSprint.add(aRetrievedTask);
      });
    }

    Sprint retrievedSprint = Sprint.fromJson(documentSnapshot);
    retrievedSprint.listOfTasks = tasksOfSprint;

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
      Sprint startASprint) async {
    String sprintId = await firestore.collection('sprint').add(startASprint.toJson()).then((value) => value.id);

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
