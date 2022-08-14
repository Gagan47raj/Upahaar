import 'package:cloud_firestore/cloud_firestore.dart';

class Posts
{
  String? postID;
  String? donarUID;
  String? postTitle;
  String? postInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;
  String? postLocation;

  Posts({
    this.postID,
    this.donarUID,
    this.postTitle,
    this.postInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
    this.postLocation,
  });

  Posts.fromJson(Map<String, dynamic> json)
  {
    postID = json["postID"];
    donarUID = json['donarUID'];
    postTitle = json['postTitle'];
    postInfo = json['postInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
    postLocation = json['postLocation'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['postID'] = postID;
    data['donarUID'] = donarUID;
    data['postTitle'] = postTitle;
    data['postInfo'] = postInfo;
    data['publishedData'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['postLocation'] = postLocation;

    return data;
  }
}