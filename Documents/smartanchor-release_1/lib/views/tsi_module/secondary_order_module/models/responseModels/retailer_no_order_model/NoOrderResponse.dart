class NoOrderResponse {
  String? message;

  NoOrderResponse({this.message});

  NoOrderResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
