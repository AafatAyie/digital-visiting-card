import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/apps/basicDetail/basicDetailForm.dart';
import 'package:digitalcard/apps/landingPage.dart';
import 'package:digitalcard/constants.dart';
import 'package:digitalcard/models/socialDetail.dart';
import 'package:digitalcard/widgets/button.dart';
import 'package:digitalcard/widgets/textenterfield.dart';
import 'package:flutter/material.dart';

class SocialDetailFull extends StatefulWidget {
  @override
  _SocialDetailFullState createState() => _SocialDetailFullState();
}

class _SocialDetailFullState extends State<SocialDetailFull> {
  List<SocialDetail> detail;
  bool hasData = false;
  bool uploading = false;
  bool buildScreen = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  getSocialDetail() async {
    setState(() {
      buildScreen = false;
    });
    QuerySnapshot doc = await socialDetailRef
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
      List<SocialDetail> socialDetail = doc.documents
          .map<SocialDetail>((doc) => SocialDetail.fromDocument(doc))
          .toList();
      setState(() {
        // this.podcastCovers = podcastCovers;
        this.detail = socialDetail;
      });
      print('True HasData');
      linkedinTextEditingController.text = detail[0].linkedin;
      facebookTextEditingController.text = detail[0].facebook;
      instagramTextEditingController.text = detail[0].instagram;
      youtubeTextEditingController.text = detail[0].youtube;
      twitterTextEditingController.text = detail[0].twitter;
      pintrestTextEditingController.text = detail[0].pinterest;
    } else {
      print('False HasData');
    }
    setState(() {
      buildScreen = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getSocialDetail();
  }

  submit() async {
    setState(() {
      uploading = true;
    });
    if (hasData == true) {
      await socialDetailRef.document(ourUser.uid).updateData({
        'linkedin': linkedinTextEditingController.text,
        'facebook': facebookTextEditingController.text,
        'instagram': instagramTextEditingController.text,
        'youtube': youtubeTextEditingController.text,
        'twitter': twitterTextEditingController.text,
        'pinterest': pintrestTextEditingController.text,
        'timestamp': timestamp,
      });
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: Text(
            'Edited Social Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.green));
    } else {
      await socialDetailRef.document(ourUser.uid).setData({
        "uid": ourUser.uid,
        'linkedin': linkedinTextEditingController.text,
        'facebook': facebookTextEditingController.text,
        'instagram': instagramTextEditingController.text,
        'youtube': youtubeTextEditingController.text,
        'twitter': twitterTextEditingController.text,
        'pinterest': pintrestTextEditingController.text,
        'timestamp': timestamp,
      });
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: Text(
            'Uploaded Social Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.green));
    }

    setState(() {
      uploading = false;
    });
  }

  TextEditingController linkedinTextEditingController = TextEditingController();
  TextEditingController facebookTextEditingController = TextEditingController();
  TextEditingController instagramTextEditingController =
      TextEditingController();
  TextEditingController twitterTextEditingController = TextEditingController();
  TextEditingController youtubeTextEditingController = TextEditingController();
  TextEditingController pintrestTextEditingController = TextEditingController();

  final linkedinFocusNode = FocusNode();
  final facebookFocusNode = FocusNode();
  final instagramFocusNode = FocusNode();
  // final phoneFocusNode = FocusNode();
  final twitterFocusNode = FocusNode();
  final youtubeFocusNode = FocusNode();
  final pintrestFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    linkedinTextEditingController.dispose();
    facebookTextEditingController.dispose();
    instagramTextEditingController.dispose();
    // phoneTextEditingController.dispose();
    twitterTextEditingController.dispose();
    youtubeTextEditingController.dispose();
    pintrestTextEditingController.dispose();
    linkedinFocusNode.dispose();
    facebookFocusNode.dispose();
    instagramFocusNode.dispose();
    // phoneFocusNode.dispose();
    twitterFocusNode.dispose();
    pintrestFocusNode.dispose();
    youtubeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Social Details'),
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: buildScreen == false
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: accent,
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ]),
              ),
              child: ListView(
                children: [
                  uploading == true
                      ? LinearProgressIndicator(
                          backgroundColor: Colors.green,
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  EnterTile(
                      title: 'LinkedIn',
                      extend: '    Do not include http://',
                      controller: linkedinTextEditingController,
                      nextNode: facebookFocusNode,
                      node: linkedinFocusNode),
                  SizedBox(
                    height: 5,
                  ),
                  EnterTile(
                      title: 'Facebook',
                      extend: '    Do not include http://',
                      controller: facebookTextEditingController,
                      nextNode: instagramFocusNode,
                      node: facebookFocusNode),
                  SizedBox(
                    height: 5,
                  ),
                  EnterTile(
                      title: 'Instagram',
                      extend: '    Do not include http://',
                      controller: instagramTextEditingController,
                      nextNode: twitterFocusNode,
                      node: instagramFocusNode),
                  SizedBox(
                    height: 5,
                  ),
                  EnterTile(
                      title: 'Twitter',
                      extend: '    Do not include http://',
                      controller: twitterTextEditingController,
                      nextNode: youtubeFocusNode,
                      node: twitterFocusNode),
                  SizedBox(
                    height: 5,
                  ),
                  EnterTile(
                      title: 'YouTube',
                      extend: '    Do not include http://',
                      controller: youtubeTextEditingController,
                      nextNode: pintrestFocusNode,
                      node: youtubeFocusNode),
                  SizedBox(
                    height: 5,
                  ),
                  EnterTile(
                      title: 'Pintrest',
                      extend: '    Do not include http://',
                      controller: pintrestTextEditingController,
                      action: TextInputAction.done,
                      node: pintrestFocusNode),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Button(
          text: 'Submit',
          onTap: () {
            submit();
            print('Done');
          },
        ),
      ),
    );
  }
}
