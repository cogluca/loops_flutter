
import 'package:get_storage/get_storage.dart';
import 'package:loops/base/base_view.dart';
import 'package:get_it/get_it.dart';


GetIt locator = GetIt.instance;

void setLocator(){

  //allows globally accessible services while maintaining in an easy to unit test manner, in this case I'm using it for VMs
  locator.registerLazySingleton<GetStorage>(() => GetStorage());

}