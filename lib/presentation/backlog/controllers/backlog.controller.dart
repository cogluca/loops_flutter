import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/presentation/project_overview/controllers/project_overview.controller.dart';
import 'package:loops/repository/backlog_repository.dart';
import 'package:loops/presentation/home/controllers/home.controller.dart';

import '../../../model/Task.dart';

class BacklogController extends GetxController {
  BacklogRepository backlogRepository = BacklogRepository();
  RxList<Task> listOfProjectTasks = <Task>[].obs;

  TextEditingController createdNewTask = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController sprintId = TextEditingController();
  TextEditingController oneLiner = TextEditingController();
  TextEditingController fullDescription = TextEditingController();
  TextEditingController storyPoints = TextEditingController();
  TextEditingController teamAssigned = TextEditingController();
  RxBool assignToSprintState = false.obs;

  RxString meetingType = 'One-To-One'.obs;
  RxBool conferenceSupportState = false.obs;
  RxBool notifyAttendantsState = false.obs;
  TextEditingController emailsOnForm = TextEditingController();
  TextEditingController meetingStartTime = TextEditingController();
  TextEditingController meetingEndTime = TextEditingController();
  TextEditingController locationOfMeeting = TextEditingController();
  TextEditingController meetingDescription = TextEditingController();
  TextEditingController meetingDate = TextEditingController();

  var homeController = Get.put(HomeController());



  @override
  void onInit() {
    super.onInit();
    retrieveTasksOfProject();
    Get.put(ProjectOverviewController());
  }

  @override
  void onReady() {
    super.onReady();

  }

  @override
  void onClose() {}

  ///Does first fast retrieve of tasks belonging to a project for initial display
  Future<void> firstTaskListRetrieve() async {
    String projectId = Get.find<HomeController>().currentProjectId;

    List<Task> computedTasks =
        await backlogRepository.retrieveCompleteTasks(projectId);
    listOfProjectTasks.addAll(computedTasks);
  }

  ///Retrieves a list of tasks through a stream method by calling a [retrieveCompleteTasks] method belonging to the backlog repository.
  ///Returns such Stream to the caller
  Stream<List<Task>> retrieveTasksOfProject() async* {
    String projectId = Get.find<HomeController>().currentProjectId;

    yield* Stream.periodic(const Duration(seconds: 3), (_) {
      return backlogRepository.retrieveCompleteTasks(projectId);
    }).asyncMap((value) async => await value);
  }

  ///Retrieves a list of tasks belonging to the current Sprint through a stream method by calling a [retrieveCurrentTasksOfSprint] method belonging to the backlog repository.
  ///Returns such Stream to the caller
  Stream<List<Task>> retrieveCurrentTasksOfSprint() async* {
    String projectId = Get.find<HomeController>().currentProjectId;



    yield* Stream.periodic(const Duration(seconds: 3), (_) {
      return backlogRepository.retrieveCurrentSprintTasks(projectId);
    }).asyncMap((value) async => await value);
  }

  /// Saves a newly created task by retrieving from text controllers, local storage its instance variables, incapsulates them into a task and calls on the
  /// repository method relative to the task
  Future<void> saveNewlyCreatedTask() async {
    String currentSprintId = "";
    String projectId = homeController.currentProjectId;
    int position = Get.find<GetStorage>().read('completeBacklogTasks');

    if (assignToSprintState.value == true) {
      currentSprintId = Get.find<GetStorage>().read('currentProjectSprintId');
      position = Get.find<GetStorage>().read('sprintBacklogTasks');
    }

    Task newTask = Task(
        ' ',
        createdNewTask.text,
        projectId,
        'epicId',
        'teamId',
        'teamMemberId',
        startDate.text,
        endDate.text,
        oneLiner.text,
        fullDescription.text,
        currentSprintId,
        int.parse(storyPoints.text),
        false,
        ' ',
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        position);

    await backlogRepository.addNewTask(newTask);
  }

  ///Saves the new task positioning
  Future<void> saveNewTaskPositions(List<Task> reorderedList) async {
    await backlogRepository.reorderTasks(reorderedList);
  }

  ///Marks a task as complete
  Future<void> markTaskAsCompleted(String taskId) async {
    await backlogRepository.markTaskAsCompleted(taskId);
  }

  ///Deletes a task
  Future<void> deleteTask(String taskId) async {
    await backlogRepository.deleteTask(taskId);
  }

  ///Sends an invite to collaborate by retrieving from text controllers, boolean choices and enumerators the necessary data, calls the relative repository method handling such case
  Future<void> sendGoogleMeetInvite() async {
    List<String> attendants = extractEmailsFromString();
    DateTime meetingStartsAt = extractDate(meetingDate: meetingDate.text, meetingTime: meetingStartTime.text);
    DateTime meetingEndsAt = extractDate(meetingDate: meetingDate.text, meetingTime: meetingEndTime.text);
    String location = locationOfMeeting.text;
    bool conferenceSupport = conferenceSupportState.value;
    bool notifyAttendants = notifyAttendantsState.value;
    String briefMeetingDescription = meetingDescription.text;
    String typeOfMeeting = meetingType.value;

    print(notifyAttendants);

    await backlogRepository.sendMeetingInvite(
        meetingTitle: typeOfMeeting,
        meetingDescription: briefMeetingDescription,
        meetingLocation: location,
        attendees: attendants,
        nofityAttendees: notifyAttendants,
        conferenceSupport: conferenceSupport,
        meetingBeginning: meetingStartsAt,
        meetingEnding: meetingEndsAt);
  }

  ///extracts email addressed from string and stores them in [emails]
  List<String> extractEmailsFromString() {
    String emailsToParse = emailsOnForm.text;

    final emailPattern = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b',
        caseSensitive: false, multiLine: true);
    final matches = emailPattern.allMatches(emailsToParse);
    final List<String> emails = [];
    if (matches.isNotEmpty) {
      for (final Match match in matches) {
        emails.add(emailsToParse.substring(match.start, match.end));
      }
    }

    return emails;
  }

  ///Manipulates and combines [meetingDate] and [meetingTime] into a format that the underlying Calendar Client can understand
  DateTime extractDate(
      {required String meetingDate, required String meetingTime}) {
    String dateTimeToExtract = meetingDate + " " + meetingTime + ":00";
    DateTime endDate = DateTime.parse(dateTimeToExtract);

    return endDate;
  }
}
