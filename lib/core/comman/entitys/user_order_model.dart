class UserOrderModel {
  final String orderId;
  final int userId;
  final String address;
  final String region;
  final String userName;
  final int addressId;
  final DateTime orderCreatedAt;
  final int itemCurrentQuantity;
  final String itemId;
  final String itemName;
  final String imageUrl;
  final int totalQuantity;
  final int quantity;
  final double itemPrice;
  final double totalPrice;
  final String orderState;
  final List<UserOrderModel> items;

  UserOrderModel({
    this.orderId = '',
    this.userId = 0,
    this.address = '',
    this.region = '',
    this.userName = '',
    this.addressId = 0,
    this.totalPrice = 0.0,
    this.totalQuantity = 0,
    this.quantity = 0,
    this.itemCurrentQuantity = 0,
    DateTime? orderCreatedAt,
    this.itemId = '',
    this.itemName = '',
    this.imageUrl = '',
    this.itemPrice = 0.0,
    this.orderState = '',
    this.items = const [],
  }) : orderCreatedAt = orderCreatedAt ?? DateTime.now();

  /// Factory constructor to create an instance from a map
  factory UserOrderModel.fromMap(Map<String, dynamic> map) {
    return UserOrderModel(
      orderId: map['order_id'] ?? '',
      userId: map['user_id'] ?? 0,
      itemCurrentQuantity: map['item_stock_quantity'] ?? 0,
      address: map['address'] ?? '',
      quantity: map['quantity'] ?? 0,
      region: map['region'] ?? '',
      userName: map['user_name'] ?? '',
      addressId: map['adress_id'] ?? 0,
      orderCreatedAt:
          map['order_created_at'] != null
              ? DateTime.parse(map['order_created_at'])
              : DateTime.now(),
      itemId: map['item_id'] ?? '',
      itemName: map['item_name'] ?? '',
      imageUrl: map['image_url'] ?? '',
      itemPrice: (map['item_price'] as num?)?.toDouble() ?? 0.0,
      orderState: map['state'] ?? '',
      items: map['items'] ?? [],
    );
  }

  /// Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'address': address,
      'region': region,
      'user_name': userName,
      'item_stock_quantity': itemCurrentQuantity,
      'adress_id': addressId,
      'order_created_at': orderCreatedAt.toIso8601String(),
      'item_id': itemId,
      'item_name': itemName,
      'image_url': imageUrl,
      'item_price': itemPrice,
      'quantity': quantity,
      'state': orderState,
      'items': items,
    };
  }

  /// Copy the object with modified values
  UserOrderModel copyWith({
    String? orderId,
    int? userId,
    String? address,
    String? region,
    int? totalQuantity,
    String? userName,
    int? itemCurrentQuantity,
    int? addressId,
    DateTime? orderCreatedAt,
    String? itemId,
    String? itemName,
    String? imageUrl,
    double? itemPrice,
    int? quantity,
    double? totalPrice,
    String? orderState,
    List<UserOrderModel>? items,
  }) {
    return UserOrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      region: region ?? this.region,
      itemCurrentQuantity: itemCurrentQuantity ?? this.itemCurrentQuantity,
      userName: userName ?? this.userName,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      addressId: addressId ?? this.addressId,
      orderCreatedAt: orderCreatedAt ?? this.orderCreatedAt,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      imageUrl: imageUrl ?? this.imageUrl,
      itemPrice: itemPrice ?? this.itemPrice,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      orderState: orderState ?? this.orderState,
      items: items ?? this.items,
    );
  }

  /// Check if the object has specific properties (null or empty check)
  bool has({
    String? orderId,
    int? userId,
    String? address,
    String? region,
    String? userName,
    int? totalQuantity,
    int? addressId,
    int? itemCurrentQuantity,
    String? itemId,
    String? itemName,
    String? imageUrl,
    String? orderState,
    List<UserOrderModel>? items,
    int? quantity,
    double? totalPrice,
  }) {
    return (orderId == null || this.orderId == orderId) &&
        (userId == null || this.userId == userId) &&
        (address == null || this.address == address) &&
        (region == null || this.region == region) &&
        (userName == null || this.userName == userName) &&
        (totalQuantity == null || this.totalQuantity == totalQuantity) &&
        (addressId == null || this.addressId == addressId) &&
        (itemId == null || this.itemId == itemId) &&
        (itemName == null || this.itemName == itemName) &&
        (imageUrl == null || this.imageUrl == imageUrl) &&
        (itemCurrentQuantity == null ||
            this.itemCurrentQuantity == itemCurrentQuantity) &&
        (orderState == null || this.orderState == orderState) &&
        (quantity == null || this.quantity == quantity) &&
        (totalPrice == null || this.totalPrice == totalPrice) &&
        (items == null || this.items == items);
  }

  /// String representation of the object
  @override
  String toString() {
    return 'OrderSummary(orderId: $orderId, userId: $userId, address: $address, region: $region, '
        'userName: $userName, addressId: $addressId, orderCreatedAt: $orderCreatedAt, itemId: $itemId, '
        'itemName: $itemName, imageUrl: $imageUrl, itemPrice: $itemPrice, quantity: $quantity, '
        'itemCurrentQuantity: $itemCurrentQuantity, totalPrice: $totalPrice, totalQuantity: $totalQuantity, orderState: $orderState, items: $items)';
  }
}
