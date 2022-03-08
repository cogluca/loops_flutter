import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loops/repository/login_repository.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxString username = ''.obs;
  RxString emailOnScreen = ''.obs;
  RxString imageUrl = ''.obs;

  LoginRepository loginRepository = LoginRepository();

  @override
  void onInit() {
    super.onInit();
    userNameSetter();
    eMailSetter();
    imageUrlSetter();
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


}
