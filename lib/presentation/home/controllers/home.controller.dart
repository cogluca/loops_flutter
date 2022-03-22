import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/presentation/home/repository/home_repository.dart';
import 'package:loops/presentation/login/repository/login_repository.dart';
import 'package:loops/models/Project.dart';

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
  void userNameSetter(){
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
  void onTap(){
    Map userMap = Get.find<GetStorage>().read('user');
    print(userMap['email'].toString());
  }

  Future<void> logOut() async {
    await loginRepository.signOut();
    Get.find<GetStorage>().erase();
  }



  Stream<List<Project>> getProjects() async* {

    //tODO see if deleting first 3 lines doesn't cause disappearance of data

    List<Project> recentReceivedProjects = await homeRepository.getProjects();

    listOfProjects.addAll(recentReceivedProjects);

    update();

    yield* Stream.periodic(const Duration(seconds: 5), (_) {
      return homeRepository.getProjects();
    }).asyncMap((value) async => await value);



    //repository call to fetch the projects
  }

  void writeAndSetProjectIdOnStorage(String id) {
    getStorage.write('choosenProject', id);
    currentProjectId = id;
  }


  Future<void> saveNewlyCreatedProject() async {

    await homeRepository.saveNewlyCreatedProject(createdNewProject.text, newStartDate.text, newEndDate.text);

  }


  void navigateToBacklog(String id) {
    writeAndSetProjectIdOnStorage(id);
    Get.toNamed('/backlog');
  }

}
