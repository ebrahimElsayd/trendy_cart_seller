import 'package:flutter/material.dart';
import 'package:trendycart_of_seller/features/dashboard/add_new_product_screen.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();

  static Widget productItem(
    String name,
    String sales,
    String status,
    String stock, {
    bool available = true,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade300,
        ),
      ),
      title: Text(name),
      subtitle: Text(sales),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            status,
            style: TextStyle(color: available ? Colors.green : Colors.red),
          ),
          Text(stock, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  static Widget activityItem(
    String week,
    String category,
    String products,
    String pChange,
    String views,
    String vChange,
    String comments,
    String cChange,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(week, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(category, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            metricItem('Products', products, pChange),
            metricItem('Views', views, vChange, down: vChange.contains('-')),
            metricItem('Comments', comments, cChange),
          ],
        ),
      ],
    );
  }

  static Widget metricItem(
    String label,
    String count,
    String change, {
    bool down = false,
  }) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        if (change.isNotEmpty)
          Row(
            children: [
              Icon(
                down ? Icons.arrow_downward : Icons.arrow_upward,
                color: down ? Colors.red : Colors.green,
                size: 14,
              ),
              Text(
                change,
                style: TextStyle(color: down ? Colors.red : Colors.green),
              ),
            ],
          ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Product',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddProductScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('+ Add Product'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Selling Product',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllProductScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'See All Product',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        ProductScreen.productItem(
                          'Pink Dress',
                          '12,429 Sales',
                          'Available',
                          '105 Stocks Remaining',
                        ),
                        ProductScreen.productItem(
                          'Nintendo Pro',
                          '11,749 Sales',
                          'Out of stock',
                          '0 Stocks Remaining',
                          available: false,
                        ),
                        ProductScreen.productItem(
                          'Pink Dress',
                          '9,429 Sales',
                          'Available',
                          '158 Stocks Remaining',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Product activity',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: 'All time',
                              items: const [
                                DropdownMenuItem(
                                  value: 'All time',
                                  child: Text('All time'),
                                ),
                                DropdownMenuItem(
                                  value: 'In a year',
                                  child: Text('In a year'),
                                ),
                                DropdownMenuItem(
                                  value: 'Per month',
                                  child: Text('Per month'),
                                ),
                              ],
                              onChanged: (_) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ProductScreen.activityItem(
                      'Week 1',
                      'Women’s Fashion',
                      '6,241',
                      '+37.8%',
                      '12',
                      '-11.8%',
                      '438',
                      '+26.4%',
                    ),
                    const SizedBox(height: 16),
                    ProductScreen.activityItem(
                      'Week 2',
                      'Video Games',
                      '1,368',
                      '',
                      '68,192',
                      '',
                      '849',
                      '',
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Load more'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
///////////////////////////////////////

class AllProductScreen extends StatelessWidget {
  const AllProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'All Product',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search product',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  buildProductCard(
                    imageUrl:
                        'https://img.icons8.com/?size=96&id=59877&format=png',
                    title: 'Gray vintage computer',
                    price: '\$140.88',
                    category: 'Electronics & Accessories',
                    status: 'Available',
                    statusColor: Color(0xFFD7F5DC),
                    statusTextColor: Color(0xFF219653),
                    sales: '1,368',
                    views: '6',
                    likes: '21',
                    showTrend: true,
                  ),
                  buildProductCard(
                    imageUrl:
                        'https://img.icons8.com/?size=96&id=59877&format=png',
                    title: 'Nintendo Pro',
                    price: '\$213.99',
                    category: 'Video Games',
                    status: 'Out of stock',
                    statusColor: Color(0xFFFDEAEA),
                    statusTextColor: Color(0xFFEB5757),
                    sales: '1,368',
                    views: '1,368',
                    likes: '62',
                    showTrend: true,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFE0E0E0)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Load more',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard({
    required String imageUrl,
    required String title,
    required String price,
    required String category,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String sales,
    required String views,
    required String likes,
    required bool showTrend,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 20,
                  height: 20,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xFF2F80ED),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              metricItem('Sales', sales, showTrend),
              const SizedBox(height: 8),
              metricItem('Views', views, false),
              const SizedBox(height: 8),
              metricItem('Likes', likes, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget metricItem(String label, String value, bool showTrend) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (showTrend)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  '↑ 37.8%',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
