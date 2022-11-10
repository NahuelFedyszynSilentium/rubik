class TokenModel{
  String? token; //token
  String? expiration; //expiracion

  TokenModel({
    this.token,
    this.expiration
  });

  TokenModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiracion'];
  }

}