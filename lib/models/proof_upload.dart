

import 'dart:convert';

ProofUploads proofUploadsFromMap(String str) =>
    ProofUploads.fromMap(json.decode(str));


class ProofUploads {
  bool? success;
  String? message;
  List<ProofUploadModel>? proofUploads;

  ProofUploads({
    this.success,
    this.message,
    this.proofUploads,
  });

  ProofUploads copyWith({
    bool? success,
    String? message,
    List<ProofUploadModel>? proofUploads,
  }) =>
      ProofUploads(
        success: success ?? this.success,
        message: message ?? this.message,
        proofUploads: proofUploads ?? this.proofUploads,
      );

  factory ProofUploads.fromMap(Map<String, dynamic> json) => ProofUploads(
        success: json["success"],
        message: json["message"],
        proofUploads: json["data"]?["proof_uploads"] == null
            ? []
            : List<ProofUploadModel>.from(
                json["data"]["proof_uploads"]
                    .map((x) => ProofUploadModel.fromMap(x)),
              ),
      );
}



class ProofUploadModel {
  int? id;
  String? tradingAccountId;
  String? status; // Pending | Approved | Rejected
  String? depositScreenshotUrl;
  String? optionalScreenshotUrl;
  String? rejectionReason;
  DateTime? verifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProofUploadModel({
    this.id,
    this.tradingAccountId,
    this.status,
    this.depositScreenshotUrl,
    this.optionalScreenshotUrl,
    this.rejectionReason,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  ProofUploadModel copyWith({
    int? id,
    String? tradingAccountId,
    String? status,
    String? depositScreenshotUrl,
    String? optionalScreenshotUrl,
    String? rejectionReason,
    DateTime? verifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ProofUploadModel(
        id: id ?? this.id,
        tradingAccountId: tradingAccountId ?? this.tradingAccountId,
        status: status ?? this.status,
        depositScreenshotUrl:
            depositScreenshotUrl ?? this.depositScreenshotUrl,
        optionalScreenshotUrl:
            optionalScreenshotUrl ?? this.optionalScreenshotUrl,
        rejectionReason: rejectionReason ?? this.rejectionReason,
        verifiedAt: verifiedAt ?? this.verifiedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ProofUploadModel.fromMap(Map<String, dynamic> json) {
    String? depositUrl = json["deposit_screenshot_url"];
    String? optionalUrl = json["optional_screenshot_url"];

    if (depositUrl != null && depositUrl.contains("localhost")) {
      depositUrl = depositUrl.replaceFirst(
        "http://localhost",
        "https://admin.dracademy.pk",
      );
    }

    if (optionalUrl != null && optionalUrl.contains("localhost")) {
      optionalUrl = optionalUrl.replaceFirst(
        "http://localhost",
        "https://admin.dracademy.pk",
      );
    }

    return ProofUploadModel(
      id: json["id"],
      tradingAccountId: json["trading_account_id"],
      status: json["status"],
      depositScreenshotUrl: depositUrl,
      optionalScreenshotUrl: optionalUrl,
      rejectionReason: json["rejection_reason"],
      verifiedAt: json["verified_at"] == null
          ? null
          : DateTime.parse(json["verified_at"]),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "trading_account_id": tradingAccountId,
        "status": status,
        "deposit_screenshot_url": depositScreenshotUrl,
        "optional_screenshot_url": optionalScreenshotUrl,
        "rejection_reason": rejectionReason,
        "verified_at": verifiedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
