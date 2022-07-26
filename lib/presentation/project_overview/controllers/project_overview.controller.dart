import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/repository/project_repository.dart';

import '../../../model/Sprint.dart';
import '../../home/controllers/home.controller.dart';

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

  String projectStartDateConstraint = " ";
  String projectEndDateConstraint = " ";

  late DateTime projectWideTemporalConstraint;

  var homeController = Get.put(HomeController());

  @override
  void onInit() {
    super.onInit();
    projectStartDateConstraint =
        Get.find<GetStorage>().read('projectStartDate');
    projectEndDateConstraint = Get.find<GetStorage>().read('projectEndDate');
  }

  @override
  void onReady() {
    super.onReady();
    retrieveSprints();
    retrieveCurrentSprint();
  }

  @override
  void onClose() {}

  void setScreenTitle() {
    screenTitle = getStorage.read('choosenProjectName');
  }

  ///Retrieves a list of Sprint objects that comprise their underlying tasks.
  ///Returns a Stream of type List<Sprint>.
  ///Subsequently updates the observable value which in turn notifies the observes UI component.

  Stream<List<Sprint>> retrieveSprints() async* {
    String projectId = getStorage.read('choosenProject');

    List<Sprint> retrievedSprints =
        await projectRepository.retrieveSprint(projectId: projectId);

    dataFromSprints.assignAll(retrievedSprints);

    update();

    yield* Stream.periodic(const Duration(seconds: 3), (_) {
      return projectRepository.retrieveSprint(projectId: projectId);
    }).asyncMap((value) async => await value);

    update();
  }

  /// Retrieves Sprint object according to which one a local storage state manager defines as current.
  /// Subsequently updates the observable value [currentSprint] which in turn notifies the observes UI component through the [update] method

  Future<void> retrieveCurrentSprint() async {

    late Sprint retrievedSprint;

    String hasCurrentSprint = Get.find<GetStorage>().read('hasCurrentSprint');
    String currentSprintId = Get.find<GetStorage>().read('currentProjectSprintId');

    print("has current sprint value is : $hasCurrentSprint");

    if (hasCurrentSprint != "false") {
      retrievedSprint =
          await projectRepository.retrieveCurrentSprint(currentSprintId);
      currentSprint.add(retrievedSprint);
    }

    update();
  }

  ///Deactives current sprint, this can mean semantically both having a sprint finished or ending it prematurely, through repository call updates the storage contained sprint document value
  ///to completed.
  ///Subsequently notifies and updates the UI component listening to the [currentSprint] variable
  Future<void> turnSprintOff() async {
    await projectRepository.turnSprintOff();
    currentSprint.clear();

    update();
  }

  ///Starts a sprint, meaning constructs the object from text controllers, default values and local storage and calls the repository method to create a document in the storage with
  ///such data
  Future<void> startSprint() async {
    String projectId = getStorage.read('choosenProject');

    Sprint sprintStarted = Sprint(
        '', sprintStartDate.text, sprintEndDate.text, [], false, projectId);

    //DateTime projectWideStartDateConstraint = DateTime.parse(projectStartDateConstraint.value);
    //print("VALUE OF DATETIME IS${projectWideStartDateConstraint.toString()}");
    getStorage.write('hasCurrentSprint', 'true');

    await projectRepository.startASprint(sprintStarted);
    String currentSprintId =
        Get.find<GetStorage>().read('currentProjectSprintId');
    currentSprint
        .add(await projectRepository.retrieveCurrentSprint(currentSprintId));

    update();
  }

  ///Sends an invite to collaborate by retrieving from text controllers, boolean choices and enumerators the necessary data, calls the relative repository method handling such case
  Future<void> sendGoogleMeetInvite() async {
    List<String> attendants = extractEmailsFromString();
    DateTime meetingStartsAt = extractDate(
        meetingDate: meetingDate.text, meetingTime: meetingStartTime.text);
    DateTime meetingEndsAt = extractDate(
        meetingDate: meetingDate.text, meetingTime: meetingEndTime.text);
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
