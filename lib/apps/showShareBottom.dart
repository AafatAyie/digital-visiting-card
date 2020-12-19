import 'package:digitalcard/apps/landingPage.dart';
import 'package:digitalcard/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

showAddUniversityBottom({BuildContext context, String link}) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          // String univId = Uuid().v4();
          // bool isUploading = false;
          // _submit() async {
          //   await universityRef.document(univId).setData({
          //     'id': univId,
          //     'name': controller.text,
          //     'isLive': false,
          //   });
          // }

          return new Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Share Your Digital Card",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 25),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(link),
                            trailing: IconButton(
                                icon: Icon(Icons.content_copy),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: link));
                                  Fluttertoast.showToast(msg: 'Link Copied');
                                }),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Button(
                          text: 'Share',
                          onTap: () {
                            Share.share(
                                'You can view my digital v-card from below link. It will download All About Mee app where you can see My Digital V-Card and create your\'s as Well  $link',
                                subject:
                                    'Digital Visiting Card of ${ourUser.username}');
                          }),
                    ),
                    // Divider(),
                  ],
                ),
              ));
        });
      });
}
