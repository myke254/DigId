class TokenModel {
  String? scope;
  String? tokenType;
  String? accessToken;
  int? expiresIn;
  String? refreshToken;

  TokenModel(
      {this.scope,
      this.tokenType,
      this.accessToken,
      this.expiresIn,
      this.refreshToken});

  TokenModel.fromJson(Map<String, dynamic> json) {
    scope = json['scope'];
    tokenType = json['token_type'];
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scope'] = scope;
    data['token_type'] = tokenType;
    data['access_token'] = accessToken;
    data['expires_in'] = expiresIn;
    data['refresh_token'] = refreshToken;
    return data;
  }
}