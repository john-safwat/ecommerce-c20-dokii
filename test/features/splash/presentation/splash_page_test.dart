import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/constants/app_assets.dart';
import 'package:route_ecommerce/core/di/injection.dart';
import 'package:route_ecommerce/core/l10n/app_localizations.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/routing/app_routes.dart';
import 'package:route_ecommerce/core/routing/route_gen.dart';
import 'package:route_ecommerce/features/auth/domain/entities/login_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/register_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:route_ecommerce/features/auth/domain/repo/auth_repo.dart';
import 'package:route_ecommerce/features/auth/domain/use_cases/login_use_case.dart';
import 'package:route_ecommerce/features/auth/presentation/login/view/login_cubit.dart';
import 'package:route_ecommerce/features/auth/presentation/login/view/login_page.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_page.dart';
import 'package:route_ecommerce/features/splash/domain/repo/splash_repo.dart';
import 'package:route_ecommerce/features/splash/domain/use_cases/check_token_use_case.dart';
import 'package:route_ecommerce/features/splash/presentation/view/splash_cubit.dart';
import 'package:route_ecommerce/features/splash/presentation/view/splash_page.dart';

class _FakeAuthRepo implements AuthRepo {
  @override
  Future<Result<UserEntity>> login(LoginEntity loginEntity) async =>
      Success(null);

  @override
  Future<Result<UserEntity>> register(RegisterEntity registerEntity) async =>
      Success(null);
}

class _FakeSplashRepo implements SplashRepo {
  final bool hasSavedToken;

  _FakeSplashRepo({required this.hasSavedToken});

  @override
  Future<Result<bool>> hasToken() async => Success(hasSavedToken);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    getIt.registerFactory<SplashCubit>(
      () =>
          SplashCubit(CheckTokenUseCase(_FakeSplashRepo(hasSavedToken: false))),
    );
    getIt.registerFactory<LoginCubit>(
      () => LoginCubit(LoginUseCase(_FakeAuthRepo())),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('SplashPage renders splash image asset', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: routeGen,
        home: SplashPage(),
      ),
    );

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final Image imageWidget = tester.widget(imageFinder);
    expect(
      (imageWidget.image as AssetImage).assetName,
      equals(AppAssets.splashScreen),
    );
    expect(imageWidget.fit, equals(BoxFit.cover));

    // Elapse pending timer
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets(
    'SplashPage navigates to LoginPage after 3 seconds when no token',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: routeGen,
          initialRoute: AppRoutes.splash,
        ),
      );

      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);

      // Pump 2 seconds, still on splash
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);

      // Pump remaining second and settle
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.byType(SplashPage), findsNothing);
      expect(find.byType(LoginPage), findsOneWidget);
    },
  );

  testWidgets(
    'SplashPage navigates to HomePage after 3 seconds when token exists',
    (tester) async {
      await getIt.reset();
      getIt.registerFactory<SplashCubit>(
        () => SplashCubit(
          CheckTokenUseCase(_FakeSplashRepo(hasSavedToken: true)),
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: routeGen,
          initialRoute: AppRoutes.splash,
        ),
      );

      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(SplashPage), findsNothing);
      expect(find.byType(HomePage), findsOneWidget);
    },
  );
}
