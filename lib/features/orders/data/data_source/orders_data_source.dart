import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/comman/entitys/user_order_model.dart';
import '../../../../core/utils/try_and_catch.dart';

final supabaseClientProvider = Provider.autoDispose<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final ordersDataSourceProvider = Provider.autoDispose<OrdersDataSource>(
  (ref) =>
      OrdersDataSourceImpl(supabaseClient: ref.read(supabaseClientProvider)),
);

class OrderSummaryData {
  final int preparingOrders;
  final int cancelledOrders;
  final int deliveredOrders;

  OrderSummaryData({
    required this.preparingOrders,
    required this.cancelledOrders,
    required this.deliveredOrders,
  });

  int get totalOrders => preparingOrders + cancelledOrders + deliveredOrders;

  // Keep old getters for backward compatibility
  int get pendingOrders => preparingOrders;
  int get shippedOrders => cancelledOrders;
}

abstract class OrdersDataSource {
  Future<List<UserOrderModel>> getAllOrders();
  Future<List<UserOrderModel>> getOrdersByState(String state);
  Future<OrderSummaryData> getOrderSummary();
  Future<UserOrderModel> getOrderById(String orderId);
  Future<void> updateOrderState(String orderId, String newState);
}

class OrdersDataSourceImpl implements OrdersDataSource {
  final SupabaseClient supabaseClient;

  OrdersDataSourceImpl({required this.supabaseClient});

  // Debug method to check database structure
  Future<void> debugDatabaseStructure() async {
    try {
      print('🔍 Debug: Checking database structure...');

      // First, let's try to see if we can get any data from the table
      final response = await supabaseClient
          .from('user_orders')
          .select('*')
          .limit(1);

      print('🔍 Debug: Sample data from user_orders: $response');

      if (response.isNotEmpty) {
        final firstRow = response.first;
        print('🔍 Debug: Available columns: ${firstRow.keys.toList()}');
      }

      // Also check if there's any data at all
      final allData = await supabaseClient.from('user_orders').select('*');

      print('🔍 Debug: Total records in user_orders table: ${allData.length}');
    } catch (e) {
      print('🔍 Debug: Error checking database structure: $e');
    }
  }

  @override
  Future<List<UserOrderModel>> getAllOrders() async {
    return executeTryAndCatchForDataLayer(() async {
      print('🔍 Debug: Fetching all orders from user_orders table...');

      final response = await supabaseClient
          .from('user_orders')
          .select()
          .order('order_created_at', ascending: false);

      print('🔍 Debug: Raw response from database: $response');
      print('🔍 Debug: Response type: ${response.runtimeType}');
      print('🔍 Debug: Response length: ${response.length}');

      if (response.isEmpty) {
        print('🔍 Debug: No data returned from database');
        return [];
      }

      final orders =
          (response as List<dynamic>).map((order) {
            print('🔍 Debug: Processing order: $order');
            return UserOrderModel.fromMap(order as Map<String, dynamic>);
          }).toList();

      print('🔍 Debug: Processed ${orders.length} orders');
      return orders;
    });
  }

  @override
  Future<List<UserOrderModel>> getOrdersByState(String state) async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient
          .from('user_orders')
          .select()
          .eq('state', state)
          .order('order_created_at', ascending: false);

      return (response as List<dynamic>)
          .map((order) => UserOrderModel.fromMap(order as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<OrderSummaryData> getOrderSummary() async {
    return executeTryAndCatchForDataLayer(() async {
      // Get all orders and count them by state
      final allOrders = await getAllOrders();

      print(
        '🔍 Debug: Calculating order summary from ${allOrders.length} orders',
      );

      // Get all unique order states to understand what states exist
      final uniqueStates =
          allOrders.map((order) => order.orderState).toSet().toList();
      print('🔍 Debug: Unique order states found: $uniqueStates');

      // Count orders by your specific states: delivered, preparing, cancelled
      final preparingOrders =
          allOrders
              .where((order) => order.orderState.toLowerCase() == 'preparing')
              .length;

      final deliveredOrders =
          allOrders
              .where((order) => order.orderState.toLowerCase() == 'delivered')
              .length;

      final cancelledOrders =
          allOrders
              .where((order) => order.orderState.toLowerCase() == 'cancelled')
              .length;

      print(
        '🔍 Debug: Order counts - Preparing: $preparingOrders, Delivered: $deliveredOrders, Cancelled: $cancelledOrders',
      );

      return OrderSummaryData(
        preparingOrders: preparingOrders,
        cancelledOrders: cancelledOrders,
        deliveredOrders: deliveredOrders,
      );
    });
  }

  @override
  Future<UserOrderModel> getOrderById(String orderId) async {
    return executeTryAndCatchForDataLayer(() async {
      final response =
          await supabaseClient
              .from('user_orders')
              .select()
              .eq('order_id', orderId)
              .single();

      return UserOrderModel.fromMap(response);
    });
  }

  @override
  Future<void> updateOrderState(String orderId, String newState) async {
    return executeTryAndCatchForDataLayer(() async {
      await supabaseClient
          .from('user_orders')
          .update({'state': newState})
          .eq('order_id', orderId);
    });
  }
}
