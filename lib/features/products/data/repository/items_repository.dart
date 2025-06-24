import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/comman/entitys/item_model.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../data_source/items_data_source.dart';

final itemsRepositoryProvider = Provider.autoDispose<ItemsRepository>((ref) {
  return ItemsRepository(itemsDataSource: ref.read(itemsDataSourceProvider));
});

class ItemsRepository {
  final ItemsDataSource itemsDataSource;

  ItemsRepository({required this.itemsDataSource});

  Future<Either<Failure, List<ItemModel>>> getAllItems() async {
    return executeTryAndCatchForRepository(() async {
      return await itemsDataSource.getAllItems();
    });
  }

  Future<Either<Failure, List<ItemModel>>> getTopSellingItems({
    int limit = 10,
  }) async {
    return executeTryAndCatchForRepository(() async {
      return await itemsDataSource.getTopSellingItems(limit: limit);
    });
  }

  Future<Either<Failure, List<ItemModel>>> searchItems(String query) async {
    return executeTryAndCatchForRepository(() async {
      return await itemsDataSource.searchItems(query);
    });
  }

  Future<Either<Failure, ItemModel>> getItemById(String id) async {
    return executeTryAndCatchForRepository(() async {
      return await itemsDataSource.getItemById(id);
    });
  }

  Future<Either<Failure, List<AnalyticsData>>> getAnalyticsData() async {
    return executeTryAndCatchForRepository(() async {
      return await itemsDataSource.getAnalyticsData();
    });
  }

  Future<Either<Failure, Map<String, int>>> getProductsByCategory() async {
    return executeTryAndCatchForRepository(() async {
      return await itemsDataSource.getProductsByCategory();
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> getWeeklyAnalytics() async {
    return executeTryAndCatchForRepository(() async {
      return await itemsDataSource.getWeeklyAnalytics();
    });
  }

  Future<Either<Failure, ItemModel>> addItem(ItemModel item) async {
    return executeTryAndCatchForRepository(() async {
      return await itemsDataSource.addItem(item);
    });
  }

  Future<Either<Failure, void>> updateItem(ItemModel item) async {
    return executeTryAndCatchForRepository(() async {
      return await itemsDataSource.updateItem(item);
    });
  }

  Future<Either<Failure, void>> deleteItem(String id) async {
    return executeTryAndCatchForRepository(() async {
      return await itemsDataSource.deleteItem(id);
    });
  }
}
