// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:route_ecommerce/core/di/app_module.dart' as _i1031;
import 'package:route_ecommerce/core/l10n/locale_provider.dart' as _i441;
import 'package:route_ecommerce/core/theme/app_colors.dart' as _i536;
import 'package:route_ecommerce/core/theme/app_theme.dart' as _i1001;
import 'package:route_ecommerce/features/auth/data/data_source/auth_api_client.dart'
    as _i419;
import 'package:route_ecommerce/features/auth/data/mapper/auth_mapper.dart'
    as _i1015;
import 'package:route_ecommerce/features/auth/data/repo/auth_repo_impl.dart'
    as _i146;
import 'package:route_ecommerce/features/auth/domain/repo/auth_repo.dart'
    as _i162;
import 'package:route_ecommerce/features/auth/domain/use_cases/login_use_case.dart'
    as _i1003;
import 'package:route_ecommerce/features/auth/domain/use_cases/register_use_case.dart'
    as _i679;
import 'package:route_ecommerce/features/auth/presentation/login/view/login_cubit.dart'
    as _i818;
import 'package:route_ecommerce/features/auth/presentation/register/view/register_cubit.dart'
    as _i859;
import 'package:route_ecommerce/features/splash/data/data_source/splash_local_data_source.dart'
    as _i557;
import 'package:route_ecommerce/features/splash/data/repo/splash_repo_impl.dart'
    as _i999;
import 'package:route_ecommerce/features/splash/domain/repo/splash_repo.dart'
    as _i392;
import 'package:route_ecommerce/features/splash/domain/use_cases/check_token_use_case.dart'
    as _i921;
import 'package:route_ecommerce/features/splash/presentation/view/splash_cubit.dart'
    as _i135;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i1015.AuthMapper>(() => _i1015.AuthMapper());
    gh.lazySingleton<_i361.Dio>(() => appModule.provideDio());
    gh.lazySingleton<_i536.AppColors>(() => _i536.LightColors());
    gh.factory<_i557.SplashLocalDataSource>(
      () => _i557.SplashLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i419.AuthApiClient>(() => _i419.AuthApiClient(gh<_i361.Dio>()));
    gh.factory<_i392.SplashRepo>(
      () => _i999.SplashRepoImpl(gh<_i557.SplashLocalDataSource>()),
    );
    gh.factory<_i162.AuthRepo>(
      () => _i146.AuthRepoImpl(
        gh<_i419.AuthApiClient>(),
        gh<_i1015.AuthMapper>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i441.LocaleProvider>(
      () => _i441.LocaleProvider(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i1003.LoginUseCase>(
      () => _i1003.LoginUseCase(gh<_i162.AuthRepo>()),
    );
    gh.factory<_i679.RegisterUseCase>(
      () => _i679.RegisterUseCase(gh<_i162.AuthRepo>()),
    );
    gh.factory<_i921.CheckTokenUseCase>(
      () => _i921.CheckTokenUseCase(gh<_i392.SplashRepo>()),
    );
    gh.factory<_i135.SplashCubit>(
      () => _i135.SplashCubit(gh<_i921.CheckTokenUseCase>()),
    );
    gh.lazySingleton<_i1001.AppTheme>(
      () => _i1001.AppTheme(gh<_i536.AppColors>()),
    );
    gh.factory<_i818.LoginCubit>(
      () => _i818.LoginCubit(gh<_i1003.LoginUseCase>()),
    );
    gh.factory<_i859.RegisterCubit>(
      () => _i859.RegisterCubit(gh<_i679.RegisterUseCase>()),
    );
    return this;
  }
}

class _$AppModule extends _i1031.AppModule {}
