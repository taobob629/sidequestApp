/// id : 3
/// memberId : 16955
/// cardNumber : "44444444444"
/// cardName : null
/// expireDate : null
/// code : null
/// billAddress : null
/// sortcode : "01-00-61"
/// accountName : "test"
/// bankName : "NATIONAL WESTMINSTER BANK PLC"
class SimpleBankModel {
  SimpleBankModel({
    this.country,
    this.bank,
  });

  SimpleBankModel.fromJson(dynamic json) {
    country = json['country'];
    bank = json['bank'];
  }

  String? country;
  String? bank;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = country;
    map['bank'] = bank;
    return map;
  }
}

class BankCardModel {
  BankCardModel({
    required int id,
    num? memberId,
    String? cardNumber,
    String? cardName,
    String? expireDate,
    String? code,
    String? billAddress,
    String? sortcode,
    String? accountName,
    String? bankName,
    String? country,
  }) {
    _id = id;
    _memberId = memberId;
    _cardNumber = cardNumber;
    _cardName = cardName;
    _expireDate = expireDate;
    _code = code;
    _billAddress = billAddress;
    _sortcode = sortcode;
    _accountName = accountName;
    _bankName = bankName;
  }

  BankCardModel.fromJson(dynamic json) {
    _id = json['id'];
    _memberId = json['memberId'];
    _cardNumber = json['cardNumber'];
    _cardName = json['cardName'];
    _expireDate = json['expireDate'];
    _code = json['code'];
    _billAddress = json['billAddress'];
    _sortcode = json['sortcode'];
    _accountName = json['accountName'];
    _bankName = json['bankName'];
    _country = json['country'];
    _sortcode = json['sortcode'];
    _bankAddress = json['bankAddress'];
    _swift = json['swift'];
  }


  @override
  String toString() {
    return 'BankCardModel{_id: $_id, _memberId: $_memberId, _cardNumber: $_cardNumber, _cardName: $_cardName, _expireDate: $_expireDate, _code: $_code, _billAddress: $_billAddress, _sortcode: $_sortcode, _accountName: $_accountName, _bankName: $_bankName, _country: $_country, _bankAddress: $_bankAddress}';
  }

  late int _id;
  num? _memberId;
  String? _cardNumber;
  String? _cardName;
  String? _expireDate;
  String? _code;
  String? _billAddress;
  String? _sortcode;
  String? _accountName;
  String? _bankName;
  String? _country;
  String? _bankAddress;
  String? _swift;

  String? get swift => _swift;

  set swift(String? value) {
    _swift = value;
  }

  String? get bankAddress => _bankAddress;

  set bankAddress(String? value) {
    _bankAddress = value;
  }

  String? get country => _country;

  set country(String? value) {
    _country = value;
  }

  int get id => _id;

  num? get memberId => _memberId;

  String? get cardNumber => _cardNumber;

  dynamic get cardName => _cardName;

  dynamic get expireDate => _expireDate;

  dynamic get code => _code;

  dynamic get billAddress => _billAddress;

  String? get sortcode => _sortcode;

  String? get accountName => _accountName;

  String? get bankName => _bankName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['memberId'] = _memberId;
    map['cardNumber'] = _cardNumber;
    map['cardName'] = _cardName;
    map['expireDate'] = _expireDate;
    map['code'] = _code;
    map['billAddress'] = _billAddress;
    map['sortcode'] = _sortcode;
    map['accountName'] = _accountName;
    map['bankName'] = _bankName;
    return map;
  }
}
