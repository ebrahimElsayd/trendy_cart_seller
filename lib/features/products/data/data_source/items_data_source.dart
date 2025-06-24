import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/comman/entitys/item_model.dart';
import '../../../../core/comman/entitys/categories.dart';
import '../../../../core/utils/try_and_catch.dart';

final supabaseClientProvider = Provider.autoDispose<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final itemsDataSourceProvider = Provider.autoDispose<ItemsDataSource>(
  (ref) =>
      ItemsDataSourceImpl(supabaseClient: ref.read(supabaseClientProvider)),
);

class AnalyticsData {
  final String period;
  final String category;
  final int productCount;
  final double changePercentage;
  final int totalViews;
  final double viewsChange;
  final int totalStock;
  final double stockChange;

  AnalyticsData({
    required this.period,
    required this.category,
    required this.productCount,
    required this.changePercentage,
    required this.totalViews,
    required this.viewsChange,
    required this.totalStock,
    required this.stockChange,
  });
}

abstract class ItemsDataSource {
  Future<List<ItemModel>> getAllItems();
  Future<List<ItemModel>> getTopSellingItems({int limit = 10});
  Future<List<ItemModel>> searchItems(String query);
  Future<ItemModel> getItemById(String id);
  Future<List<AnalyticsData>> getAnalyticsData();
  Future<Map<String, int>> getProductsByCategory();
  Future<Map<String, dynamic>> getWeeklyAnalytics();
  Future<List<Categories>> getCategories();
  Future<ItemModel> addItem(ItemModel item);
  Future<void> updateItem(ItemModel item);
  Future<void> deleteItem(String id);
}

class ItemsDataSourceImpl implements ItemsDataSource {
  final SupabaseClient supabaseClient;

  ItemsDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<ItemModel>> getAllItems() async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient
          .from('items')
          .select()
          .eq("user_id", 35)
          .order('updated_at', ascending: false);

