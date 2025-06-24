import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/orders_repository.dart';
import 'orders_state.dart';

final ordersRiverpodProvider =
    StateNotifierProvider.autoDispose<OrdersRiverpod, OrdersState>(
      (ref) =>
          OrdersRiverpod(ordersRepository: ref.read(ordersRepositoryProvider)),
    );

class OrdersRiverpod extends StateNotifier<OrdersState> {
  final OrdersRepository ordersRepository;

  OrdersRiverpod({required this.ordersRepository}) : super(OrdersState());

  Future<void> getAllOrders() async {
    state = state.copyWith(status: OrdersStateStatus.loading);

    print('🔍 Debug: Starting to fetch orders...');

    final result = await ordersRepository.getAllOrders();

    result.fold(
      (failure) {
        print('🔍 Debug: Error fetching orders: ${failure.message}');
        state = state.copyWith(
          status: OrdersStateStatus.error,
          errorMessage: failure.message,
        );
      },
      (orders) {
        print('🔍 Debug: Successfully fetched ${orders.length} orders');
        state = state.copyWith(
          status: OrdersStateStatus.loaded,
          orders: orders,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> getOrdersByState(String orderState) async {
    state = state.copyWith(status: OrdersStateStatus.loading);

    final result = await ordersRepository.getOrdersByState(orderState);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: OrdersStateStatus.error,
            errorMessage: failure.message,
          ),
      (orders) =>
          state = state.copyWith(
            status: OrdersStateStatus.loaded,
            orders: orders,
            errorMessage: null,
          ),
    );
  }

  Future<void> getOrderSummary() async {
    state = state.copyWith(status: OrdersStateStatus.summaryLoading);

    final result = await ordersRepository.getOrderSummary();

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: OrdersStateStatus.error,
            errorMessage: failure.message,
          ),
      (summary) =>
          state = state.copyWith(
            status: OrdersStateStatus.summaryLoaded,
            orderSummary: summary,
            errorMessage: null,
          ),
    );
  }

  Future<void> updateOrderState(String orderId, String newState) async {
    state = state.copyWith(status: OrdersStateStatus.updatingOrder);

    final result = await ordersRepository.updateOrderState(orderId, newState);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: OrdersStateStatus.error,
            errorMessage: failure.message,
          ),
      (_) {
        // Update the local state by changing the order state
        final updatedOrders =
            state.orders.map((order) {
              if (order.orderId == orderId) {
                return order.copyWith(orderState: newState);
              }
              return order;
            }).toList();

        state = state.copyWith(
          status: OrdersStateStatus.orderUpdated,
          orders: updatedOrders,
          errorMessage: null,
        );

        // Refresh the summary after updating
        getOrderSummary();
      },
    );
  }

  Future<void> loadAllData() async {
    await Future.wait([getAllOrders(), getOrderSummary()]);
  }
}
