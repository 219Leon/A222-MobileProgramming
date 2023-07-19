class Transaction {
  String? transactionId;
  String? barterBill;
  String? orderPaid;
  String? userId;
  String? traderId;
  String? orderDate;
  String? orderStatus;
  String? orderLat;
  String? orderLng;

  Transaction(
      {this.transactionId,
      this.barterBill,
      this.orderPaid,
      this.userId,
      this.traderId,
      this.orderDate,
      this.orderStatus,
      this.orderLat,
      this.orderLng});

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    barterBill = json['barter_bill'];
    orderPaid = json['order_paid'];
    userId = json['user_id'];
    traderId = json['trader_id'];
    orderDate = json['order_date'];
    orderStatus = json['order_status'];
    orderLat = json['order_lat'];
    orderLng = json['order_lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['barter_bill'] = barterBill;
    data['order_paid'] = orderPaid;
    data['buyer_id'] = userId;
    data['trader_id'] = traderId;
    data['order_date'] = orderDate;
    data['order_status'] = orderStatus;
    data['order_lat'] = orderLat;
    data['order_lng'] = orderLng;
    return data;
  }
  
}
