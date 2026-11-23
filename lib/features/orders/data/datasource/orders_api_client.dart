import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:route_ecommerce/features/orders/data/models/cart_response_dto.dart';
import 'package:route_ecommerce/features/orders/data/models/cash_order_response_dto.dart';
import 'package:route_ecommerce/features/orders/data/models/checkout_session_response_dto.dart';

part 'orders_api_client.g.dart';

@singleton
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @GET('/api/v2/cart')
  Future<CartResponseDto> getUserCart();

  @POST('/api/v2/cart')
  Future<CartResponseDto> addToCartProduct(@Body() Map<String, dynamic> body);

  @DELETE('/api/v2/cart/{id}')
  Future<CartResponseDto> removeFromCartProduct(@Path('id') String id);

  @PUT('/api/v2/cart/{id}')
  Future<CartResponseDto> updateCartProduct(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v2/orders/{cartId}')
  Future<CashOrderResponseDto> createCashOrder(
    @Path('cartId') String cartId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/orders/checkout-session/{cartId}')
  Future<CheckoutSessionResponseDto> createCheckoutSession(
    @Path('cartId') String cartId,
    @Query('url') String callbackUrl,
    @Body() Map<String, dynamic> body,
  );
}
