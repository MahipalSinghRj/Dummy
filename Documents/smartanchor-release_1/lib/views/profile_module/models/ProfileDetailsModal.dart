class ProfileDetailsModal {
  String bu;
  String dealerCode;
  String dealerName;
  String dob;
  String email;
  String fname;
  String image;
  String lname;
  String manager;
  String managerRole;
  String phone;
  String role;
  String state;
  String zone;

  ProfileDetailsModal({
    this.bu = '',
    this.dealerCode = '',
    this.dealerName = '',
    this.dob = '',
    this.email = '',
    this.fname = '',
    this.image = '',
    this.lname = '',
    this.manager = '',
    this.managerRole = '',
    this.phone = '',
    this.role = '',
    this.state = '',
    this.zone = '',
  });

  factory ProfileDetailsModal.fromJson(Map<String, dynamic> json) =>
      ProfileDetailsModal(
        bu: json["bu"] ?? "",
        dealerCode: json["dealerCode"] ?? "",
        dealerName: json["dealerName"] ?? "",
        dob: json["dob"] ?? "",
        email: json["email"] ?? "",
        fname: json["fname"] ?? "",
        image: json["image"] ?? "",
        lname: json["lname"] ?? "",
        manager: json["manager"] ?? "",
        managerRole: json["managerRole"] ?? "",
        phone: json["phone"] ?? "",
        role: json["role"] ?? "",
        state: json["state"] ?? "",
        zone: json["zone"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "bu": bu,
        "dealerCode": dealerCode,
        "dealerName": dealerName,
        "dob": dob,
        "email": email,
        "fname": fname,
        "image": image,
        "lname": lname,
        "manager": manager,
        "managerRole": managerRole,
        "phone": phone,
        "role": role,
        "state": state,
        "zone": zone,
      };
}
