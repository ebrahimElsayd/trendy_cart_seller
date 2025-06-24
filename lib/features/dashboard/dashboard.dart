import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../orders/presentation/riverpod/orders_riverpod.dart';
import '../orders/presentation/riverpod/orders_state.dart';
import '../products/presentation/riverpod/items_riverpod.dart';
import '../products/presentation/riverpod/items_state.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load real data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersRiverpodProvider.notifier).loadAllData();
      ref.read(itemsRiverpodProvider.notifier).getAllItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersRiverpodProvider);
    final itemsState = ref.watch(itemsRiverpodProvider);

    // Get real data from the providers
    final summary = ordersState.orderSummary;
    final totalOrders = summary?.totalOrders ?? 0;
    final preparingCount = summary?.preparingOrders ?? 0;
    final deliveredCount = summary?.deliveredOrders ?? 0;
    final cancelledCount = summary?.cancelledOrders ?? 0;

    // Calculate percentages
    double preparingOrders =
        totalOrders == 0 ? 0 : preparingCount / totalOrders;
    double deliveredOrders =
        totalOrders == 0 ? 0 : deliveredCount / totalOrders;
    double cancelledOrders =
        totalOrders == 0 ? 0 : cancelledCount / totalOrders;

    // Get product count
    final totalProducts = itemsState.items.length;

    // Calculate total sales from delivered orders
    final totalSales = ordersState.orders
        .where((order) => order.orderState.toLowerCase() == 'delivered')
        .fold<double>(0.0, (sum, order) => sum + order.itemPrice);

    // Calculate growth percentage (placeholder for now)
    final productGrowth = totalProducts > 0 ? "10%" : "0%";
    final orderGrowth = totalOrders > 0 ? "15%" : "0%";
    final salesGrowth = totalSales > 0 ? "12%" : "0%";

    // Show loading state while data is being fetched
    if (ordersState.status == OrdersStateStatus.loading &&
        itemsState.status == ItemsStateStatus.loading) {
      return Scaffold(
        backgroundColor: Color(0xFFBDBDBD),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFBDBDBD),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: buildInfoCard(
                              icon: Icons.sell,
                              title: "Total Product",
                              value: "$totalProducts",
                              percentage: productGrowth,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: buildInfoCard(
                              icon: Icons.shopping_cart,
                              title: "Total Orders",
                              value: "$totalOrders",
                              percentage: orderGrowth,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: buildInfoCard(
                              icon: Icons.attach_money,
                              title: "Total Sales",
                              value: "\$${totalSales.toStringAsFixed(0)}",
                              percentage: salesGrowth,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      buildOrderSummary(
                        preparingOrders,
                        deliveredOrders,
                        cancelledOrders,
                        preparingCount,
                        deliveredCount,
                        cancelledCount,
                        totalOrders,
                      ),
                      SizedBox(height: 16),
                      buildOrderList(ordersState),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String percentage,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16),
              Spacer(),
              Icon(Icons.more_vert, size: 16),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.arrow_upward, color: Colors.green, size: 14),
              SizedBox(width: 4),
              Text(
                "$percentage",
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
              SizedBox(width: 4),
              Text(
                "vs last month",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildOrderSummary(
    double preparingOrders,
    double deliveredOrders,
    double cancelledOrders,
    int preparingCount,
    int deliveredCount,
    int cancelledCount,
    int totalOrders,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Summary", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          buildProgress(
            "Preparing Orders",
            preparingOrders,
            Colors.orange,
            preparingCount,
            totalOrders,
          ),
          buildProgress(
            "Delivered Orders",
            deliveredOrders,
            Colors.green,
            deliveredCount,
            totalOrders,
          ),
          buildProgress(
            "Cancelled Orders",
            cancelledOrders,
            Colors.red,
            cancelledCount,
            totalOrders,
          ),
        ],
      ),
    );
  }

  Widget buildProgress(
    String title,
    double progress,
    Color color,
    int count,
    int totalOrders,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text("${(progress * 100).toInt()}%")],
          ),
          SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 4),
          Text(
            "$count/$totalOrders Orders",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget buildOrderList(OrdersState ordersState) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent Orders", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          if (ordersState.status == OrdersStateStatus.loading)
            Center(child: CircularProgressIndicator())
          else if (ordersState.orders.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No orders found",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...ordersState.orders.take(3).map((order) {
              final formattedDate = DateFormat(
                'dd/MM/yyyy',
              ).format(order.orderCreatedAt);
              Color statusColor;
              switch (order.orderState.toLowerCase()) {
                case 'preparing':
                  statusColor = Colors.orange;
                  break;
                case 'delivered':
                  statusColor = Colors.green;
                  break;
                case 'cancelled':
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = Colors.grey;
              }

              return buildOrderRow(
                formattedDate,
                order.itemName.isNotEmpty ? order.itemName : "Unknown Product",
                "Product", // category placeholder
                order.orderId.length > 6
                    ? order.orderId.substring(0, 6)
                    : order.orderId,
                order.region.isNotEmpty ? order.region : "Unknown Location",
                _capitalizeFirst(order.orderState),
                statusColor,
              );
            }).toList(),
        ],
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Widget buildOrderRow(
    String date,
    String title,
    String category,
    String orderId,
    String location,
    String status,
    Color statusColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                orderId,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                category,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(location, style: TextStyle(fontSize: 12)),
              Container(
                margin: EdgeInsets.only(top: 4),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
