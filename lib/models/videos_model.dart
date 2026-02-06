import 'dart:convert';

Videos videosFromMap(String str) => Videos.fromMap(json.decode(str));

class Videos {
  bool? success;
  String? message;
  List<VideosModel>? videos;

  Videos({this.success, this.message, this.videos});

  Videos copyWith({
    bool? success,
    String? message,
    List<VideosModel>? videos,
  }) => Videos(
    success: success ?? this.success,
    message: message ?? this.message,
    videos: videos ?? this.videos,
  );

  factory Videos.fromMap(Map<String, dynamic> json) => Videos(
    success: json["success"],
    message: json["message"],
    videos: json["data"]?["videos"] == null
        ? []
        : List<VideosModel>.from(
            json["data"]["videos"].map((x) => VideosModel.fromMap(x)),
          ),
  );
}

class VideosModel {
  int? id;
  String? videoTitle;
  String? videoUrl;
  List<String>? videoUrls;
  List<VideoFile>? videoFiles;
  String? status;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  VideosModel({
    this.id,
    this.videoTitle,
    this.videoUrl,
    this.videoUrls,
    this.videoFiles,
    this.status,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  VideosModel copyWith({
    int? id,
    String? videoTitle,
    String? videoUrl,
    List<String>? videoUrls,
    List<VideoFile>? videoFiles,
    String? status,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VideosModel(
    id: id ?? this.id,
    videoTitle: videoTitle ?? this.videoTitle,
    videoUrl: videoUrl ?? this.videoUrl,
    videoUrls: videoUrls ?? this.videoUrls,
    videoFiles: videoFiles ?? this.videoFiles,
    status: status ?? this.status,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory VideosModel.fromMap(Map<String, dynamic> json) {
   
    return VideosModel(
      id: json["id"],
      videoTitle: json["video_title"],
      videoUrl:json["video_url"],
      videoUrls: json["video_urls"] == null
          ? []
          : List<String>.from(json["video_urls"]),
      videoFiles: json["video_files"] == null
          ? []
          : List<VideoFile>.from(
              json["video_files"].map((x) => VideoFile.fromMap(x)),
            ),
      status: json["status"],
      description: json["description"],
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
    "video_title": videoTitle,
    "video_url": videoUrl,
    "video_urls": videoUrls,
    "video_files": videoFiles?.map((x) => x.toMap()).toList(),
    "status": status,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class VideoFile {
  int? id;
  String? url;
  String? title;
  String? source;

  VideoFile({this.id, this.url, this.title, this.source});

  VideoFile copyWith({int? id, String? url, String? title, String? source}) =>
      VideoFile(
        id: id ?? this.id,
        url: url ?? this.url,
        title: title ?? this.title,
        source: source ?? this.source,
      );

  factory VideoFile.fromMap(Map<String, dynamic> json) {
    String? fileUrl = json["url"];

    if (fileUrl != null && fileUrl.contains("127.0.0.1")) {
      fileUrl = fileUrl.replaceFirst(
        "http://127.0.0.1:8000",
        "https://admin.dracademy.pk",
      );
    }

    return VideoFile(
      id: json["id"],
      url: fileUrl,
      title: json["title"],
      source: (json["source"] ?? "").toLowerCase(),
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "url": url,
    "title": title,
    "source": source,
  };
}
