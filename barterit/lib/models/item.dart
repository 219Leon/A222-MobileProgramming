class Item {
  String? itemId;
  String? userId;
  String? itemName;
  String? itemDesc;
  String? itemPrice;
  String? itemDelivery;
  String? itemQty;
  String? itemState;
  String? itemLocal;
  String? itemLat;
  String? itemLng;
  String? itemDate;
  Item(
      {this.itemId,
      this.userId,
      this.itemName,
      this.itemPrice,
      this.itemDesc,
      this.itemQty,
      this.itemLat,
      this.itemLng,
      this.itemState,
      this.itemLocal,
      this.itemDate,});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    itemDesc = json['item_desc'];
    itemQty = json['item_qty'];
    itemLat = json['item_lat'];
    itemLng = json['item_lng'];
    itemState = json['item_state'];
    itemLocal = json['item_local'];
    itemDate = json['item_datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['user_id'] = userId;
    data['item_name'] = itemName;
    data['item_price'] = itemPrice;
    data['item_desc'] = itemDesc;
    data['item_qty'] = itemQty;
    data['item_lat'] = itemLat;
    data['item_lng'] = itemLng;
    data['item_state'] = itemState;
    data['item_local'] = itemLocal;
    data['item_datereg'] = itemDate;
    return data;
  }
}
