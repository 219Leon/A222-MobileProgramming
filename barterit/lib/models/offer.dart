class Offer {
  String? receiveId = "";
  String? giveId = "";

  Offer({this.receiveId, this.giveId});

  Offer.fromJson(Map<String, dynamic> json) {
    giveId = json['offer_giveid'];
    receiveId = json['offer_receiveid'];
  }
}
