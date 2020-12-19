import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/apps/basicDetail/basicDetailForm.dart';
import 'package:digitalcard/apps/nav.dart';
import 'package:digitalcard/apps/profileShowScreen.dart';
import 'package:digitalcard/models/basicDetail.dart';
import 'package:digitalcard/models/socialDetail.dart';
import 'package:digitalcard/models/user.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digitalcard/apps/homePage.dart';
import 'package:digitalcard/apps/signIn/signInScreen.dart';
import 'package:digitalcard/services/auth.dart';

final usersRef = Firestore.instance.collection('users');
final basicDetailRef = Firestore.instance.collection('basicDetail');
final socialDetailRef = Firestore.instance.collection('socialDetail');
final StorageReference storageRef = FirebaseStorage.instance.ref();

DateTime timestamp = DateTime.now();

User ourUser;
bool hasCard = false;

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void fetchLinkData() async {
    // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
    var link = await FirebaseDynamicLinks.instance.getInitialLink();

    // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
    handleLinkData(link);

    // This will handle incoming links if the application is already opened
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      handleLinkData(dynamicLink);
    });
  }

  void handleLinkData(PendingDynamicLinkData data) {
    final Uri uri = data?.link;
    if (uri != null) {
      final queryParams = uri.queryParameters;
      if (queryParams.length > 0) {
        String userId = queryParams["userid"];
        // verify the username is parsed correctly
        print("My users username is: $userId");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfileShowScreen(
                  userId: userId,
                )));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLinkData();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            return ThisPage(
              user: user,
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

//TODO: THis Page

class ThisPage extends StatefulWidget {
  final User user;

  const ThisPage({Key key, @required this.user}) : super(key: key);
  @override
  _ThisPageState createState() => _ThisPageState();
}

class _ThisPageState extends State<ThisPage> {
  bool loadedPage = false;
  bool hasData = false;
  List<BasicDetail> detail;

  getBasicDetail() async {
    QuerySnapshot doc = await basicDetailRef
        .where('uid', isEqualTo: ourUser.uid)
        .getDocuments();
    setState(() {
      if (doc.documents.isEmpty) {
        hasData = false;
      } else {
        hasData = true;
      }
    });
    print(hasData);
    if (hasData == true) {
      List<BasicDetail> basicDetail = doc.documents
          .map<BasicDetail>((doc) => BasicDetail.fromDocument(doc))
          .toList();
      setState(() {
        // this.podcastCovers = podcastCovers;
        this.detail = basicDetail;
      });
      print('True HasData');
    } else {
      print('False HasData');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BasicDetailFull()));
    }
  }

  getUser() async {
    setState(() {
      loadedPage = false;
    });
    print('Loading Our Users..');
    DocumentSnapshot doc = await usersRef.document(widget.user.uid).get();
    User user = User.fromDocument(doc);
    setState(() {
      ourUser = user;
    });
    print(ourUser.uid);
    setState(() {
      print('${ourUser.username}');
    });
    print('Loaded Our Done');
    await getBasicDetail();
    print('All Done');
    setState(() {
      loadedPage = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  buildPage() {
    if (ourUser == null || loadedPage == false) {
      return OfflineNav();
    } else {
      return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildPage();
  }
}
