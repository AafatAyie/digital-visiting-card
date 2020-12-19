import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/apps/basicDetail/basicDetailForm.dart';
import 'package:digitalcard/apps/landingPage.dart';
import 'package:digitalcard/constants.dart';
import 'package:digitalcard/models/basicDetail.dart';
import 'package:digitalcard/models/socialDetail.dart';
import 'package:digitalcard/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileShowScreen extends StatefulWidget {
  final String userId;

  ProfileShowScreen({Key key, this.userId}) : super(key: key);

  @override
  _ProfileShowScreenState createState() => _ProfileShowScreenState();
}

class _ProfileShowScreenState extends State<ProfileShowScreen> {
  User theUser;
  BasicDetail detail;
  SocialDetail socialDetail;
  bool hasData = false;
  bool hasLoaded = false;

  getUser() async {
    setState(() {
      hasLoaded = false;
    });
    print('Loading pROFILE Users..');
    DocumentSnapshot doc = await usersRef.document(widget.userId).get();
    User user = User.fromDocument(doc);
    setState(() {
      this.theUser = user;
    });
    print('Loaded pROFILE Users Done');
    print('Loaded BASIC ....');
    DocumentSnapshot detail =
        await basicDetailRef.document(widget.userId).get();
    setState(() {
      if (detail.exists) {
        hasData = true;
        BasicDetail basicDetail = BasicDetail.fromDocument(detail);
        setState(() {
          this.detail = basicDetail;
        });
      } else {
        hasData = false;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BasicDetailFull()));
      }
    });

    print('Loaded Social ....');
    DocumentSnapshot sDetail =
        await socialDetailRef.document(widget.userId).get();
    setState(() {
      if (sDetail.exists) {
        hasData = true;
        SocialDetail socialDetail = SocialDetail.fromDocument(sDetail);
        setState(() {
          this.socialDetail = socialDetail;
        });
      } else {
        hasData = false;
      }
    });

    print('DOne All ....');
    setState(() {
      hasLoaded = true;
    });
    print(socialDetail);
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  //!Call
  makeCall(String number) async {
    String url = "tel:$number";
    if (await canLaunch(url)) {
      Fluttertoast.showToast(msg: 'Opening Contact');
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //!Map
  openMapsSheet(String location) async {
    Fluttertoast.showToast(msg: 'Opening location in map');
    await MapsLauncher.launchQuery(location);
  }

  //!Mail
  makeMail() async {
    String url = "mailto:${theUser.email}";
    if (await canLaunch(url)) {
      Fluttertoast.showToast(msg: 'Opening Gmail');
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //!Message
  sendSMS(String number) async {
    String url = "sms:+91$number?body=Hello%20${theUser.username}";
    if (await canLaunch(url)) {
      Fluttertoast.showToast(msg: 'Opening Message');
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //!Whatapp Message
  void sendWhatsAppMessage() {
    String number = detail.whatsappno;
    // print(number);
    Fluttertoast.showToast(msg: 'Opening WhatsApp');
    FlutterOpenWhatsapp.sendSingleMessage(number, 'Hello ${theUser.username} ')
        .catchError((e) {
      Fluttertoast.showToast(msg: 'Error Opening WhatsApp');
    });
  }

  _launchURL(String url) async {
    String uri = "https://$url";
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasLoaded == false
          ? AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).accentColor,
              centerTitle: true,
              automaticallyImplyLeading: false,
            )
          : AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).accentColor,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      makeCall(detail.mobileno.toString());
                    },
                    child: AppBarIcon(
                      text: "Save Contact",
                      icon: Icons.contact_phone,
                    ),
                  ),
                  // SizedBox(width: 18),
                  GestureDetector(
                    onTap: () {
                      makeMail();
                    },
                    child: AppBarIcon(
                      text: "Send Email",
                      icon: Icons.email,
                    ),
                  ),
                  // SizedBox(width: 18),
                  GestureDetector(
                    onTap: () {
                      sendSMS(detail.mobileno.toString());
                    },
                    child: AppBarIcon(
                      text: "Send Message",
                      icon: Icons.textsms,
                    ),
                  ),
                  // SizedBox(width: 18),
                  GestureDetector(
                    onTap: () {
                      sendWhatsAppMessage();
                    },
                    child: AppBarIcon(
                      text: "WhatsApp Message",
                      icon: FontAwesomeIcons.whatsapp,
                    ),
                  ),
                  // SizedBox(width: 18),
                ],
              ),
            ),
      body: hasLoaded == false
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).accentColor,
                      Theme.of(context).primaryColor
                    ]),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Fetching User..')
                ],
              )),
            )
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).accentColor,
                        Theme.of(context).primaryColor
                      ]),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 65,
                            child: theUser.photoUrl.length == 0
                                ? Icon(Icons.person,
                                    size: 50, color: Colors.grey[200])
                                : null,
                            backgroundImage: theUser.photoUrl.length == 0
                                ? null
                                : NetworkImage(theUser.photoUrl),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 150,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 2,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2)),
                                  ),
                                  SizedBox(
                                    height: 38,
                                  ),
                                  Container(
                                    width: 150,
                                    child: Text(
                                      '${theUser.username}',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 38,
                                  ),
                                  Container(
                                    height: 2,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2)),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                    // ? Post
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: '${detail.post} at ${detail.company}');
                          },
                          child: Text('${detail.post}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Text('at ${detail.company}',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[300])),
                      ),
                    ),
                    //ListTiles
                    SizedBox(
                      height: 18,
                    ),
                    //! Social Accounts
                    socialDetail == null
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              socialDetail?.facebook == null ||
                                      socialDetail.facebook.length == 0
                                  ? SizedBox()
                                  : IconButton(
                                      icon: Icon(FontAwesomeIcons.facebook,
                                          color: Colors.white),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: 'Opening Facebook');
                                        _launchURL(socialDetail.facebook);
                                        print(socialDetail.facebook);
                                      }),
                              SizedBox(width: 6),
                              socialDetail?.instagram == null ||
                                      socialDetail.facebook.length == 0
                                  ? SizedBox()
                                  : IconButton(
                                      icon: Icon(FontAwesomeIcons.instagram,
                                          color: Colors.white),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: 'Opening Instagram');
                                        _launchURL(socialDetail.instagram);
                                        print(socialDetail.instagram);
                                      }),
                              SizedBox(width: 6),
                              socialDetail.twitter == null ||
                                      socialDetail.twitter.length == 0
                                  ? SizedBox()
                                  : IconButton(
                                      icon: Icon(FontAwesomeIcons.twitter,
                                          color: Colors.white),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: 'Opening Twitter');
                                        _launchURL(socialDetail.twitter);
                                        print(socialDetail.twitter);
                                      }),
                              SizedBox(width: 6),
                              socialDetail.youtube == null ||
                                      socialDetail.youtube.length == 0
                                  ? SizedBox()
                                  : IconButton(
                                      icon: Icon(FontAwesomeIcons.youtube,
                                          color: Colors.white),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: 'Opening Youtube');
                                        _launchURL(socialDetail.youtube);
                                        print(socialDetail.youtube);
                                      }),
                              SizedBox(width: 6),
                              socialDetail.linkedin == null ||
                                      socialDetail.linkedin.length == 0
                                  ? SizedBox()
                                  : IconButton(
                                      icon: Icon(FontAwesomeIcons.linkedin,
                                          color: Colors.white),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: 'Opening LinkedIn');
                                        _launchURL(socialDetail.linkedin);
                                        print(socialDetail.linkedin);
                                      }),
                              SizedBox(width: 6),
                              socialDetail.pinterest == null ||
                                      socialDetail.pinterest.length == 0
                                  ? SizedBox()
                                  : IconButton(
                                      icon: Icon(FontAwesomeIcons.pinterest,
                                          color: Colors.white),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: 'Opening Pintrest');
                                        _launchURL(socialDetail.pinterest);
                                        print(socialDetail.pinterest);
                                      }),
                            ],
                          ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Divider(
                              endIndent: 25,
                              indent: 25,
                              color: Colors.grey[800]),
                          //!Address
                          detail.address == null || detail.address.length == 0
                              ? SizedBox()
                              : ListTile(
                                  onTap: () {
                                    openMapsSheet(detail.address);
                                  },
                                  leading: Icon(
                                    Icons.home,
                                  ),
                                  title: Text('${detail.address}'),
                                  trailing: Icon(Icons.chevron_right, size: 30),
                                ),
                          detail.address == null || detail.address.length == 0
                              ? SizedBox()
                              : Divider(
                                  endIndent: 25,
                                  indent: 25,
                                  color: Colors.grey[800]),
                          //!Email
                          theUser.email == null || theUser.email.length == 0
                              ? SizedBox()
                              : ListTile(
                                  onTap: () {
                                    Fluttertoast.showToast(msg: 'Opening Mail');
                                    makeMail();
                                  },
                                  leading: Icon(
                                    Icons.mail,
                                  ),
                                  title: Text('${theUser.email}'),
                                  trailing: Icon(Icons.chevron_right, size: 30),
                                ),
                          theUser.email == null || theUser.email.length == 0
                              ? SizedBox()
                              : Divider(
                                  endIndent: 25,
                                  indent: 25,
                                  color: Colors.grey[800]),
                          //!Mobile Number
                          detail.mobileno == null ||
                                  detail.mobileno.toString().length == 0
                              ? SizedBox()
                              : ListTile(
                                  onTap: () {
                                    print('makeCall');
                                    print(detail.mobileno);
                                    makeCall(detail.mobileno.toString());
                                  },
                                  leading: Icon(Icons.phone),
                                  title: Text('${detail.mobileno}'),
                                  trailing: Icon(Icons.chevron_right, size: 30),
                                ),
                          detail.mobileno == null ||
                                  detail.mobileno.toString().length == 0
                              ? SizedBox()
                              : Divider(
                                  endIndent: 25,
                                  indent: 25,
                                  color: Colors.grey[800]),
                          //!WhatsApp
                          detail.whatsappno == null ||
                                  detail.whatsappno.toString().length == 0
                              ? SizedBox()
                              : ListTile(
                                  onTap: () {
                                    sendWhatsAppMessage();
                                  },
                                  leading:
                                      Icon(FontAwesomeIcons.whatsapp, size: 23),
                                  title: Text('${detail.whatsappno}'),
                                  trailing: Icon(Icons.chevron_right, size: 30),
                                ),
                          detail.whatsappno == null ||
                                  detail.whatsappno.toString().length == 0
                              ? SizedBox()
                              : Divider(
                                  endIndent: 25,
                                  indent: 25,
                                  color: Colors.grey[800]),
                          //!Website
                          detail.website == null || detail.website.length == 0
                              ? SizedBox()
                              : ListTile(
                                  onTap: () {
                                    Fluttertoast.showToast(
                                        msg: 'Opening ${detail.website}');
                                    _launchURL(detail.website);
                                  },
                                  leading:
                                      Icon(FontAwesomeIcons.globe, size: 23),
                                  title: Text('${detail.website}'),
                                  trailing: Icon(Icons.chevron_right, size: 30),
                                ),
                          detail.website == null || detail.website.length == 0
                              ? SizedBox()
                              : Divider(
                                  endIndent: 25,
                                  indent: 25,
                                  color: Colors.grey[800]),
                        ],
                      ),
                    ),
                    // SizedBox(height: 8),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     IconButton(
                    //         icon: Icon(FontAwesomeIcons.facebook,
                    //             color: Colors.white),
                    //         onPressed: null),
                    //     SizedBox(width: 6),
                    //     IconButton(
                    //         icon: Icon(FontAwesomeIcons.instagram,
                    //             color: Colors.white),
                    //         onPressed: null),
                    //     SizedBox(width: 6),
                    //     IconButton(
                    //         icon: Icon(FontAwesomeIcons.twitter,
                    //             color: Colors.white),
                    //         onPressed: null),
                    //     SizedBox(width: 6),
                    //     IconButton(
                    //         icon: Icon(FontAwesomeIcons.youtube,
                    //             color: Colors.white),
                    //         onPressed: null),
                    //     SizedBox(width: 6),
                    //     IconButton(
                    //         icon: Icon(FontAwesomeIcons.linkedin,
                    //             color: Colors.white),
                    //         onPressed: null),
                    //     SizedBox(width: 6),
                    //     IconButton(
                    //         icon: Icon(FontAwesomeIcons.pinterest,
                    //             color: Colors.white),
                    //         onPressed: null),
                    //   ],
                    // ),
                    //?Company Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(appName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20)),
                        Text('.',
                            style:
                                TextStyle(color: Colors.green, fontSize: 50)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class AppBarIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const AppBarIcon({Key key, @required this.icon, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(
          height: 2,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 10),
        )
      ],
    );
  }
}
