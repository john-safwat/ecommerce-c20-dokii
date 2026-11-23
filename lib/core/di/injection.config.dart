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
import 'package:route_ecommerce/core/network/token_interceptor.dart' as _i33;
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
import 'package:route_ecommerce/features/commerce/data/data_source/commerce_api_client.dart'
    as _i385;
import 'package:route_ecommerce/features/commerce/data/data_source/commerce_local_data_source.dart'
    as _i267;
import 'package:route_ecommerce/features/commerce/data/mapper/commerce_mapper.dart'
    as _i1039;
import 'package:route_ecommerce/features/commerce/data/repo/commerce_repo_impl.dart'
    as _i478;
import 'package:route_ecommerce/features/commerce/domain/repo/commerce_repo.dart'
    as _i858;
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_banners_use_case.dart'
    as _i1006;
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_categories_use_case.dart'
    as _i940;
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_home_data_use_case.dart'
    as _i360;
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_paginated_products_use_case.dart'
    as _i763;
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_product_details_use_case.dart'
    as _i534;
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_products_use_case.dart'
    as _i638;
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_sub_categories_use_case.dart'
    as _i980;
import 'package:route_ecommerce/features/commerce/presentation/categories/categories_cubit.dart'
    as _i229;
import 'package:route_ecommerce/features/commerce/presentation/home/home_cubit.dart'
    as _i52;
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_cubit.dart'
    as _i150;
import 'package:route_ecommerce/features/commerce/presentation/products_list/products_list_cubit.dart'
    as _i834;
import 'package:route_ecommerce/features/orders/data/datasource/orders_api_client.dart'
    as _i421;
import 'package:route_ecommerce/features/orders/data/mapper/orders_mapper.dart'
    as _i364;
import 'package:route_ecommerce/features/orders/data/repo/orders_repo_impl.dart'
    as _i826;
import 'package:route_ecommerce/features/orders/domain/repo/orders_repo.dart'
    as _i420;
import 'package:route_ecommerce/features/orders/domain/use_cases/add_to_cart_use_case.dart'
    as _i1015;
import 'package:route_ecommerce/features/orders/domain/use_cases/create_cash_order_use_case.dart'
    as _i740;
import 'package:route_ecommerce/features/orders/domain/use_cases/create_checkout_session_use_case.dart'
    as _i225;
import 'package:route_ecommerce/features/orders/domain/use_cases/get_user_cart_use_case.dart'
    as _i682;
import 'package:route_ecommerce/features/orders/domain/use_cases/remove_from_cart_use_case.dart'
    as _i676;
import 'package:route_ecommerce/features/orders/domain/use_cases/update_cart_use_case.dart'
    as _i915;
