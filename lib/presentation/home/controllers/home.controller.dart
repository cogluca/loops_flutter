import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/model/Sprint.dart';
import 'package:loops/presentation/login/controllers/login.controller.dart';
import 'package:loops/repository/home_repository.dart';
import 'package:loops/repository/login_repository.dart';
import 'package:loops/model/Project.dart';

import '../../../model/AppUser.dart';

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

  ///Retrieves username from local storage and changes the username in the observable value

  @override
  void userNameSetter() {
    Map userMap = Get.find<GetStorage>().read('user');
    changeUsername(RxString(userMap['user'].toString()));
  }

  ///Retrieves email from local storage and changes the email in the observable value
  void eMailSetter() {
    Map userMap = Get.find<GetStorage>().read('user');
    changeEmail(RxString(userMap['email'].toString()));
  }

  ///Sets the Google account avatar URL to its correspondent value after login, this allows to connect to the account and retrieve its avatar
  void imageUrlSetter() {
    Map userMap = Get.find<GetStorage>().read('user');
    changeImgUrl(RxString(userMap['imageUrl'].toString()));
  }

  ///Calls the logout repository method allowing signing off from the application and integrated firebase authentication previously done
  Future<void> logOut() async {
    await loginRepository.signOut();
  }


  ///Calls first for an instant retrieval the [getProjects] method on correspondent repository subsequently every three seconds yields the results of the same repository method
  ///in order to update the Stream returned by this method
  Stream<List<Project>> getProjects() async* {

    List<Project> recentReceivedProjects = await homeRepository.getProjects();

    listOfProjects.addAll(recentReceivedProjects);

    update();

    yield* Stream.periodic(const Duration(seconds: 2), (_) {
      return homeRepository.getProjects();
    }).asyncMap((value) async => await value);

    //repository call to fetch the projects
  }

  ///writes on local storage the id of a project that has been double tapped on and sets also its relative name
  void writeAndSetProjectOnStorage(String id, String projectName, String projectStartDate, String projectEndDate, String currentSprint) {
    getStorage.write('choosenProject', id);
    getStorage.write('choosenProjectName', projectName);
    getStorage.write('projectStartDate', projectStartDate);
    getStorage.write('projectEndDate', projectEndDate);
    getStorage.write('hasCurrentSprint', currentSprint );
    currentProjectId = id;
  }

  ///writes the current project's current sprint id onto local storage
  void writeProjectCurrentSprint(String currentSprintId) {
    getStorage.write('currentProjectSprintId', currentSprintId);
  }

  ///Combines text controllers and default values in a Project objects and sends it over to the correspondent repository method for document storage
  Future<void> saveNewlyCreatedProject() async {

    AppUser loggedInUser = Get.find<LoginController>().loggedInUser;
    
    Project toSaveProject = Project('', createdNewProject.text, loggedInUser.userUid , oneLiner.text, newStartDate.text, newEndDate.text, 0, 0, '', projectGoal.text);
    
    await homeRepository.saveNewlyCreatedProject(projectToBeSaved: toSaveProject);
  }

  ///Makes use of the Get framework underlying navigation infrastracture to move to the Backlog Screen
  void navigateToBacklog(Project project) {
    writeAndSetProjectOnStorage(project.id, project.name, project.startDate, project.endDate, project.currentSprintId);
    Get.toNamed('/backlog');
  }

  ///Makes use of the Get framework underlying navigation infrastracture to move to the project overview Screen
  void navigateToProjectScreen(Project project) {
    writeAndSetProjectOnStorage(project.id, project.name, project.startDate, project.endDate, project.currentSprintId);
    writeProjectCurrentSprint(project.currentSprintId);
    Get.toNamed('/project-overview', parameters: project.toDynamic());
  }

  void markProjectAsCompleted(String id) async{

    await homeRepository.markProjectAsCompleted(id: id);

  }

  void deleteProject(String id) async{

    await homeRepository.deleteProject(id: id);

  }

}
