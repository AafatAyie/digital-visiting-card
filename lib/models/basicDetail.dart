import 'package:cloud_firestore/cloud_firestore.dart';

class BasicDetail {
  final String uid;
  final String post;
  final String company;
  final String address;
  final String mobileno;
  final String whatsappno;
  final String website;
  final Timestamp timestamp;

  BasicDetail(
      {this.uid,
      this.post,
      this.company,
      this.address,
      this.whatsappno,
      this.website,
      this.mobileno,
      this.timestamp});

  factory BasicDetail.fromDocument(DocumentSnapshot docs) {
    return BasicDetail(
      uid: docs['uid'],
      post: docs['post'],
      company: docs['company'],
      address: docs['address'],
      whatsappno: docs['whatsappno'],
      website: docs['website'],
      mobileno: docs['mobileno'],
      timestamp: docs['timestamp'],
    );
  }
}
