// To parse this JSON data, do
//
//     final subscription = subscriptionFromMap(jsonString);

import 'dart:convert';

Subscription subscriptionFromMap(String str) =>
    Subscription.fromMap(json.decode(str));

class Subscription {
  bool? success;
  String? message;
  List<SubscriptionData>? subscriptions;

  Subscription({this.success, this.message, this.subscriptions});

  Subscription copyWith({
    bool? success,
    String? message,
    List<SubscriptionData>? subscriptions,
  }) => Subscription(
    success: success ?? this.success,
    message: message ?? this.message,
    subscriptions: subscriptions ?? this.subscriptions,
  );

  factory Subscription.fromMap(Map<String, dynamic> json) => Subscription(
    success: json["success"],
    message: json["message"],
    subscriptions: json["data"]["subscriptions"] == null
        ? []
        : List<SubscriptionData>.from(
            json["data"]["subscriptions"]!.map(
              (x) => SubscriptionData.fromMap(x),
            ),
          ),
  );
}

class SubscriptionData {
  int? id;
  String? name;
  String? description;
  int? durationMonths;
  String? durationLabel;
  String? price;
  String? formattedPrice;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? networkType;
  String? address;

  SubscriptionData({
    this.id,
    this.name,
    this.description,
    this.durationMonths,
    this.durationLabel,
    this.price,
    this.formattedPrice,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.networkType,
  });

  SubscriptionData copyWith({
    int? id,
    String? name,
    String? description,
    int? durationMonths,
    String? durationLabel,
    String? price,
    String? formattedPrice,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? networkType,
    String? address,
  }) => SubscriptionData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    durationMonths: durationMonths ?? this.durationMonths,
    durationLabel: durationLabel ?? this.durationLabel,
    price: price ?? this.price,
    formattedPrice: formattedPrice ?? this.formattedPrice,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    address: address ?? this.address,
    networkType: networkType ?? this.networkType,
  );

  factory SubscriptionData.fromMap(Map<String, dynamic> json) =>
      SubscriptionData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        durationMonths: json["duration_months"],
        durationLabel: json["duration_label"],
        price: json["price"],
        formattedPrice: json["formatted_price"],
        address: json["address"],
        networkType: json["network_type"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "duration_months": durationMonths,
    "duration_label": durationLabel,
    "price": price,
    "formatted_price": formattedPrice,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "address": address,
    "network_type": networkType,
  };
}
