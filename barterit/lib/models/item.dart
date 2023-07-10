class Item {
  String? itemId;
  String? userId;
  String? itemName;
  String? itemPrice;
  String? itemType;
  String? itemImageCount;
  String? itemDesc;
  String? itemQty;
  String? itemLat;
  String? itemLong;
  String? itemState;
  String? itemLocality;
  String? itemDate;
  String? itemBarterto;

  Item(
      {this.itemId,
      this.userId,
      this.itemName,
      this.itemPrice,
      this.itemType,
      this.itemImageCount,
      this.itemDesc,
      this.itemQty,
      this.itemLat,
      this.itemLong,
      this.itemState,
      this.itemLocality,
      this.itemDate,
      this.itemBarterto});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    itemName = json['item_name'];
    itemPrice = json['item_price'];
    itemType = json['item_type'];
    itemImageCount = json['item_imagecount'];
    itemDesc = json['item_desc'];
    itemQty = json['item_qty'];
    itemLat = json['item_lat'];
    itemLong = json['item_long'];
    itemState = json['item_state'];
    itemLocality = json['item_locality'];
    itemDate = json['item_datereg'];
    itemBarterto = json['item_barterto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['user_id'] = userId;
    data['item_name'] = itemName;
    data['item_price'] = itemPrice;
    data['item_type'] = itemType;
    data['item_imagecount'] = itemImageCount;
    data['item_desc'] = itemDesc;
    data['item_qty'] = itemQty;
    data['item_lat'] = itemLat;
    data['item_long'] = itemLong;
    data['item_state'] = itemState;
    data['item_locality'] = itemLocality;
    data['item_datereg'] = itemDate;
    data['item_barterto'] = itemBarterto;
    return data;
  }
}
