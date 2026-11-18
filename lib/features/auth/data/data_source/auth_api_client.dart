import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:route_ecommerce/features/auth/data/models/auth_response_dto.dart';
import 'package:route_ecommerce/features/auth/data/models/login_request_dto.dart';
import 'package:route_ecommerce/features/auth/data/models/registration_request_dto.dart';

part 'auth_api_client.g.dart';

@injectable
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST('/api/v1/auth/signup')
  Future<AuthResponseDto> register(@Body() RegistrationRequestDto request);

  @POST('/api/v1/auth/signin')
  Future<AuthResponseDto> login(@Body() LoginRequestDto request);
}
