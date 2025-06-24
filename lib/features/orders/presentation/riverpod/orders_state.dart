import '../../../../core/comman/entitys/user_order_model.dart';
import '../../data/data_source/orders_data_source.dart';

enum OrdersStateStatus {
  initial,
  loading,
  loaded,
  error,
  summaryLoading,
  summaryLoaded,
  updatingOrder,
  orderUpdated,
}

class OrdersState {
  final List<UserOrderModel> orders;
  final OrderSummaryData? orderSummary;
  final OrdersStateStatus status;
  final String? errorMessage;

  OrdersState({
    this.orders = const [],
    this.orderSummary,
    this.status = OrdersStateStatus.initial,
    this.errorMessage,
  });

  OrdersState copyWith({
    List<UserOrderModel>? orders,
    OrderSummaryData? orderSummary,
    OrdersStateStatus? status,
    String? errorMessage,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      orderSummary: orderSummary ?? this.orderSummary,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
