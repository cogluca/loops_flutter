import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/repository/project_repository.dart';

import '../../../model/Sprint.dart';

class ProjectOverviewController extends GetxController {
  //TODO: Implement ProjectOverviewController

  final count = 0.obs;
  GetStorage getStorage = Get.find<GetStorage>();

  String screenTitle = '';

  RxList<Sprint> dataFromSprints = <Sprint>[].obs;
  RxList<Sprint> currentSprint = RxList<Sprint>([]);
  RxList<Sprint> dataFromSprintsMock = <Sprint>[].obs;


  ProjectRepository projectRepository = ProjectRepository();


  TextEditingController sprintStartDate = TextEditingController();
  TextEditingController sprintEndDate = TextEditingController();

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
  }

  @override
  void onReady() {
    super.onReady();
    retrieveSprints();
    retrieveCurrentSprint();
  }

  @override
  void onClose() {}

  void increment() => count.value++;

  void setScreenTitle() {
    screenTitle = getStorage.read('choosenProjectName');
  }

  Stream<List<Sprint>> retrieveSprints() async* {
    List<Sprint> retrievedSprints = await projectRepository.retrieveSprint();

    dataFromSprints.assignAll(retrievedSprints);

    update();

    yield* Stream.periodic(const Duration(seconds: 3), (_) {
      return projectRepository.retrieveSprint();
    }).asyncMap((value) async => await value);

    update();
  }

  Future<void> retrieveCurrentSprint() async {

    String currentSprintId = '';
    late Sprint retrievedSprint;

    currentSprintId =
        Get.find<GetStorage>().read('currentProjectSprintId');

    if(currentSprintId != '' || currentSprintId != null) {
      retrievedSprint =
      await projectRepository.retrieveCurrentSprint(currentSprintId);
    }
    currentSprint.add(retrievedSprint);

    update();
  }

  Future<void> turnSprintOff() async {

    await projectRepository.turnSprintOff();
    currentSprint.clear();

    update();

  }

  Future<void> startSprint() async {



    await projectRepository.startASprint(sprintStartDate.text, sprintEndDate.text);
    String currentSprintId = Get.find<GetStorage>().read('currentProjectSprintId');
    currentSprint.add(await projectRepository.retrieveCurrentSprint(currentSprintId));

    update();
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

    await projectRepository.sendMeetingInvite(
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
    print(dateTimeToExtract);
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
