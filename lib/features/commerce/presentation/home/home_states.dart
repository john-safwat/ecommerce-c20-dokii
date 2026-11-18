import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/home_sections.dart';

class HomeStates {
  final List<Resources<HomeSections>> homeSections;

  HomeStates({List<Resources<HomeSections>>? homeSections})
    : homeSections = homeSections ?? const [];

  HomeStates copyWith({List<Resources<HomeSections>>? homeSections}) =>
      HomeStates(homeSections: homeSections ?? this.homeSections);
}

sealed class HomeAction {
  const HomeAction();
}

class LoadHomeDataAction extends HomeAction {
  const LoadHomeDataAction();
}

sealed class HomeNavigationAction {
  const HomeNavigationAction();
}

class ShowHomeErrorToast extends HomeNavigationAction {
  final String message;

  const ShowHomeErrorToast(this.message);
}
