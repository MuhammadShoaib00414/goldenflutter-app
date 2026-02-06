import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class User {
  UserData? user;
  String? accessToken;
  String? tokenType;
  String? resetToken;
  int? expiresIn;
  String? refreshToken;

  User({
    this.user,
    this.accessToken,
    this.resetToken,
    this.tokenType,
    this.expiresIn,
    this.refreshToken,
  });

  User copyWith({
    UserData? user,
    String? accessToken,
    String? resetToken,
    String? tokenType,
    int? expiresIn,
    String? refreshToken,
  }) => User(
    user: user ?? this.user,
    accessToken: accessToken ?? this.accessToken,
    resetToken: resetToken ?? this.resetToken,
    tokenType: tokenType ?? this.tokenType,
    expiresIn: expiresIn ?? this.expiresIn,
    refreshToken: refreshToken ?? this.refreshToken,
  );

  factory User.fromMap(Map<String, dynamic> json) => User(
    user: json["user"] == null ? null : UserData.fromMap(json["user"]),
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    refreshToken: json["refresh_token"],
    resetToken: json["reset_token"],
  );

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'refresh_token': refreshToken,
    };
  }

  Map<String, dynamic> toMapToResetForgottenPassword() {
    return {
      'email': user?.email,
      'reset_token': resetToken,
      'password': user?.password,
      'password_confirmation': user?.password,
    };
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(User: $user,      accessToken: $accessToken, tokenType: $tokenType, resetToken: $resetToken, expiresIn: $expiresIn, refreshToken: $refreshToken)';
  }
}

class UserData {
  String? role;
  int? id;
  String? fullName;
  String? firstName;
  String? lastName;
  String? email;
  String? avatar;
  String? status;
  String? password;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? otp;
  DateTime? subscriptionExpire;
  UserData({
    this.role,
    this.id,
    this.fullName,
    this.status,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.avatar,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.otp,
    this.subscriptionExpire,
  });

  UserData copyWith({
    String? role,
    int? id,
    String? fullName,
    String? firstName,
    String? lastName,
    String? status,
    String? email,
    String? password,
    String? avatar,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? otp,
    DateTime? subscriptionExpire,
  }) => UserData(
    role: role ?? this.role,
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    status: status ?? this.status,
    password: password ?? this.password,
    otp: otp ?? this.otp,
    avatar: avatar ?? this.avatar,
    emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    subscriptionExpire: subscriptionExpire ?? this.subscriptionExpire,
  );

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
    role: json["role"],
    id: json["id"],
    fullName: json["full_name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    status: json["status"],
    email: json["email"],
    avatar: json["avatar"],
    emailVerifiedAt: json["email_verified_at"] == null
        ? null
        : DateTime.parse(json["email_verified_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    subscriptionExpire: json["subscription_expires_at"] == null
        ? null
        : DateTime.parse(json["subscription_expires_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "full_name": fullName,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "status": status,
    "role": role,
    "avatar": avatar,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "subscription_expires_at": subscriptionExpire?.toIso8601String(),
  };
  Map<String, dynamic> toMapToLogin() {
    return {
      'email': email,
      'password': password,
      'grant_type': 'password',
      "client_id": "019b946a-4488-705c-8b12-4811fab7c58c",
      "client_secret": "0Haz5u9RriLJgDClP88cDUscrIvTrHMolgJnZOqY",
    };
  }

  Map<String, dynamic> toMapToVerifyEmailOTP() {
    return {'email': email, 'otp': otp};
  }

  Map<String, dynamic> toMapToVerifyPasswordOTP() {
    final map = toMapToLogin();
    map['otp'] = otp;
    return map;
  }

  Map<String, dynamic> toMapToRegister() {
    return <String, dynamic>{
      'name': fullName,
      'email': email,
      'password': password,
      'country': 'Pakistan',
    };
  }

  @override
  String toString() {
    return 'UserData(id: $id, fullName: $fullName, firstName: $firstName, lastName: $lastName, email: $email, avatar: $avatar, password: $password, emailVerifiedAt: $emailVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt, otp: $otp, role:$role,subscriptionExpire:$subscriptionExpire)';
  }
}
