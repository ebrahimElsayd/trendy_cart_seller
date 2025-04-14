import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Map<String, double> dataMap = {
    "Pending Orders": 34,
    "Shipped Orders": 33,
    "Delivered Orders": 33,
  };

  List<Color> colorList = const [
    Color(0xFF1B0058),
    Color(0xFF3A4D7C),
    Color(0xFF003A5C),
  ];

  List<Map<String, String>> orderList = [
    {
      'date': '22/10/24',
      'productName': 'Name 1',
      'productId': '6213',
      'location': 'Tanta',
    },
    {
      'date': '22/10/24',
      'productName': 'Name 1',
      'productId': '8213',
      'location': 'Tanta',
    },
    {
      'date': '22/10/24',
      'productName': 'Name 1',
      'productId': '3273',
      'location': 'Tanta',
    },
    {
      'date': '22/10/24',
      'productName': 'Name 1',
      'productId': '3513',
      'location': 'Tanta',
    },
    {
      'date': '22/10/24',
      'productName': 'Name 1',
      'productId': '3293',
      'location': 'Tanta',
    },
  ];

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
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEF),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
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
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildLegendItem(colorList[0], "Pending Orders"),
                      _buildLegendItem(colorList[1], "Shipped Orders"),
                      _buildLegendItem(colorList[2], "Delivered Orders"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Review Orders",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
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
                    cells: [
                      "Date",
                      "Product Name",
                      "Product id",
                      "Delivery Location",
                    ],
                    isHeader: true,
                  ),
                  ...orderList.map((order) {
                    return _buildTableRow(
                      cells: [
                        order['date'] ?? '',
                        order['productName'] ?? '',
                        order['productId'] ?? '',
                        order['location'] ?? '',
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
