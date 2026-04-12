import 'package:flutter_template/interactor/theme/theme_interactor.dart';
import 'package:flutter_template/interactor/theme/theme_interactor_impl.dart';
import 'package:flutter_template/interactor/theme/theme_mode_mapper.dart';

import 'package:get_it/get_it.dart';

extension InteractorModule on GetIt {
  void interactorModule() {


    // theme
    registerFactory<ThemeModeMapper>(() => ThemeModeMapperImpl());

    registerFactory<ThemeInteractor>(() => ThemeInteractorImpl(
          setThemeModeUseCase: get(),
          getThemeModeUseCase: get(),
          setIsDynamicThemeEnabled: get(),
          getIsDynamicThemeEnabled: get(),
          themeModeMapper: get(),
        ));
  }
}
