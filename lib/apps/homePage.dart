import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/apps/basicDetail/basicDetailForm.dart';
import 'package:digitalcard/apps/basicDetail/photoDetailForm.dart';
import 'package:digitalcard/apps/basicDetail/socialDetailForm.dart';
import 'package:digitalcard/apps/extraScreen.dart';
import 'package:digitalcard/apps/landingPage.dart';
import 'package:digitalcard/apps/showShareBottom.dart';
import 'package:digitalcard/constants.dart';
import 'package:digitalcard/models/basicDetail.dart';
import 'package:digitalcard/models/socialDetail.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:digitalcard/apps/profileShowScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:digitalcard/apps/profileShowScreen.dart';
import 'package:digitalcard/services/auth.dart';
import 'package:digitalcard/widgets/platform_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> name = [''];
  String firstName = 'User';
  BasicDetail basicDetail;
  SocialDetail socialDetail;

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  getBasicDetail() async {
    print('Loading Basic Detail..');
    DocumentSnapshot doc = await basicDetailRef.document(ourUser.uid).get();
    BasicDetail basicDetail = BasicDetail.fromDocument(doc);
    setState(() {
      this.basicDetail = basicDetail;
    });
    print('Basic Detail Done');
  }

  getSocialDetail() async {
    print('Loading Social Detail ..');
    DocumentSnapshot doc = await socialDetailRef.document(ourUser.uid).get();
    SocialDetail socialDetail = SocialDetail.fromDocument(doc);
    setState(() {
      this.socialDetail = socialDetail;
    });
    print('Social Detail Done');
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      name = ourUser.username.split(" ");
      firstName = name[0];
    });
    createDynameic();
    // getSocialDetail();
    // getBasicDetail();
  }

  createDynameic() async {
    setState(() {
      _isCreatingLink = true;
    });
    var dynamicLink = await createDynamicLink(userId: ourUser.uid);
    setState(() {
      _linkMessage = dynamicLink.toString();
    });
    setState(() {
      _isCreatingLink = false;
    });
  }

  String _linkMessage = 'Loading';

  bool _isCreatingLink = false;

  Future<Uri> createDynamicLink({@required String userId}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // This should match firebase but without the username query param
      uriPrefix: 'https://allaboutmee.page.link',
      // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
      link: Uri.parse('https://allaboutmee.page.link/mcard?userid=$userId'),
      androidParameters: AndroidParameters(
        packageName: 'com.onnuva.digitalcard',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.onnuva.digitalcard',
        minimumVersion: '1',
        appStoreId: '',
      ),
    );
    final link = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    return shortenedLink.shortUrl;
  }

  _buildCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfileShowScreen(userId: ourUser.uid)));
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.grey[800], Color(0xFF445849)]),
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 155,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PhotoDetailForm()));
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 12,
                                child: ourUser.photoUrl.length == 0
                                    ? Icon(Icons.add_a_photo,
                                        size: 30, color: Colors.grey[200])
                                    : null,
                                backgroundImage: ourUser.photoUrl.length == 0
                                    ? null
                                    : NetworkImage(ourUser.photoUrl),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Container(
                              width: 135,
                              child: Container(
                                width: 135,
                                child: Text(
                                  firstName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(appName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.white,
                                    )),
                                Text('.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: accent,
                                        fontSize: 30)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('View Digital Card >>',
                                  style: TextStyle(fontSize: 12))),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 140,
              child: Text('Hello $firstName',
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600)),
            ),
            GestureDetector(
              onTap: _linkMessage.length <= 7
                  ? () {
                      Fluttertoast.showToast(msg: 'Loading Sharable Link');
                    }
                  : () {
                      showAddUniversityBottom(
                          context: context, link: _linkMessage);
                      Clipboard.setData(ClipboardData(text: _linkMessage));
                    },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.white)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.share, size: 16),
                      SizedBox(
                        width: 7,
                      ),
                      Text('Share', style: TextStyle()),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        centerTitle: true,
        actions: [
          // Container(
          //   alignment: Alignment.center,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          //     child: GestureDetector(
          //       onTap: () async {
          //         print('Log Out');
          //         await _confirmSignOut(context);
          //         Navigator.pop(context);
          //       },
          //       child: AppBarIcon(
          //         text: "Log Out",
          //         icon: Icons.exit_to_app,
          //       ),
          //     ),
          //   ),
          // ),
          PopupMenuButton(itemBuilder: (context) {
            return [
              // PopupMenuItem(
              //   child: GestureDetector(
              //     onTap: () async {
              //       print('Log Out');
              //       await _confirmSignOut(context);
              //       Navigator.pop(context);
              //     },
              //     child: Row(
              //       children: [
              //         Icon(Icons.exit_to_app),
              //         SizedBox(width: 5),
              //         Text('Log Out')
              //       ],
              //     ),
              //   ),
              // ),
              PopupMenuItem(
                child: InkWell(
                  onTap: () async {
                    print('Log Out');
                    await _confirmSignOut(context);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 5),
                      Text('Log Out')
                    ],
                  ),
                ),
              )
            ];
          })
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(appName),
            Container(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('.',
                  style: TextStyle(color: Colors.green, fontSize: 50)),
            )),
          ],
        ),
        // actions: [
        //   FlatButton(
        //       onPressed: () => _confirmSignOut(context),
        //       child: Text(
        //         'LogOut',
        //         style: TextStyle(fontSize: 18),
        //       ))
        // ],
      ),
      body: SingleChildScrollView(
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
              // Divider(color: Colors.white24),
              // basicDetail != null
              //     ? SizedBox()
              //     : Container(
              //         height: 55,
              //         width: MediaQuery.of(context).size.width,
              //         color: Colors.green,
              //         child: Text('Enter Deatail For A-Card'),
              //       ),
              SizedBox(
                height: 5,
              ),
              _buildHeader(),
              SizedBox(
                height: 5,
              ),
              _buildCard(),
              SizedBox(
                height: 5,
              ),
              BuildTiles(
                  title: 'Profile Photo *',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhotoDetailForm()));
                    print('UserName');
                  },
                  icon: Icon(
                    Icons.photo,
                    size: 35,
                  )),
              BuildTiles(
                  title: 'Your Details *',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BasicDetailFull()));
                    print('details');
                  },
                  icon: Icon(
                    Icons.description,
                    size: 35,
                  )),
              BuildTiles(
                  title: 'Social Details *',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SocialDetailFull()));
                    print('social detail');
                  },
                  icon: Icon(
                    Icons.people,
                    size: 35,
                  )),
              // BuildTiles(
              //     title: 'ID Documents',
              //     onTap: () {
              //       print('Documents');
              //     },
              //     icon: Icon(
              //       Icons.library_books,
              //       size: 35,
              //     )),
              BuildTiles(
                  title: 'Benifits',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BenifitsPage()));
                    print('passwords');
                  },
                  icon: Icon(
                    FontAwesomeIcons.question,
                    // size: 35,
                  )),
              BuildTiles(
                  title: 'Features Coming Soon',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UpdatesSoon()));
                    print('passwords');
                  },
                  icon: Icon(
                    Icons.update,
                    size: 35,
                  )),
              // BuildTiles(
              //     title: 'Passwords',
              //     onTap: () {
              //       print('passwords');
              //     },
              //     icon: Icon(
              //       Icons.security,
              //       size: 35,
              //     )),
              // SizedBox(height: 10),
              // Text('${ourUser.username}'),
              // SizedBox(height: 10),
              // Text('${ourUser.email}'),
              // SizedBox(height: 10),
              // Text('${ourUser.username}'),
              // SizedBox(height: 10),
              // ListTile(
              // onTap: () async {
              //   if (_linkMessage != null) {
              //     await launch(_linkMessage);
              //   }
              // },
              // onLongPress: () {
              //   Clipboard.setData(ClipboardData(text: _linkMessage));
              //   Fluttertoast.showToast(msg: 'Copied Text');
              // },
              //   title: Text(
              //     _linkMessage ?? '',
              //     style: const TextStyle(color: Colors.cyan, fontSize: 16),
              //     overflow: TextOverflow.clip,
              //   ),
              //   trailing: IconButton(
              //     icon: Icon(Icons.content_copy),
              //     onPressed: () {
              // Clipboard.setData(ClipboardData(text: _linkMessage));
              // Fluttertoast.showToast(msg: 'Copied Text');
              //     },
              //   ),
              // ),
              // Icon(Icons.share),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildTiles extends StatelessWidget {
  final Widget icon;
  final String title;
  final Function onTap;

  const BuildTiles(
      {Key key,
      @required this.icon,
      @required this.title,
      @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1, color: Colors.white10),
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                  title: Text(title),
                  leading: icon,
                  trailing: Icon(Icons.chevron_right, size: 30))),
        ),
      ),
    );
  }
}
