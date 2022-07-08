class JunoToken {
  String accessToken;
  String tokenType;
  int expiresIn;
  String scope;
  String userName;
  String jti;

  JunoToken(
      {this.accessToken,
        this.tokenType,
        this.expiresIn,
        this.scope,
        this.userName,
        this.jti});

  JunoToken.fromMap(Map<String, dynamic> map) {
    accessToken = map['access_token'];
    tokenType = map['token_type'];
    expiresIn = map['expires_in'];
    scope = map['scope'];
    userName = map['user_name'];
    jti = map['jti'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    data['scope'] = this.scope;
    data['user_name'] = this.userName;
    data['jti'] = this.jti;
    return data;
  }
}
