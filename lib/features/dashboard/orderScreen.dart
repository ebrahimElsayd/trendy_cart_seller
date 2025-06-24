import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import '../orders/presentation/riverpod/orders_riverpod.dart';
import '../orders/presentation/riverpod/orders_state.dart';
import '../../core/comman/widgets/custom_cached_network_image_provider.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  List<Color> colorList = const [
    Color(0xFFF57C00), // Orange for Preparing
    Color(0xFF4CAF50), // Green for Delivered
    Color(0xFFE53935), // Red for Cancelled
  ];

  @override
  void initState() {
    super.initState();
    // Load orders data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersRiverpodProvider.notifier).loadAllData();
    });
  }

  TableRow _buildTableRow({
    required List<String> cells,
    bool isHeader = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[200] : Colors.transparent,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      children: List.generate(cells.length, (index) {
        return Container(
          decoration:
              index != cells.length - 1
                  ? const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  )
                  : null,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            cells[index],
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersRiverpodProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
        title: const Text("Orders", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildOrderSummaryCard(ordersState),
            const SizedBox(height: 16),
            const Text(
              "Review Orders",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildOrdersTable(ordersState),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(OrdersState ordersState) {
    // Debug print to understand the state
    print('🔍 OrderScreen Debug - Status: ${ordersState.status}');
    print('🔍 OrderScreen Debug - Orders count: ${ordersState.orders.length}');
    print('🔍 OrderScreen Debug - Order summary: ${ordersState.orderSummary}');
    if (ordersState.orders.isNotEmpty) {
      print(
        '🔍 OrderScreen Debug - Sample order states: ${ordersState.orders.take(3).map((o) => o.orderState).toList()}',
      );
    }

    if (ordersState.status == OrdersStateStatus.summaryLoading ||
        ordersState.status == OrdersStateStatus.loading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (ordersState.status == OrdersStateStatus.error) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                'Error: ${ordersState.errorMessage ?? 'Unknown error'}',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ref.read(ordersRiverpodProvider.notifier).getOrderSummary();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final summary = ordersState.orderSummary;
    if (summary == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Text('No order data available')),
      );
    }

    // Debug print summary data
    print('🔍 OrderScreen Debug - Summary data:');
    print('  Preparing: ${summary.preparingOrders}');
    print('  Delivered: ${summary.deliveredOrders}');
    print('  Cancelled: ${summary.cancelledOrders}');
    print('  Total: ${summary.totalOrders}');

    final dataMap = {
      "Preparing Orders": summary.preparingOrders.toDouble(),
      "Delivered Orders": summary.deliveredOrders.toDouble(),
      "Cancelled Orders": summary.cancelledOrders.toDouble(),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (summary.totalOrders > 0)
            PieChart(
              dataMap: dataMap,
              chartType: ChartType.disc,
              chartRadius: 120,
              colorList: colorList,
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValues: true,
                showChartValueBackground: true,
              ),
              legendOptions: const LegendOptions(showLegends: false),
            )
          else
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                // Debug info showing raw counts
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Debug - Raw Counts:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Preparing: ${summary.preparingOrders}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Delivered: ${summary.deliveredOrders}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Cancelled: ${summary.cancelledOrders}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Total: ${summary.totalOrders}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildLegendItem(
                colorList[0],
                "Preparing Orders (${summary.preparingOrders})",
              ),
              _buildLegendItem(
                colorList[1],
                "Delivered Orders (${summary.deliveredOrders})",
              ),
              _buildLegendItem(
                colorList[2],
                "Cancelled Orders (${summary.cancelledOrders})",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTable(OrdersState ordersState) {
    if (ordersState.status == OrdersStateStatus.loading) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (ordersState.status == OrdersStateStatus.error) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Error: ${ordersState.errorMessage ?? 'Unknown error'}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.read(ordersRiverpodProvider.notifier).getAllOrders();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (ordersState.orders.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Text(
              'No orders found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(3),
        },
        border: const TableBorder(
          horizontalInside: BorderSide(color: Colors.grey, width: 0.2),
        ),
        children: [
          _buildTableRow(
            cells: ["Date", "Product Name", "Order ID", "Status"],
            isHeader: true,
          ),
          ...ordersState.orders.take(10).map((order) {
            final formattedDate = DateFormat(
              'dd/MM/yy',
            ).format(order.orderCreatedAt);
            return _buildTableRow(
              cells: [
                formattedDate,
                order.itemName.isNotEmpty ? order.itemName : 'Unknown Product',
                order.orderId.length > 6
                    ? order.orderId.substring(0, 6)
                    : order.orderId,
                _capitalizeFirst(order.orderState),
              ],
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

  Widget _buildLegendItem(Color color, String title) {
    return Expanded(
      child: Row(
        children: [
          Container(width: 12, height: 12, color: color),
          const SizedBox(width: 6),
          Flexible(child: Text(title, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
