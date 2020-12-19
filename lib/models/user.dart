import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final String level;
  final String referId;
  final int refernum;
  final bool isPremium;
  final Timestamp timestamp;
  // final int credit;
  // final String cource;
  // final String branch;
  // final int sem;
  // final String universityId;
  // final String courceId;
  // final String branchId;
  // final String semId;

  User(
      {this.uid,
      this.username,
      this.email,
      this.photoUrl,
      this.level,
      // this.credit,
      this.referId,
      this.refernum,
      this.isPremium,
      // this.cource,
      // this.branch,
      // this.sem,
      // this.universityId,
      // this.courceId,
      // this.branchId,
      // this.semId,
      this.timestamp});

  factory User.fromDocument(DocumentSnapshot docs) {
    return User(
      uid: docs['uid'],
      username: docs['username'],
      email: docs['email'],
      // credit: docs['credit'],
      photoUrl: docs['photoUrl'],
      level: docs['level'],
      referId: docs['referId'],
      refernum: docs['refernum'],
      isPremium: docs['isPremium'],
      // cource: docs['cource'],
      // sem: docs['sem'],
      // branch: docs['branch'],
      // universityId: docs['universityId'],
      // courceId: docs['courceId'],
      // branchId: docs['branchId'],
      // semId: docs['semId'],
      timestamp: docs['timestamp'],
    );
  }
}
