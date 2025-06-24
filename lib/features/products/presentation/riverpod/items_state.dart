import '../../../../core/comman/entitys/item_model.dart';
import '../../data/data_source/items_data_source.dart';

enum ItemsStateStatus {
  initial,
  loading,
  loaded,
  error,
  searchLoading,
  searchLoaded,
  analyticsLoading,
  analyticsLoaded,
  addingItem,
  itemAdded,
  updatingItem,
  itemUpdated,
  deletingItem,
  itemDeleted,
}

class ItemsState {
  final ItemsStateStatus status;
  final List<ItemModel> items;
  final List<ItemModel> topSellingItems;
  final List<ItemModel> searchResults;
  final List<AnalyticsData> analyticsData;
  final Map<String, int> productsByCategory;
  final Map<String, dynamic> weeklyAnalytics;
  final String? errorMessage;
  final String searchQuery;

  const ItemsState({
    this.status = ItemsStateStatus.initial,
    this.items = const [],
    this.topSellingItems = const [],
    this.searchResults = const [],
    this.analyticsData = const [],
    this.productsByCategory = const {},
    this.weeklyAnalytics = const {},
    this.errorMessage,
    this.searchQuery = '',
  });

  ItemsState copyWith({
    ItemsStateStatus? status,
    List<ItemModel>? items,
    List<ItemModel>? topSellingItems,
    List<ItemModel>? searchResults,
    List<AnalyticsData>? analyticsData,
    Map<String, int>? productsByCategory,
    Map<String, dynamic>? weeklyAnalytics,
    String? errorMessage,
    String? searchQuery,
  }) {
    return ItemsState(
      status: status ?? this.status,
      items: items ?? this.items,
      topSellingItems: topSellingItems ?? this.topSellingItems,
      searchResults: searchResults ?? this.searchResults,
      analyticsData: analyticsData ?? this.analyticsData,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      weeklyAnalytics: weeklyAnalytics ?? this.weeklyAnalytics,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemsState &&
        other.status == status &&
        other.items == items &&
        other.topSellingItems == topSellingItems &&
        other.searchResults == searchResults &&
        other.analyticsData == analyticsData &&
        other.productsByCategory == productsByCategory &&
        other.weeklyAnalytics == weeklyAnalytics &&
        other.errorMessage == errorMessage &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        items.hashCode ^
        topSellingItems.hashCode ^
        searchResults.hashCode ^
        analyticsData.hashCode ^
        productsByCategory.hashCode ^
        weeklyAnalytics.hashCode ^
        errorMessage.hashCode ^
        searchQuery.hashCode;
  }
}
