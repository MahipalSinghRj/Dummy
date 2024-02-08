class RetailerDropDownResponseModal {
  List<String> beat;
  List<String> district;
  List<Dealer> iaqDealer;
  List<Dealer> lightingDealer;
  List<Dealer> powerDealer;
  String state;

  RetailerDropDownResponseModal({
    required this.beat,
    required this.district,
    required this.iaqDealer,
    required this.lightingDealer,
    required this.powerDealer,
    required this.state,
  });

  factory RetailerDropDownResponseModal.fromJson(Map<String, dynamic> json) => RetailerDropDownResponseModal(
        beat: json["beat"] == null ? [] : List<String>.from(json["beat"].map((x) => x ?? '')),
        district: json["district"] == null ? [] : List<String>.from(json["district"].map((x) => x ?? '')),
        iaqDealer: json["iaqDealer"] == null ? [] : List<Dealer>.from(json["iaqDealer"].map((x) => Dealer.fromJson(x ?? {}))),
        lightingDealer: json["lightingDealer"] == null ? [] : List<Dealer>.from(json["lightingDealer"].map((x) => Dealer.fromJson(x ?? {}))),
        powerDealer: json["powerDealer"] == null ? [] : List<Dealer>.from(json["powerDealer"].map((x) => Dealer.fromJson(x ?? {}))),
        state: json["state"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "beat": List<dynamic>.from(beat.map((x) => x)),
        "district": List<dynamic>.from(district.map((x) => x)),
        "iaqDealer": List<dynamic>.from(iaqDealer.map((x) => x.toJson())),
        "lightingDealer": List<dynamic>.from(lightingDealer.map((x) => x.toJson())),
        "powerDealer": List<dynamic>.from(powerDealer.map((x) => x.toJson())),
        "state": state,
      };
}

class Dealer {
  String code;
  String name;

  Dealer({
    required this.code,
    required this.name,
  });

  factory Dealer.fromJson(Map<String, dynamic> json) => Dealer(
        code: json["code"] ?? '',
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
      };
}
