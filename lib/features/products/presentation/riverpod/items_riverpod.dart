import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/comman/entitys/item_model.dart';
import '../../data/repository/items_repository.dart';
import 'items_state.dart';

final itemsRiverpodProvider = StateNotifierProvider<ItemsRiverpod, ItemsState>((
  ref,
) {
  return ItemsRiverpod(repository: ref.watch(itemsRepositoryProvider));
});

class ItemsRiverpod extends StateNotifier<ItemsState> {
  final ItemsRepository _repository;

  ItemsRiverpod({required ItemsRepository repository})
    : _repository = repository,
      super(const ItemsState());

  Future<void> getAllItems() async {
    print('getAllItems: Starting to load items');
    state = state.copyWith(status: ItemsStateStatus.loading);

    final result = await _repository.getAllItems();

    result.fold(
      (failure) {
        print('getAllItems: Error loading items - ${failure.message}');
        state = state.copyWith(
          status: ItemsStateStatus.error,
          errorMessage: failure.message,
        );
      },
      (items) {
        print('getAllItems: Successfully loaded ${items.length} items');
        state = state.copyWith(status: ItemsStateStatus.loaded, items: items);
      },
    );
  }

  Future<void> getTopSellingItems({int limit = 10}) async {
    print(
      'getTopSellingItems: Starting, current items count: ${state.items.length}',
    );
    // Don't change the main status to loading if we already have items loaded
    // This prevents clearing the existing items data
    if (state.items.isEmpty) {
      state = state.copyWith(status: ItemsStateStatus.loading);
    }

    final result = await _repository.getTopSellingItems(limit: limit);

    result.fold(
      (failure) {
        print('getTopSellingItems: Error - ${failure.message}');
        state = state.copyWith(
          status: ItemsStateStatus.error,
          errorMessage: failure.message,
        );
      },
      (items) {
        print(
          'getTopSellingItems: Success, loaded ${items.length} top selling items. Current items count: ${state.items.length}',
        );
        state = state.copyWith(
          status: ItemsStateStatus.loaded,
          topSellingItems: items,
        );
      },
    );
  }

  Future<void> searchItems(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        searchResults: [],
        searchQuery: '',
        status: ItemsStateStatus.loaded,
      );
      return;
    }

    state = state.copyWith(
      status: ItemsStateStatus.searchLoading,
      searchQuery: query,
    );

    final result = await _repository.searchItems(query);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: ItemsStateStatus.error,
            errorMessage: failure.message,
          ),
      (items) =>
          state = state.copyWith(
            status: ItemsStateStatus.searchLoaded,
            searchResults: items,
          ),
    );
  }

  Future<void> getAnalyticsData() async {
    // Only set analytics loading status, don't interfere with main status
    if (state.status != ItemsStateStatus.loading &&
        state.status != ItemsStateStatus.error) {
      state = state.copyWith(status: ItemsStateStatus.analyticsLoading);
    }

    final result = await _repository.getAnalyticsData();

    result.fold(
      (failure) =>
          state = state.copyWith(
            errorMessage: failure.message,
            // Don't change status to error if we have items loaded
            status:
                state.items.isNotEmpty
                    ? ItemsStateStatus.loaded
                    : ItemsStateStatus.error,
          ),
      (analytics) =>
          state = state.copyWith(
            status:
                state.items.isNotEmpty
                    ? ItemsStateStatus.loaded
                    : ItemsStateStatus.analyticsLoaded,
            analyticsData: analytics,
          ),
    );
  }

  Future<void> getProductsByCategory() async {
    final result = await _repository.getProductsByCategory();

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (categories) => state = state.copyWith(productsByCategory: categories),
    );
  }

  Future<void> getWeeklyAnalytics() async {
    final result = await _repository.getWeeklyAnalytics();

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (weeklyData) => state = state.copyWith(weeklyAnalytics: weeklyData),
    );
  }

  Future<void> loadAllAnalytics() async {
    try {
      await Future.wait([
        getAnalyticsData(),
        getProductsByCategory(),
        getWeeklyAnalytics(),
      ]);
    } catch (e) {
      // Don't let analytics errors affect the main items data
      print('Analytics loading error: $e');
    }
  }

  Future<void> addItem(ItemModel item) async {
    state = state.copyWith(status: ItemsStateStatus.addingItem);

    final result = await _repository.addItem(item);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: ItemsStateStatus.error,
            errorMessage: failure.message,
          ),
      (newItem) {
        final updatedItems = [...state.items, newItem];
        state = state.copyWith(
          status: ItemsStateStatus.itemAdded,
          items: updatedItems,
        );
        // Refresh analytics after adding new item
        loadAllAnalytics();
      },
    );
  }

  Future<void> updateItem(ItemModel item) async {
    state = state.copyWith(status: ItemsStateStatus.updatingItem);

    final result = await _repository.updateItem(item);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: ItemsStateStatus.error,
            errorMessage: failure.message,
          ),
      (_) {
        final updatedItems =
            state.items.map((i) => i.id == item.id ? item : i).toList();
        state = state.copyWith(
          status: ItemsStateStatus.itemUpdated,
          items: updatedItems,
        );
        // Refresh analytics after updating item
        loadAllAnalytics();
      },
    );
  }

  Future<void> deleteItem(String id) async {
    state = state.copyWith(status: ItemsStateStatus.deletingItem);

    final result = await _repository.deleteItem(id);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: ItemsStateStatus.error,
            errorMessage: failure.message,
          ),
      (_) {
        final updatedItems =
            state.items.where((item) => item.id != id).toList();
        state = state.copyWith(
          status: ItemsStateStatus.itemDeleted,
          items: updatedItems,
        );
        // Refresh analytics after deleting item
        loadAllAnalytics();
      },
    );
  }

  void clearSearch() {
    state = state.copyWith(
      searchResults: [],
      searchQuery: '',
      status: ItemsStateStatus.loaded,
    );
  }

  void resetState() {
    state = const ItemsState();
  }
}
