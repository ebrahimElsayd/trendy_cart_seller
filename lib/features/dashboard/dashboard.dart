import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalOrders = 0;
  int pendingCount = 0;
  int shippedCount = 0;
  int deliveredCount = 0;

  @override
  void initState() {
    super.initState();
    fetchOrderData();
  }

  Future<void> fetchOrderData() async {
    await Future.delayed(Duration(seconds: 1)); // simulate API call
    setState(() {
      totalOrders = 500;
      pendingCount = 150;
      shippedCount = 200;
      deliveredCount = 150;
    });
  }

  @override
  Widget build(BuildContext context) {
    double pendingOrders = totalOrders == 0 ? 0 : pendingCount / totalOrders;
    double shippedOrders = totalOrders == 0 ? 0 : shippedCount / totalOrders;
    double deliveredOrders =
        totalOrders == 0 ? 0 : deliveredCount / totalOrders;

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
                              value: "4453",
                              percentage: "10%",
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
                              percentage: "10%",
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: buildInfoCard(
                              icon: Icons.attach_money,
                              title: "Total Sell",
                              value: "\$1200",
                              percentage: "15%",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      buildOrderSummary(
                        pendingOrders,
                        shippedOrders,
                        deliveredOrders,
                      ),
                      SizedBox(height: 16),
                      buildOrderList(),
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
    double pendingOrders,
    double shippedOrders,
    double deliveredOrders,
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
            "Pending Orders",
            pendingOrders,
            Colors.orange,
            pendingCount,
          ),
          buildProgress(
            "Shipped Orders",
            shippedOrders,
            Colors.purple,
            shippedCount,
          ),
          buildProgress(
            "Delivered Orders",
            deliveredOrders,
            Colors.green,
            deliveredCount,
          ),
        ],
      ),
    );
  }

  Widget buildProgress(String title, double progress, Color color, int count) {
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

  Widget buildOrderList() {
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
          buildOrderRow(
            "01/04/2024",
            "airpods pro",
            "electronics",
            "P12345",
            "Tanta,Gharbia",
            "Canceled",
            Colors.red,
          ),
          buildOrderRow(
            "01/04/2024",
            "Nintendo Pro",
            "electronics",
            "P12345",
            "Tanta,Gharbia",
            "Delivered",
            Colors.green,
          ),
          buildOrderRow(
            "01/04/2024",
            "Bose Headphones",
            "electronics",
            "P12345",
            "Tanta,Gharbia",
            "Pending",
            Colors.orange,
          ),
        ],
      ),
    );
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
