import 'package:loops/viewmodel/sign_in_view_model.dart';
import 'package:loops/viewmodel/home_screen_view_model.dart';
import 'package:loops/base/base_view.dart';
import 'package:get_it/get_it.dart';


GetIt locator = GetIt.instance;

void setLocator(){

  //allows globally accessible services while maintaining in an easy to unit test manner, in this case I'm using it for VMs


  locator.registerLazySingleton<BaseView>(() => SignInViewModel());
  locator.registerLazySingleton<BaseView>(() => HomeViewModel());


}