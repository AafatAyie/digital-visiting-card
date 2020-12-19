import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/apps/landingPage.dart';
import 'package:digitalcard/constants.dart';
import 'package:digitalcard/models/basicDetail.dart';
import 'package:digitalcard/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BasicDetailFull extends StatefulWidget {
  @override
  _BasicDetailFullState createState() => _BasicDetailFullState();
}

class _BasicDetailFullState extends State<BasicDetailFull> {
  List<BasicDetail> detail;
  bool hasData = false;
  bool uploading = false;
  bool buildScreen = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  getBasicDetail() async {
    setState(() {
      buildScreen = false;
    });
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
      postTextEditingController.text = detail[0].post;
      companyTextEditingController.text = detail[0].company;
      addressTextEditingController.text = detail[0].address;
      whatsappTextEditingController.text = detail[0].whatsappno.toString();
      websiteTextEditingController.text = detail[0].website;
      mobileTextEditingController.text = detail[0].mobileno.toString();
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
    getBasicDetail();
  }

  submit() async {
    setState(() {
      uploading = true;
    });
    if (hasData == true) {
      await basicDetailRef.document(ourUser.uid).updateData({
        'post': postTextEditingController.text,
        'company': companyTextEditingController.text,
        'address': addressTextEditingController.text,
        'whatsappno': whatsappTextEditingController.text,
        'website': websiteTextEditingController.text,
        'mobileno': mobileTextEditingController.text,
        'timestamp': timestamp,
      });
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: Text(
            'Edited Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.green));
    } else {
      await basicDetailRef.document(ourUser.uid).setData({
        "uid": ourUser.uid,
        'post': postTextEditingController.text,
        'company': companyTextEditingController.text,
        'address': addressTextEditingController.text,
        'whatsappno': whatsappTextEditingController.text,
        'website': websiteTextEditingController.text,
        'mobileno': mobileTextEditingController.text,
        'timestamp': timestamp,
      });
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
            content: Text(
              'Uploaded Details',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.green),
      );
    }

    setState(() {
      uploading = false;
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ThisPage(user: ourUser)));
  }

  TextEditingController companyTextEditingController = TextEditingController();
  TextEditingController postTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController mobileTextEditingController = TextEditingController();
  TextEditingController whatsappTextEditingController = TextEditingController();
  TextEditingController websiteTextEditingController = TextEditingController();

  final companyFocusNode = FocusNode();
  final postFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final mobileFocusNode = FocusNode();
  final whatsappFocusNode = FocusNode();
  final websiteFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    companyTextEditingController.dispose();
    postTextEditingController.dispose();
    addressTextEditingController.dispose();
    // phoneTextEditingController.dispose();
    mobileTextEditingController.dispose();
    whatsappTextEditingController.dispose();
    websiteTextEditingController.dispose();
    companyFocusNode.dispose();
    postFocusNode.dispose();
    addressFocusNode.dispose();
    // phoneFocusNode.dispose();
    mobileFocusNode.dispose();
    whatsappFocusNode.dispose();
    websiteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Basic Details'),
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
                          backgroundColor: accent,
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  EnterTile(
                      title: 'Company or Institution *',
                      controller: companyTextEditingController,
                      nextNode: postFocusNode,
                      node: companyFocusNode),

                  // ListTile(
                  //   title: TextEnterField(
                  //     labelText: 'COMPANY',
                  //     hintText: 'Enter Company Name',
                  //     node: companyFocusNode,
                  //     nextNode: postFocusNode,
                  //     controller: companyTextEditingController,
                  //   ),
                  // ),
                  EnterTile(
                      title: 'Post or Class *',
                      controller: postTextEditingController,
                      nextNode: addressFocusNode,
                      node: postFocusNode),
                  SizedBox(
                    height: 5,
                  ),
                  EnterTile(
                      title: 'Address *',
                      controller: addressTextEditingController,
                      nextNode: mobileFocusNode,
                      node: addressFocusNode),
                  SizedBox(
                    height: 5,
                  ),
                  EnterTile(
                      title: 'Mobile Number *',
                      extend: '    Use country code',
                      controller: mobileTextEditingController,
                      type: TextInputType.phone,
                      nextNode: whatsappFocusNode,
                      node: mobileFocusNode),
                  SizedBox(
                    height: 5,
                  ),
                  EnterTile(
                      title: 'WhatsApp Number *',
                      extend: '    Use country code',
                      controller: whatsappTextEditingController,
                      type: TextInputType.phone,
                      nextNode: websiteFocusNode,
                      node: whatsappFocusNode),
                  SizedBox(
                    height: 5,
                  ),
                  EnterTile(
                      title: 'Website',
                      controller: websiteTextEditingController,
                      nextNode: websiteFocusNode,
                      type: TextInputType.url,
                      action: TextInputAction.done,
                      node: websiteFocusNode),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Button(
          text: 'Submit',
          color: uploading == true ? Colors.grey : Colors.green,
          shadowColor: uploading == true ? Colors.grey : Colors.greenAccent,
          onTap: () {
            if (companyTextEditingController.text.length <= 0 ||
                postTextEditingController.text.length <= 0 ||
                addressTextEditingController.text.length <= 0 ||
                mobileTextEditingController.text.length <= 0 ||
                whatsappTextEditingController.text.length <= 0) {
              print('null');
              Fluttertoast.showToast(msg: 'Field can\'t be empty');
            } else {
              submit();
              print('Done');
            }
          },
        ),
      ),
    );
  }
}

class EnterTile extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode node;
  final FocusNode nextNode;
  final TextInputType type;
  final String extend;
  final TextInputAction action;

  const EnterTile(
      {Key key,
      @required this.title,
      @required this.controller,
      @required this.node,
      this.nextNode,
      this.type,
      this.extend,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: title,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                children: <TextSpan>[
                  TextSpan(
                    text: extend == null ? ' ' : extend,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 8),
                  ),
                ],
              ),
            ),
            // Text(
            //   title,
            //   style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            // ),
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: controller,
                  focusNode: node,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  autocorrect: false,
                  keyboardType: type == null ? TextInputType.text : type,
                  textInputAction:
                      action == null ? TextInputAction.next : action,
                  // onChanged: (email) => _updateState(),
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(nextNode);
                  },
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
