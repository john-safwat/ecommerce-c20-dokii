import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/base/base_cubit.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/auth/domain/entities/register_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:route_ecommerce/features/auth/domain/use_cases/register_use_case.dart';
import 'package:route_ecommerce/features/auth/presentation/register/view/register_actions.dart';
import 'package:route_ecommerce/features/auth/presentation/register/view/register_state.dart';
import 'package:route_ecommerce/features/splash/presentation/view/splash_states.dart';

@injectable
class RegisterCubit
    extends BaseCubit<RegisterState, RegisterActions, RegisterUIAction> {
  RegisterUseCase useCase;

  RegisterCubit(this.useCase) : super(RegisterState(Resources.init()));

  @override
  Future<void> doAction(RegisterActions action) async {
    switch (action) {
      case RegisterSubmitAction():
        {
          _registerUser(action);
        }
        break;
    }
  }

  Future<void> _registerUser(RegisterSubmitAction action) async {
    emit(state.copyWith(user: Resources.loading()));
    var response = await useCase(
      RegisterEntity(
        action.name,
        action.email,
        action.password,
        action.password,
        action.phone,
      ),
    );
    switch (response) {
      case Success<UserEntity>():
        {
          emit(state.copyWith(user: Resources.success(response.data)));
          emitNavigation(NavigateBack());
        }
      case Failure<UserEntity>():
        {
          emit(state.copyWith(user: Resources.error(response.message)));
          emitNavigation(ShowRegisterError(response.message));
        }
    }
  }
}
