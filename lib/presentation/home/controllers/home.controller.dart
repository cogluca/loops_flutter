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

  GetStorage getStorage = Get.find<GetStorage>();
  int currentProjectId = 0;

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

  Future<void> getProjects() async {

    List<Project> recentReceivedProjects = await homeRepository.getProjects();

    List<Project> projectsList = await homeRepository.getProjects();

    listOfProjects.addAll(recentReceivedProjects);

    update();

    //repository call to fetch the projects
  }

  void writeAndSetProjectIdOnStorage(int id) {
    getStorage.write('choosenProject', id);
    currentProjectId = id;
  }


  void navigateToBacklog(int id) {
    writeAndSetProjectIdOnStorage(id);
    Get.toNamed('/backlog');
  }

}
