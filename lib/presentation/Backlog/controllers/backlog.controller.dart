import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  @override
  void onInit() {
    super.onInit();
    retrieveTasksOfProject();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> firstTaskListRetrieve() async {
    String projectId = Get
        .find<HomeController>()
        .currentProjectId;

    List<Task> computedTasks = await backlogRepository.retrieveCompleteTasks(
        projectId);
    listOfProjectTasks.addAll(computedTasks);
  }

  Stream<List<Task>> retrieveTasksOfProject() async* {
    String projectId = Get
        .find<HomeController>()
        .currentProjectId;

    yield* Stream.periodic(const Duration(seconds: 3), (_) {
      return backlogRepository.retrieveCompleteTasks(projectId);
    }).asyncMap((value) async => await value);
  }

  Stream<List<Task>> retrieveCurrentTasksOfSprint() async* {
    String projectId = Get
        .find<HomeController>()
        .currentProjectId;

    yield* Stream.periodic(const Duration(seconds: 3), (_) {
      return backlogRepository.retrieveCurrentSprintTasks(projectId);
    }).asyncMap((value) async => await value);
  }


  Future<void> saveNewlyCreatedTask() async {
    String currentSprintId = "";
    String projectId = Get
        .find<HomeController>()
        .currentProjectId;
    int position = Get.find<GetStorage>().read('completeBacklogTasks');

    if (assignToSprintState.value == true) {
      currentSprintId = Get.find<GetStorage>().read('currentProjectSprintId');
      position = Get.find<GetStorage>().read('sprintBacklogTasks');
    }

    Task newTask = Task(id: '',
        name: createdNewTask.text,
        projectId: projectId,
        epicId: 'epicId',
        teamId: 'teamId',
        teamMemberId: 'teamMemberId',
        startDate: startDate.text,
        endDate: endDate.text,
        oneLiner: oneLiner.text,
        fullDescription: fullDescription.text,
        sprintId: currentSprintId,
        storyPoints: int.parse(storyPoints.text),
        completed: false,
        dateCompletion: '',
        dateInsertion: '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        order: position);


    await
    backlogRepository.addNewTask(
        newTask);
  }

  Future<void> saveNewTaskPositions(List<Task> reorderedList) async {
    await backlogRepository.reorderTasks(reorderedList);
  }

  Future<void> markTaskAsCompleted(String taskId) async {
    await backlogRepository.markTaskAsCompleted(taskId);
  }

  Future<void> deleteTask(String taskId) async {
    await backlogRepository.deleteTask(taskId);
  }

  Future<void> sendGoogleMeetInvite() async {
    List<String> attendants = extractEmailsFromString();
    DateTime meetingStartsAt = extractStartDate();
    DateTime meetingEndsAt = extractEndDate();
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

  DateTime extractStartDate() {
    String dateTimeToExtract =
        meetingDate.text + " " + meetingStartTime.text + ":00";
    DateTime startDate = DateTime.parse(dateTimeToExtract);

    return startDate;
  }

  DateTime extractEndDate() {
    String dateTimeToExtract =
        meetingDate.text + " " + meetingEndTime.text + ":00";
    DateTime endDate = DateTime.parse(dateTimeToExtract);

    return endDate;
  }
}
