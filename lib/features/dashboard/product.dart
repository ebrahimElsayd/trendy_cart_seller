import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trendycart_of_seller/core/comman/entitys/item_model.dart';
import 'package:trendycart_of_seller/core/comman/widgets/custom_cached_network_image_provider.dart';
import 'package:trendycart_of_seller/features/dashboard/add_new_product_screen.dart';
import 'package:trendycart_of_seller/features/products/presentation/riverpod/items_riverpod.dart';
import 'package:trendycart_of_seller/features/products/presentation/riverpod/items_state.dart';

class ProductScreen extends ConsumerStatefulWidget {
  ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();

  static Widget productItem(ItemModel item, {VoidCallback? onTap}) {
    final bool available = item.quantity > 0;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade300,
        ),
        child:
            item.imageUrl.isNotEmpty
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomCachedNetworkImageProvider(
                    imageUrl: item.imageUrl,
                    height: 40,
                    width: 40,
                  ),
                )
                : Icon(Icons.image, color: Colors.grey),
      ),
      title: Text(item.name),
      subtitle: Text('\$${item.retailPrice.toStringAsFixed(2)}'),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            available ? 'Available' : 'Out of stock',
            style: TextStyle(color: available ? Colors.green : Colors.red),
          ),
          Text(
            '${item.quantity} Stock${item.quantity != 1 ? 's' : ''} Remaining',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
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
    // Debug print to see what values are being displayed
    print('metricItem - Label: $label, Count: $count, Change: $change');

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

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  void initState() {
    super.initState();
    // Load all items, top selling items and analytics when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(itemsRiverpodProvider.notifier);
      // Load all items first, then analytics
      notifier.getAllItems().then((_) {
        notifier.getTopSellingItems(limit: 5);
        notifier.loadAllAnalytics();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsRiverpodProvider);

    return Scaffold(
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
                    child: const Text(
                      '+ Add Product',
                      style: TextStyle(color: Colors.white),
                    ),
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
                        const Text(
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
                          child: const Text(
                            'See All Product',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildTopSellingProducts(itemsState),
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
                            boxShadow: const [
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
                    _buildAnalyticsSection(itemsState),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          final notifier = ref.read(
                            itemsRiverpodProvider.notifier,
                          );
                          // Refresh all data
                          notifier.getAllItems().then((_) {
                            notifier.getTopSellingItems(limit: 5);
                            notifier.loadAllAnalytics();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Refresh Data'),
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

  Widget _buildTopSellingProducts(ItemsState itemsState) {
    if (itemsState.status == ItemsStateStatus.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (itemsState.status == ItemsStateStatus.error) {
      return Center(
        child: Column(
          children: [
            Text(
              'Error: ${itemsState.errorMessage ?? 'Unknown error'}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(itemsRiverpodProvider.notifier)
                    .getTopSellingItems(limit: 5);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (itemsState.topSellingItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No products available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children:
          itemsState.topSellingItems
              .take(3)
              .map((item) => ProductScreen.productItem(item))
              .toList(),
    );
  }

  Widget _buildAnalyticsSection(ItemsState itemsState) {
    // Debug print to understand state changes
    print(
      'Analytics Section - Status: ${itemsState.status}, Items count: ${itemsState.items.length}',
    );

    // Show loading indicator when analytics are loading
    if (itemsState.status == ItemsStateStatus.analyticsLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Calculate basic analytics from available items data
    final totalProducts = itemsState.items.length;
    final availableProducts =
        itemsState.items.where((item) => item.quantity > 0).length;
    final totalStock = itemsState.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    final outOfStock = totalProducts - availableProducts;

    // Calculate total inventory value
    final totalInventoryValue = itemsState.items.fold<double>(
      0.0,
      (sum, item) => sum + (item.retailPrice * item.quantity),
    );

    // Debug print the calculated values
    print('Analytics Calculations:');
    print('  totalProducts: $totalProducts');
    print('  availableProducts: $availableProducts');
    print('  totalStock: $totalStock');
    print('  outOfStock: $outOfStock');
    print('  totalInventoryValue: $totalInventoryValue');

    // If we have real analytics data, show it; otherwise show calculated data
    if (itemsState.analyticsData.isNotEmpty) {
      return Column(
        children:
            itemsState.analyticsData.map((analytics) {
              final changeStr =
                  analytics.changePercentage >= 0
                      ? '+${analytics.changePercentage.toStringAsFixed(1)}%'
                      : '${analytics.changePercentage.toStringAsFixed(1)}%';

              final viewsChangeStr =
                  analytics.viewsChange >= 0
                      ? '+${analytics.viewsChange.toStringAsFixed(1)}%'
                      : '${analytics.viewsChange.toStringAsFixed(1)}%';

              final stockChangeStr =
                  analytics.stockChange >= 0
                      ? '+${analytics.stockChange.toStringAsFixed(1)}%'
                      : '${analytics.stockChange.toStringAsFixed(1)}%';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProductScreen.activityItem(
                  analytics.period,
                  analytics.category,
                  analytics.productCount.toString(),
                  analytics.changePercentage != 0.0 ? changeStr : '',
                  analytics.totalViews.toString(),
                  analytics.viewsChange != 0.0 ? viewsChangeStr : '',
                  analytics.totalStock.toString(),
                  analytics.stockChange != 0.0 ? stockChangeStr : '',
                ),
              );
            }).toList(),
      );
    }

    // Show calculated analytics from available data
    print('Creating activity items with values:');
    print(
      '  First item - Products: ${totalProducts.toString()}, Available: ${availableProducts.toString()}, Stock: ${totalStock.toString()}',
    );

    // Force the values to be strings to avoid any conversion issues
    final productsStr = totalProducts.toString();
    final availableStr = availableProducts.toString();
    final stockStr = totalStock.toString();
    final outOfStockStr = outOfStock.toString();
    final inventoryValueStr = '\$${totalInventoryValue.toStringAsFixed(0)}';

    print(
      'String values - Products: $productsStr, Available: $availableStr, Stock: $stockStr',
    );

    return Column(
      children: [
        // Debug widget to show raw values
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DEBUG - Raw Values:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text('Total Products: $totalProducts'),
              Text('Available Products: $availableProducts'),
              Text('Total Stock: $totalStock'),
              Text('Out of Stock: $outOfStock'),
              Text(
                'Inventory Value: \$${totalInventoryValue.toStringAsFixed(2)}',
              ),
            ],
          ),
        ),
        // Custom analytics widget instead of activityItem
        _buildCustomAnalyticsCard('Current Overview', 'Product Statistics', [
          _buildMetricColumn('Total Products', totalProducts.toString(), ''),
          _buildMetricColumn('Available', availableProducts.toString(), ''),
          _buildMetricColumn('Total Stock', totalStock.toString(), ''),
        ]),
        const SizedBox(height: 16),
        _buildCustomAnalyticsCard('Inventory Status', 'Stock Management', [
          _buildMetricColumn(
            'In Stock',
            availableProducts.toString(),
            availableProducts > 0
                ? '+${((availableProducts / totalProducts.clamp(1, double.infinity)) * 100).toStringAsFixed(0)}%'
                : '0%',
          ),
          _buildMetricColumn(
            'Out of Stock',
            outOfStock.toString(),
            outOfStock > 0
                ? '${((outOfStock / totalProducts.clamp(1, double.infinity)) * 100).toStringAsFixed(0)}%'
                : '0%',
          ),
          _buildMetricColumn(
            'Total Value',
            '\$${totalInventoryValue.toStringAsFixed(0)}',
            '',
          ),
        ]),
        if (totalProducts == 0)
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No products available. Add some products to see analytics!',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildCustomAnalyticsCard(
    String title,
    String subtitle,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ],
    );
  }

  Widget _buildMetricColumn(String label, String value, String change) {
    print('_buildMetricColumn - Label: $label, Value: $value, Change: $change');
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        if (change.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                change.contains('-')
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: change.contains('-') ? Colors.red : Colors.green,
                size: 14,
              ),
              Text(
                change,
                style: TextStyle(
                  color: change.contains('-') ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

// Updated AllProductScreen to use real data
class AllProductScreen extends ConsumerStatefulWidget {
  const AllProductScreen({super.key});

  @override
  ConsumerState<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends ConsumerState<AllProductScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load all items when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(itemsRiverpodProvider.notifier).getAllItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsRiverpodProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
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
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    if (query.length > 2 || query.isEmpty) {
                      ref
                          .read(itemsRiverpodProvider.notifier)
                          .searchItems(query);
                    }
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search product',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildProductsList(itemsState)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(ItemsState itemsState) {
    if (itemsState.status == ItemsStateStatus.loading ||
        itemsState.status == ItemsStateStatus.searchLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (itemsState.status == ItemsStateStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${itemsState.errorMessage ?? 'Unknown error'}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ref.read(itemsRiverpodProvider.notifier).getAllItems();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Determine which items to show
    final itemsToShow =
        itemsState.searchQuery.isNotEmpty
            ? itemsState.searchResults
            : itemsState.items;

    if (itemsToShow.isEmpty) {
      return Center(
        child: Text(
          itemsState.searchQuery.isNotEmpty
              ? 'No products found for "${itemsState.searchQuery}"'
              : 'No products available',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: itemsToShow.length + 1, // +1 for load more button
      itemBuilder: (context, index) {
        if (index == itemsToShow.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: InkWell(
                  onTap: () {
                    ref.read(itemsRiverpodProvider.notifier).getAllItems();
                  },
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
            ),
          );
        }

        final item = itemsToShow[index];
        return buildProductCard(item);
      },
    );
  }

  Widget buildProductCard(ItemModel item) {
    final bool available = item.quantity > 0;
    final statusColor =
        available ? const Color(0xFFD7F5DC) : const Color(0xFFFDEAEA);
    final statusTextColor =
        available ? const Color(0xFF219653) : const Color(0xFFEB5757);

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
                child:
                    item.imageUrl.isNotEmpty
                        ? CustomCachedNetworkImageProvider(
                          imageUrl: item.imageUrl,
                          width: 60,
                          height: 60,
                        )
                        : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${item.retailPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF2F80ED),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                  available ? 'Available' : 'Out of stock',
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
              metricItem('Stock', item.quantity.toString(), false),
              const SizedBox(height: 8),
              metricItem(
                'Wholesale Price',
                '\$${item.wholesalePrice.toStringAsFixed(2)}',
                false,
              ),
              const SizedBox(height: 8),
              metricItem(
                'Retail Price',
                '\$${item.retailPrice.toStringAsFixed(2)}',
                false,
              ),
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
