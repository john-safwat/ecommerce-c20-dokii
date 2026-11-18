import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/base/base_cubit.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/home_sections.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_home_data_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/home/home_states.dart';

@injectable
class HomeCubit
    extends BaseCubit<HomeStates, HomeAction, HomeNavigationAction> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeCubit(this.getHomeDataUseCase) : super(HomeStates());

  @override
  Future<void> doAction(HomeAction action) async {
    switch (action) {
      case LoadHomeDataAction():
        await _loadHomeData();
    }
  }

  Future<void> _loadHomeData() async {
    emit(state.copyWith(homeSections: [Resources.loading()]));

    final results = await getHomeDataUseCase();
    if (isClosed) return;

    if (results.isEmpty) {
      emit(state.copyWith(homeSections: const []));
      emitNavigation(const ShowHomeErrorToast('Failed to load home data'));
      return;
    }

    final mappedSections = results.map(_mapResultToResource).toList();
    emit(state.copyWith(homeSections: mappedSections));
  }

  Resources<HomeSections> _mapResultToResource(Result<HomeSections> result) {
    switch (result) {
      case Success<HomeSections>():
        return Resources.success(result.data);
      case Failure<HomeSections>():
        return Resources.error(result.message, data: result.data);
    }
  }
}
