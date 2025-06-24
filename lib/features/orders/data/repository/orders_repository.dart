import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/comman/entitys/user_order_model.dart';
import '../data_source/orders_data_source.dart';

final ordersRepositoryProvider = Provider.autoDispose<OrdersRepository>(
  (ref) => OrdersRepositoryImpl(
    ordersDataSource: ref.read(ordersDataSourceProvider),
  ),
);

abstract class OrdersRepository {
  Future<Either<Failure, List<UserOrderModel>>> getAllOrders();
  Future<Either<Failure, List<UserOrderModel>>> getOrdersByState(String state);
  Future<Either<Failure, OrderSummaryData>> getOrderSummary();
  Future<Either<Failure, UserOrderModel>> getOrderById(String orderId);
  Future<Either<Failure, void>> updateOrderState(
    String orderId,
    String newState,
  );
}

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersDataSource ordersDataSource;

  OrdersRepositoryImpl({required this.ordersDataSource});

  @override
  Future<Either<Failure, List<UserOrderModel>>> getAllOrders() async {
    try {
      final result = await ordersDataSource.getAllOrders();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserOrderModel>>> getOrdersByState(
    String state,
  ) async {
    try {
      final result = await ordersDataSource.getOrdersByState(state);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderSummaryData>> getOrderSummary() async {
    try {
      final result = await ordersDataSource.getOrderSummary();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserOrderModel>> getOrderById(String orderId) async {
    try {
      final result = await ordersDataSource.getOrderById(orderId);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderState(
    String orderId,
    String newState,
  ) async {
    try {
      final result = await ordersDataSource.updateOrderState(orderId, newState);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
