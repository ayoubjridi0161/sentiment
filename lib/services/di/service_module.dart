import 'package:flutter_template/flavors/flavor_config.dart';
import 'package:flutter_template/services/base/database/app_database.dart';
import 'package:flutter_template/services/base/di/dio_provider.dart';

import 'package:flutter_template/services/preferences/preferences_service.dart';
import 'package:flutter_template/services/preferences/preferences_service_impl.dart';

import 'package:get_it/get_it.dart';

extension ServiceModule on GetIt {
  void serviceModule() {
    // Dio
    registerLazySingleton(
      () => provideDio(
        interceptors: [],
      ),
    );

    // Drift
    registerLazySingleton<AppDatabase>(() => connect());

    // Shared Preferences
    registerLazySingleton<PreferencesService>(() => PreferencesServiceImpl(
          sharedPreferences: get(),
        ));


  }
}
