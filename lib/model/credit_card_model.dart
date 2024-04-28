class CreditCardModel {
  late String cardNumber = "";
  late String cardHolder = "";
  late String exDate = "";
  late String cvCode = "";

  CreditCardModel();

  CreditCardModel.fromJson(Map<String, dynamic> json) {
    cardNumber = json['cardNumber'];
    cardHolder = json['cardHolder'];
    exDate = json['exDate'];
    cvCode = json['cvCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardNumber'] = this.cardNumber;
    data['cardHolder'] = this.cardHolder;
    data['exDate'] = this.exDate;
    data['cvCode'] = this.cvCode;
    return data;
  }
}