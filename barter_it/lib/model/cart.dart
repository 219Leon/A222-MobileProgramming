class Cart {
  String? cartId;
  String? userId;
  String? traderId;
  String? itemId;
  String? traderItemId;
  String? cartQty;
  String? cartPrice;
  String? cartDate;
  String? itemName;
  String? itemDesc;
  String? itemDelivery;
  String? itemQty;
  String? itemState;
  String? itemLocal;
  String? itemLat;
  String? itemLng;
  String? itemDate;

  Cart({
    this.cartId,
    this.userId,
    this.traderId,
    this.itemId,
    this.traderItemId,
    this.cartQty,
    this.cartPrice,
    this.cartDate,
    this.itemName,
    this.itemDesc,
    this.itemDelivery,
    this.itemQty,
    this.itemState,
    this.itemLocal,
    this.itemLat,
    this.itemLng,
    this.itemDate,
  });

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    userId = json['user_id'];
    traderId = json['trader_id'];
    itemId = json['item_id'];
    traderItemId = json['trader_item_id'];
    cartQty = json['cart_qty'];
    cartPrice = json['cart_price'];
    cartDate = json['cart_date'];
    itemName = json['item_name'];
    itemDesc = json['item_desc'];
    itemDelivery = json['item_delivery'];
    itemQty = json['item_qty'];
    itemState = json['item_state'];
    itemLocal = json['item_local'];
    itemLat = json['item_lat'];
    itemLng = json['item_lng'];
    itemDate = json['item_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['user_id'] = userId;
    data['trader_id'] = traderId;
    data['item_id'] = itemId;
    data['trader_item_id'] = traderItemId;
    data['cart_qty'] = cartQty;
    data['cart_price'] = cartPrice;
    data['cart_date'] = cartDate;
    data['item_name'] = itemName;
    data['item_desc'] = itemDesc;
    data['item_delivery'] = itemDelivery;
    data['item_qty'] = itemQty;
    data['item_state'] = itemState;
    data['item_local'] = itemLocal;
    data['item_lat'] = itemLat;
    data['item_lng'] = itemLng;
    data['item_date'] = itemDate;
    return data;
  }
}