      return (response as List<dynamic>)
          .map((item) => ItemModel.fromMap(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<ItemModel>> getTopSellingItems({int limit = 10}) async {
    return executeTryAndCatchForDataLayer(() async {
      // For now, we'll just get the latest items ordered by quantity (stock)
      // You can modify this query based on your sales tracking logic
      final response = await supabaseClient
          .from('items')
          .select()
          .eq("user_id", 35)
          .order('quantity', ascending: false)
          .limit(limit);

      return (response as List<dynamic>)
          .map((item) => ItemModel.fromMap(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<ItemModel>> searchItems(String query) async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient
          .from('items')
          .select()
          .eq("user_id", 35)
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('updated_at', ascending: false);

      return (response as List<dynamic>)
          .map((item) => ItemModel.fromMap(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<ItemModel> getItemById(String id) async {
    return executeTryAndCatchForDataLayer(() async {
      final response =
          await supabaseClient.from('items').select().eq('id', id).single();

      return ItemModel.fromMap(response);
    });
  }

  @override
  Future<List<Categories>> getCategories() async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient.from('categories').select();

      return (response as List<dynamic>)
          .map(
            (category) => Categories.fromMap(category as Map<String, dynamic>),
          )
          .toList();
    });
  }

  @override
  Future<List<AnalyticsData>> getAnalyticsData() async {
    return executeTryAndCatchForDataLayer(() async {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final twoWeeksAgo = now.subtract(const Duration(days: 14));

      // Get categories for mapping
      final categories = await getCategories();
      final categoryMap = {for (var cat in categories) cat.id: cat.name};

      // Get items from this week
      final thisWeekResponse = await supabaseClient
          .from('items')
          .select()
          .eq("user_id", 35)
          .gte('updated_at', weekAgo.toIso8601String());

      final thisWeekItems =
          (thisWeekResponse as List<dynamic>)
              .map((item) => ItemModel.fromMap(item as Map<String, dynamic>))
              .toList();

      // Get items from last week
      final lastWeekResponse = await supabaseClient
          .from('items')
          .select()
          .eq("user_id", 35)
          .gte('updated_at', twoWeeksAgo.toIso8601String())
          .lt('updated_at', weekAgo.toIso8601String());

      final lastWeekItems =
          (lastWeekResponse as List<dynamic>)
              .map((item) => ItemModel.fromMap(item as Map<String, dynamic>))
              .toList();

      // Calculate analytics
      final thisWeekCount = thisWeekItems.length;
      final lastWeekCount = lastWeekItems.length;
      final changePercentage =
          lastWeekCount > 0
              ? ((thisWeekCount - lastWeekCount) / lastWeekCount * 100)
              : 0.0;

      // Calculate total stock
      final thisWeekStock = thisWeekItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );
      final lastWeekStock = lastWeekItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );
      final stockChange =
          lastWeekStock > 0
              ? ((thisWeekStock - lastWeekStock) / lastWeekStock * 100)
              : 0.0;

      // Get top category for this week
      final categoryCount = <int, int>{};
      for (final item in thisWeekItems) {
        categoryCount[item.categoryId] =
            (categoryCount[item.categoryId] ?? 0) + 1;
      }

      final topCategoryId =
          categoryCount.isNotEmpty
              ? categoryCount.entries
                  .reduce((a, b) => a.value > b.value ? a : b)
                  .key
              : 0;

      final topCategoryName = categoryMap[topCategoryId] ?? 'All Products';

      return [
        AnalyticsData(
          period: 'This Week',
          category: topCategoryName,
          productCount: thisWeekCount,
          changePercentage: changePercentage,
          totalViews:
              thisWeekCount *
              12, // Mock views data - you can integrate with your analytics service
          viewsChange: changePercentage * 0.8,
          totalStock: thisWeekStock,
          stockChange: stockChange,
        ),
        AnalyticsData(
          period: 'Last Week',
          category: 'All Products',
          productCount: lastWeekCount,
          changePercentage: 0.0,
          totalViews: lastWeekCount * 10, // Mock views data
          viewsChange: 0.0,
          totalStock: lastWeekStock,
          stockChange: 0.0,
        ),
      ];
    });
  }

  @override
  Future<Map<String, int>> getProductsByCategory() async {
    return executeTryAndCatchForDataLayer(() async {
      // Get categories for mapping
      final categories = await getCategories();
      final categoryMap = {for (var cat in categories) cat.id: cat.name};

      final response = await supabaseClient.from('items').select('category_id');

      final categoryCount = <String, int>{};
      for (final item in response as List<dynamic>) {
        final categoryId = item['category_id'] as int;
        final categoryName = categoryMap[categoryId] ?? 'Unknown Category';
        categoryCount[categoryName] = (categoryCount[categoryName] ?? 0) + 1;
      }

      return categoryCount;
    });
  }

  @override
  Future<Map<String, dynamic>> getWeeklyAnalytics() async {
    return executeTryAndCatchForDataLayer(() async {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      // Get all items
      final allItemsResponse = await supabaseClient
          .from('items')
          .select()
          .eq("user_id", 35);

      final allItems =
          (allItemsResponse as List<dynamic>)
              .map((item) => ItemModel.fromMap(item as Map<String, dynamic>))
              .toList();

      // Get items added this week
      final thisWeekResponse = await supabaseClient
          .from('items')
          .select()
          .eq("user_id", 35)
          .gte('updated_at', weekAgo.toIso8601String());

      final thisWeekItems =
          (thisWeekResponse as List<dynamic>)
              .map((item) => ItemModel.fromMap(item as Map<String, dynamic>))
              .toList();

      // Calculate metrics
      final totalProducts = allItems.length;
      final newProductsThisWeek = thisWeekItems.length;
      final totalStock = allItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );
      final availableProducts =
          allItems.where((item) => item.quantity > 0).length;
      final outOfStockProducts = totalProducts - availableProducts;

      return {
        'totalProducts': totalProducts,
        'newProductsThisWeek': newProductsThisWeek,
        'totalStock': totalStock,
        'availableProducts': availableProducts,
        'outOfStockProducts': outOfStockProducts,
        'averagePrice':
            allItems.isNotEmpty
                ? allItems.fold<double>(
                      0,
                      (sum, item) => sum + item.retailPrice,
                    ) /
                    allItems.length
                : 0.0,
      };
    });
  }

  @override
  Future<ItemModel> addItem(ItemModel item) async {
    return executeTryAndCatchForDataLayer(() async {
      final itemData = item.toMap();

      // Generate a new UUID if id is empty or invalid
      if (itemData['id'] == null || itemData['id'] == '') {
        itemData['id'] = const Uuid().v4();
      }

      // Add created_at timestamp if not provided
      if (itemData['updated_at'] == null || itemData['updated_at'] == '') {
        itemData['updated_at'] = DateTime.now().toIso8601String();
      }

      final response =
          await supabaseClient.from('items').insert(itemData).select().single();

      return ItemModel.fromMap(response);
    });
  }

  @override
  Future<void> updateItem(ItemModel item) async {
    return executeTryAndCatchForDataLayer(() async {
      final itemData = item.toMap();
      itemData['updated_at'] = DateTime.now().toIso8601String();

      await supabaseClient.from('items').update(itemData).eq('id', item.id);
    });
  }

  @override
  Future<void> deleteItem(String id) async {
    return executeTryAndCatchForDataLayer(() async {
      await supabaseClient.from('items').delete().eq('id', id);
    });
  }
}
