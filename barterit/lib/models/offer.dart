class Offer {
  String? takeId = "";
  String? giveId = "";

  Offer({this.takeId, this.giveId});

  Offer.fromJson(Map<String, dynamic> json) {
    giveId = json['offer_giveid'];
    takeId = json['offer_takeid'];
  }
}
