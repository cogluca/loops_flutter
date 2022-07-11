import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:loops/error_handling/Failure.dart';
import 'package:loops/model/Task.dart';
import 'package:loops/services/calendar_client.dart';

class BacklogRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Task>> retrieveCompleteTasks(String projectId) async {
    List<Task> tasksToReturn = <Task>[];

    QuerySnapshot querySnapshot = await firestore
        .collection('task')
        .where('projectId', isEqualTo: projectId)
        .get()
        .onError((error, stackTrace) =>
            throw Failure("Error while retrieving complete project task list"));

    String sprintId = Get.find<GetStorage>().read('currentProjectSprintId');

    if (querySnapshot.size > 0) {
      querySnapshot.docs.forEach((element) {
        if (element.get('completed') != true) {
          Task singleTask = Task.fromJson(element);
          tasksToReturn.add(singleTask);
        }
      });
    }

    tasksToReturn.sort((a, b) {
      return a.order.compareTo(b.order);
    });

    Get.find<GetStorage>().write('completeBacklogTasks', tasksToReturn.length);

    return tasksToReturn;
  }

  Future<List<Task>> retrieveCurrentSprintTasks(String projectId) async {
    List<Task> tasksToReturn = <Task>[];

    String sprintId = Get.find<GetStorage>().read('currentProjectSprintId');

    QuerySnapshot querySnapshot = await firestore
        .collection('task')
        .where('sprintId', isEqualTo: sprintId)
        .get()
        .onError((error, stackTrace) => throw Failure(
            'There was a problem retrieving tasks of current Sprint'));

    if (querySnapshot.size > 0) {
      querySnapshot.docs.forEach((element) {
        if (element.get('completed') != true) {
          if (sprintId == element.get('sprintId')) {
            Task singleTask = Task.fromJson(element);
            tasksToReturn.add(singleTask);
          }
          ;
        }
      });
    }

    Get.find<GetStorage>().write('sprintBacklogTasks', tasksToReturn.length);

    tasksToReturn.sort((a, b) {
      return a.order.compareTo(b.order);
    });

    return tasksToReturn;
  }

  Future<void> orderTasks() async {}

  //this is something that could be passed as an object, the Repository shouldn't be bothered by an objects internals
  Future<void> addNewTask(Task toInsertTask) async {
    firestore.collection('task').add(toInsertTask.toJson()).onError(
        (error, stackTrace) =>
            throw Failure('There was an error adding new Task onto database'));
  }

  Future<void> reorderTasks(List<Task> reorderedList) async {
    int position = 0;
    reorderedList.forEach((element) {
      element.order = position;
      position++;
    });

    for (var element in reorderedList) {
      await firestore
          .collection('task')
          .doc(element.id)
          .update({'order': element.order});
    }
  }

  Future<void> markTaskAsCompleted(String taskId) async {
    await firestore.collection('task').doc(taskId).update({
      'completed': true,
      'dateCompletion':
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'
    }).onError((error, stackTrace) =>
        throw Failure('There was an error while marking task as completed'));
  }

  Future<void> deleteTask(String taskId) async {
    await firestore.collection('task').doc(taskId).delete().onError(
        (error, stackTrace) =>
            throw Failure('There was a problem deleting the task'));
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

    await Get.find<CalendarClient>()
        .insert(
            title: meetingTitle,
            description: meetingDescription,
            location: meetingLocation,
            attendeeEmailList: meetingAttendees,
            shouldNotifyAttendees: nofityAttendees,
            hasConferenceSupport: conferenceSupport,
            startTime: meetingBeginning,
            endTime: meetingEnding)
        .onError((error, stackTrace) => throw stackTrace);
  }

  Future<void> assignTaskToSprint() async {}
}