import 'package:route_ecommerce/features/orders/presentation/cart/cart_cubit.dart'
    as _i661;
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
    gh.factory<_i1039.CommerceMapper>(() => _i1039.CommerceMapper());
    gh.factory<_i364.OrdersMapper>(() => _i364.OrdersMapper());
    gh.factory<_i267.CommerceLocalDataSource>(
      () => _i267.CommerceLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i536.AppColors>(() => _i536.LightColors());
    gh.factory<_i557.SplashLocalDataSource>(
      () => _i557.SplashLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i392.SplashRepo>(
      () => _i999.SplashRepoImpl(gh<_i557.SplashLocalDataSource>()),
    );
    gh.lazySingleton<_i441.LocaleProvider>(
      () => _i441.LocaleProvider(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i921.CheckTokenUseCase>(
      () => _i921.CheckTokenUseCase(gh<_i392.SplashRepo>()),
    );
    gh.lazySingleton<_i33.TokenInterceptor>(
      () => _i33.TokenInterceptor(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i135.SplashCubit>(
      () => _i135.SplashCubit(gh<_i921.CheckTokenUseCase>()),
    );
    gh.lazySingleton<_i1001.AppTheme>(
      () => _i1001.AppTheme(gh<_i536.AppColors>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => appModule.provideDio(gh<_i33.TokenInterceptor>()),
    );
    gh.singleton<_i421.OrdersApiClient>(
      () => _i421.OrdersApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i419.AuthApiClient>(() => _i419.AuthApiClient(gh<_i361.Dio>()));
    gh.factory<_i385.CommerceApiClient>(
      () => _i385.CommerceApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i162.AuthRepo>(
      () => _i146.AuthRepoImpl(
        gh<_i419.AuthApiClient>(),
        gh<_i1015.AuthMapper>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i1003.LoginUseCase>(
      () => _i1003.LoginUseCase(gh<_i162.AuthRepo>()),
    );
    gh.factory<_i679.RegisterUseCase>(
      () => _i679.RegisterUseCase(gh<_i162.AuthRepo>()),
    );
    gh.factory<_i858.CommerceRepo>(
      () => _i478.CommerceRepoImpl(
        gh<_i385.CommerceApiClient>(),
        gh<_i267.CommerceLocalDataSource>(),
        gh<_i1039.CommerceMapper>(),
      ),
    );
    gh.factory<_i763.GetPaginatedProductsUseCase>(
      () => _i763.GetPaginatedProductsUseCase(gh<_i858.CommerceRepo>()),
    );
    gh.factory<_i534.GetProductDetailsUseCase>(
      () => _i534.GetProductDetailsUseCase(gh<_i858.CommerceRepo>()),
    );
    gh.factory<_i834.ProductsListCubit>(
      () => _i834.ProductsListCubit(gh<_i763.GetPaginatedProductsUseCase>()),
    );
    gh.factory<_i420.OrdersRepo>(
      () => _i826.OrdersRepoImpl(
        gh<_i421.OrdersApiClient>(),
        gh<_i364.OrdersMapper>(),
      ),
    );
    gh.factory<_i150.ProductDetailsCubit>(
      () => _i150.ProductDetailsCubit(gh<_i534.GetProductDetailsUseCase>()),
    );
    gh.factory<_i1006.GetBannersUseCase>(
      () => _i1006.GetBannersUseCase(gh<_i858.CommerceRepo>()),
    );
    gh.factory<_i940.GetCategoriesUseCase>(
      () => _i940.GetCategoriesUseCase(gh<_i858.CommerceRepo>()),
    );
    gh.factory<_i638.GetProductsUseCase>(
      () => _i638.GetProductsUseCase(gh<_i858.CommerceRepo>()),
    );
    gh.factory<_i980.GetSubCategoriesUseCase>(
      () => _i980.GetSubCategoriesUseCase(gh<_i858.CommerceRepo>()),
    );
    gh.factory<_i360.GetHomeDataUseCase>(
      () => _i360.GetHomeDataUseCase(
        gh<_i1006.GetBannersUseCase>(),
        gh<_i638.GetProductsUseCase>(),
        gh<_i940.GetCategoriesUseCase>(),
      ),
    );
    gh.factory<_i818.LoginCubit>(
      () => _i818.LoginCubit(gh<_i1003.LoginUseCase>()),
    );
    gh.factory<_i859.RegisterCubit>(
      () => _i859.RegisterCubit(gh<_i679.RegisterUseCase>()),
    );
    gh.factory<_i1015.AddToCartUseCase>(
      () => _i1015.AddToCartUseCase(gh<_i420.OrdersRepo>()),
    );
    gh.factory<_i740.CreateCashOrderUseCase>(
      () => _i740.CreateCashOrderUseCase(gh<_i420.OrdersRepo>()),
    );
    gh.factory<_i225.CreateCheckoutSessionUseCase>(
      () => _i225.CreateCheckoutSessionUseCase(gh<_i420.OrdersRepo>()),
    );
    gh.factory<_i682.GetUserCartUseCase>(
      () => _i682.GetUserCartUseCase(gh<_i420.OrdersRepo>()),
    );
    gh.factory<_i676.RemoveFromCartUseCase>(
      () => _i676.RemoveFromCartUseCase(gh<_i420.OrdersRepo>()),
    );
    gh.factory<_i915.UpdateCartUseCase>(
      () => _i915.UpdateCartUseCase(gh<_i420.OrdersRepo>()),
    );
    gh.factory<_i229.CategoriesCubit>(
      () => _i229.CategoriesCubit(
        gh<_i940.GetCategoriesUseCase>(),
        gh<_i980.GetSubCategoriesUseCase>(),
      ),
    );
    gh.factory<_i52.HomeCubit>(
      () => _i52.HomeCubit(gh<_i360.GetHomeDataUseCase>()),
    );
    gh.singleton<_i661.CartCubit>(
      () => _i661.CartCubit(
        gh<_i682.GetUserCartUseCase>(),
        gh<_i1015.AddToCartUseCase>(),
        gh<_i676.RemoveFromCartUseCase>(),
        gh<_i915.UpdateCartUseCase>(),
        gh<_i740.CreateCashOrderUseCase>(),
        gh<_i225.CreateCheckoutSessionUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i1031.AppModule {}
