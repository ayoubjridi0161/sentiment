import 'package:flutter_template/presentation/base/theme/theme_view_model.dart';
import 'package:flutter_template/presentation/base/theme/theme_view_model_impl.dart';

import 'package:get_it/get_it.dart';

extension PresentationModule on GetIt {
  void presentationModule() {


    // theme
    registerFactory<ThemeViewModel>(() => ThemeViewModelImpl(
          themeInteractor: get(),
        ));
  }
}
