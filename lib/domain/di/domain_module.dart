import 'package:flutter_template/domain/datetime/date_in_millis_use_case.dart';
import 'package:flutter_template/domain/datetime/date_in_millis_use_case_impl.dart';
import 'package:flutter_template/domain/datetime/format_date_use_case.dart';
import 'package:flutter_template/domain/datetime/format_date_use_case_impl.dart';
import 'package:flutter_template/domain/theme/get_is_dynamic_theme_enabled.dart';
import 'package:flutter_template/domain/theme/get_is_dynamic_theme_enabled_impl.dart';
import 'package:flutter_template/domain/theme/get_theme_mode_use_case.dart';
import 'package:flutter_template/domain/theme/get_theme_mode_use_case_impl.dart';
import 'package:flutter_template/domain/theme/set_is_dynamic_theme_enabled.dart';
import 'package:flutter_template/domain/theme/set_is_dynamic_theme_enabled_impl.dart';
import 'package:flutter_template/domain/theme/set_theme_mode_use_case.dart';
import 'package:flutter_template/domain/theme/set_theme_mode_use_case_impl.dart';

import 'package:get_it/get_it.dart';

extension DomainModule on GetIt {
  void domainModule() {


    // date
    registerFactory<DateInMillisUseCase>(() => DateInMillisUseCaseImpl(
          dateRepository: get(),
        ));

    registerFactory<FormatDateUseCase>(() => FormatDateUseCaseImpl(
          dateRepository: get(),
        ));

    // theme
    registerFactory<SetThemeModeUseCase>(() => SetThemeModeUseCaseImpl(
          themeRepository: get(),
        ));

    registerFactory<GetThemeModeUseCase>(() => GetThemeModeUseCaseImpl(
          themeRepository: get(),
        ));

    registerFactory<SetIsDynamicThemeEnabled>(
        () => SetIsDynamicThemeEnabledImpl(
              themeRepository: get(),
            ));

    registerFactory<GetIsDynamicThemeEnabled>(
        () => GetIsDynamicThemeEnabledImpl(
              themeRepository: get(),
            ));
  }
}
