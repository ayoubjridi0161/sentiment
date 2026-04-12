import 'package:flutter_template/navigation/base/app_router.dart';
import 'package:flutter_template/navigation/base/base_navigator.dart';
import 'package:flutter_template/navigation/base/base_navigator_impl.dart';

import 'package:get_it/get_it.dart';

extension NavigationModule on GetIt {
  void navigationModule() {
    // router
    registerLazySingleton(() => AppRouter());

    // base
    registerFactory<BaseNavigator>(() => BaseNavigatorImpl(appRouter: get()));


  }
}
