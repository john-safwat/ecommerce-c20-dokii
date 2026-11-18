import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/base/base_cubit.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/auth/domain/entities/login_entity.dart';
import 'package:route_ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:route_ecommerce/features/auth/domain/use_cases/login_use_case.dart';
import 'package:route_ecommerce/features/auth/presentation/login/view/login_actions.dart';
import 'package:route_ecommerce/features/auth/presentation/login/view/login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState, LoginActions, LoginUIAction> {
  final LoginUseCase useCase;

  LoginCubit(this.useCase) : super(LoginState(Resources.init()));

  @override
  Future<void> doAction(LoginActions action) async {
    switch (action) {
      case LoginAction():
        await _login(action);
      case NavigateToRegisterAction():
        emitNavigation(NavigateToRegisterScreen());
    }
  }

  Future<void> _login(LoginAction action) async {
    emit(state.copyWith(userEntity: Resources.loading()));
    final response = await useCase(LoginEntity(action.email, action.password));
    switch (response) {
      case Success<UserEntity>():
        emit(state.copyWith(userEntity: Resources.success(response.data)));
        emitNavigation(NavigateToHomeScreen());
      case Failure<UserEntity>():
        emit(state.copyWith(userEntity: Resources.error(response.message)));
        emitNavigation(ShowLoginError(response.message));
    }
  }
}
