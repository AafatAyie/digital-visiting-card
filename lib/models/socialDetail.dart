import 'package:cloud_firestore/cloud_firestore.dart';

class SocialDetail {
  final String uid;
  final String linkedin;
  final String facebook;
  final String instagram;
  final String youtube;
  final String twitter;
  final String pinterest;
  final Timestamp timestamp;

  SocialDetail(
      {this.uid,
      this.linkedin,
      this.facebook,
      this.instagram,
      this.youtube,
      this.twitter,
      this.pinterest,
      this.timestamp});

  factory SocialDetail.fromDocument(DocumentSnapshot docs) {
    return SocialDetail(
      uid: docs['uid'],
      linkedin: docs['linkedin'],
      facebook: docs['facebook'],
      instagram: docs['instagram'],
      youtube: docs['youtube'],
      twitter: docs['twitter'],
      pinterest: docs['pinterest'],
      timestamp: docs['timestamp'],
    );
  }
}
