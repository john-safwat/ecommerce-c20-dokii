import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/banner_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/home_sections.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_banners_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_categories_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_home_data_use_case.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_products_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_states.dart';

class _FakeGetHomeDataUseCase implements GetHomeDataUseCase {
  final Future<List<Result<HomeSections>>> Function() _handler;

  _FakeGetHomeDataUseCase(this._handler);

  @override
  Future<List<Result<HomeSections>>> call() => _handler();

  @override
  GetBannersUseCase get getBannersUseCase => throw UnimplementedError();

  @override
  set getBannersUseCase(GetBannersUseCase _) {}

  @override
  GetCategoriesUseCase get getCategoriesUseCase => throw UnimplementedError();

  @override
  set getCategoriesUseCase(GetCategoriesUseCase _) {}

  @override
  GetProductsUseCase get getProductsUseCase => throw UnimplementedError();

  @override
  set getProductsUseCase(GetProductsUseCase _) {}
}

void main() {
  group('HomeCubit', () {
    test('initial state has empty homeSections list', () {
      final cubit = HomeCubit(_FakeGetHomeDataUseCase(() async => const []));

      expect(cubit.state.homeSections, isEmpty);
      cubit.close();
    });

    test(
      'LoadHomeDataAction emits loading then mapped success and error resources',
      () async {
        final bannerSection = BannersSection(0, [
          BannerEntity(
            'https://example.com/b1.png',
            'Summer Sale',
            'Electronics',
            Alignment.centerLeft,
            Colors.blue,
            Colors.white,
          ),
        ]);
        final categorySection = CategoriesSection(1, [
          CategoryEntity('c1', 'https://example.com/c1.png', 'Electronics'),
        ], 'Categories');

        final cubit = HomeCubit(
          _FakeGetHomeDataUseCase(
            () async => [
              Success(bannerSection),
              Success(categorySection),
              Failure('Failed to load products'),
            ],
          ),
        );

        final emittedStates = <HomeStates>[];
        final sub = cubit.stream.listen(emittedStates.add);

        await cubit.doAction(const LoadHomeDataAction());
        await Future<void>.delayed(Duration.zero);

        expect(emittedStates.length, equals(2));
        expect(emittedStates[0].homeSections.length, equals(1));
        expect(
          emittedStates[0].homeSections.first.status,
          equals(Status.loading),
        );

        final finalSections = emittedStates[1].homeSections;
        expect(finalSections.length, equals(3));
        expect(finalSections[0].status, equals(Status.success));
        expect(finalSections[0].data, equals(bannerSection));
        expect(finalSections[1].status, equals(Status.success));
        expect(finalSections[1].data, equals(categorySection));
        expect(finalSections[2].status, equals(Status.error));
        expect(finalSections[2].message, equals('Failed to load products'));

        await sub.cancel();
        await cubit.close();
      },
    );

    test(
      'LoadHomeDataAction emits empty list and ShowHomeErrorToast when results are empty',
      () async {
        final cubit = HomeCubit(_FakeGetHomeDataUseCase(() async => const []));

        final navEvents = <HomeNavigationAction>[];
        final navSub = cubit.navStream.listen(navEvents.add);

        await cubit.doAction(const LoadHomeDataAction());
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.homeSections, isEmpty);
        expect(navEvents.length, equals(1));
        expect(navEvents.first, isA<ShowHomeErrorToast>());
        expect(
          (navEvents.first as ShowHomeErrorToast).message,
          equals('Failed to load home data'),
        );

        await navSub.cancel();
        await cubit.close();
      },
    );

    test('LoadHomeDataAction does not emit after cubit is closed', () async {
      final completer = Completer<List<Result<HomeSections>>>();
      final cubit = HomeCubit(_FakeGetHomeDataUseCase(() => completer.future));

      final navEvents = <HomeNavigationAction>[];
      final navSub = cubit.navStream.listen(navEvents.add);

      final future = cubit.doAction(const LoadHomeDataAction());
      expect(cubit.state.homeSections.length, equals(1));
      expect(cubit.state.homeSections.first.status, equals(Status.loading));

      await cubit.close();
      completer.complete([]);
      await future;

      expect(navEvents, isEmpty);
      await navSub.cancel();
    });
  });
}
