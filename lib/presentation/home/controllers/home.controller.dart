import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/model/Sprint.dart';
import 'package:loops/repository/home_repository.dart';
import 'package:loops/repository/login_repository.dart';
import 'package:loops/model/Project.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxString username = ''.obs;
  RxString emailOnScreen = ''.obs;
  RxString imageUrl = ''.obs;

  RxList<Project> listOfProjects = <Project>[].obs;

  LoginRepository loginRepository = LoginRepository();
  HomeRepository homeRepository = HomeRepository();

  TextEditingController createdNewProject = TextEditingController();
  TextEditingController newStartDate = TextEditingController();
  TextEditingController newEndDate = TextEditingController();
  TextEditingController oneLiner = TextEditingController();
  TextEditingController projectGoal = TextEditingController();

  GetStorage getStorage = Get.find<GetStorage>();
  String currentProjectId = '';

  @override
  void onInit() {
    super.onInit();
    userNameSetter();
    eMailSetter();
    imageUrlSetter();
    getProjects();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void changeUsername(RxString usr) => username = usr;

  void changeEmail(RxString email) => emailOnScreen = email;

  void changeImgUrl(RxString usrImage) => imageUrl = usrImage;

  @override
  void userNameSetter() {
    Map userMap = Get.find<GetStorage>().read('user');
    changeUsername(RxString(userMap['user'].toString()));
  }

  void eMailSetter() {
    Map userMap = Get.find<GetStorage>().read('user');
    changeEmail(RxString(userMap['email'].toString()));
  }

  void imageUrlSetter() {
    Map userMap = Get.find<GetStorage>().read('user');
    changeImgUrl(RxString(userMap['imageUrl'].toString()));
  }

  @override
  void onTap() {
    Map userMap = Get.find<GetStorage>().read('user');
  }

  Future<void> logOut() async {
    await loginRepository.signOut();
  }

  Stream<List<Project>> getProjects() async* {
    //tODO see if deleting first 3 lines doesn't cause disappearance of data

    List<Project> recentReceivedProjects = await homeRepository.getProjects();

    listOfProjects.addAll(recentReceivedProjects);

    update();

    yield* Stream.periodic(const Duration(seconds: 2), (_) {
      return homeRepository.getProjects();
    }).asyncMap((value) async => await value);

    //repository call to fetch the projects
  }

  void writeAndSetProjectIdOnStorage(String id, String projectName) {
    getStorage.write('choosenProject', id);
    getStorage.write('choosenProjectName', projectName);
    currentProjectId = id;
  }

  void writeProjectCurrentSprint(String currentSprintId) {
    getStorage.write('currentProjectSprintId', currentSprintId);
  }

  Future<void> saveNewlyCreatedProject() async {
    await homeRepository.saveNewlyCreatedProject(
        name: createdNewProject.text,
        projectGoal: projectGoal.text,
        oneLiner: oneLiner.text,
        startDate: newStartDate.text,
        endDate: newEndDate.text);
  }

  void navigateToBacklog(String id, projectName) {
    writeAndSetProjectIdOnStorage(id, projectName);
    Get.toNamed('/backlog');
  }

  void navigateToProjectScreen(String id, String projectName, Project project) {
    writeAndSetProjectIdOnStorage(id, projectName);
    writeProjectCurrentSprint(project.currentSprintId!);
    Get.toNamed('/project-overview', parameters: project.toJson());
  }
}
