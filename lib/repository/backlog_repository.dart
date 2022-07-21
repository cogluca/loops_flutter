import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:loops/error_handling/Failure.dart';
import 'package:loops/model/Task.dart';
import 'package:loops/services/calendar_client.dart';

class BacklogRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///Retrieves the complete backlog tasks of a specific project referenced by [projectId] and sorts them according to the order field on each task
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

  ///Retrieves current sprint tasks and sorts them according to order
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

  ///Adds a new task passed as argument to the task collection on the database
  Future<void> addNewTask(Task toInsertTask) async {
    firestore.collection('task').add(toInsertTask.toJson()).onError(
        (error, stackTrace) =>
            throw Failure('There was an error adding new Task onto database'));
  }

  ///Reorders tasks passed as argument by first defining its order parameter according to Ui rendered list and order, then updates each task's order field on the database
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

  ///Marks task referred by [taskId] parameter as completed by updating field completed to true and inserting the completion date
  Future<void> markTaskAsCompleted(String taskId) async {
    await firestore.collection('task').doc(taskId).update({
      'completed': true,
      'dateCompletion':
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'
    }).onError((error, stackTrace) =>
        throw Failure('There was an error while marking task as completed'));
  }

  ///Deletes task referred by [taskId] parameter
  Future<void> deleteTask(String taskId) async {
    await firestore.collection('task').doc(taskId).delete().onError(
        (error, stackTrace) =>
            throw Failure('There was a problem deleting the task'));
  }

  ///Sends to [CalendarClient] the relative information to schedule a Calendar element on attendees specified on the form
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
