class Transaction{
  String? receiveId = "";
  String? giveId = "";

  Transaction({this.receiveId, this.giveId});

  Transaction.fromJson(Map<String, dynamic> json){
    receiveId = json['transaction_receiveid'];
    giveId = json['transaction_giveid']; 
  }
}