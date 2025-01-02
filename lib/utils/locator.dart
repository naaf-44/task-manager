import 'package:get_it/get_it.dart';
import 'package:task_manager/utils/shared_preference_handler.dart';

final GetIt getIt = GetIt.instance;

void locator(){
  getIt.registerLazySingleton<SharedPreferenceHandler>(SharedPreferenceHandler.new);
}