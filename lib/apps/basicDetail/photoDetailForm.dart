import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as Im;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalcard/apps/basicDetail/basicDetailForm.dart';
import 'package:digitalcard/models/user.dart';
import 'package:digitalcard/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../landingPage.dart';

class PhotoDetailForm extends StatefulWidget {
  @override
  _PhotoDetailFormState createState() => _PhotoDetailFormState();
}

class _PhotoDetailFormState extends State<PhotoDetailForm> {
  User user;
  bool hasData = false;
  bool uploading = false;
  bool buildScreen = false;
  bool changePhoto = false;
  File _pickedImage;

  TextEditingController photoTextEditingController = TextEditingController();
  TextEditingController usernameTextEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final usernameFocusNode = FocusNode();

  clearImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(_pickedImage.readAsBytesSync());
    final compressedImageFile = File('$path/profile_${user.uid}.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 60));
    setState(() {
      _pickedImage = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    print('Uploading Image');
    StorageUploadTask uploadTask =
        storageRef.child("profile_${user.uid}.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handelEdit() async {
    setState(() {
      uploading = true;
    });
    if (changePhoto = true) {
      storageRef.child("profile_${user.uid}.jpg").delete();
      await compressImage();

      String mediaUrl = await uploadImage(_pickedImage);
      print('Uploading Image Done');
      await updateRestrauntDetail(mediaUrl);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LandingPage()));
    } else {
      await updateRestrauntDetail(user.photoUrl);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LandingPage()));
    }
    setState(() {
      uploading = false;
    });
  }

  updateRestrauntDetail(String mediaUrl) async {
    print('Media URL is $mediaUrl');
    setState(() {
      photoTextEditingController.text = mediaUrl;
    });
    await usersRef.document(user.uid).updateData({
      "username": usernameTextEditingController.text,
      "photoUrl": photoTextEditingController.text,
    });

    // SnackBar snackbar = SnackBar(
    //   content: Text('Updated Detail'),
    // );
    // _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  getUser() async {
    setState(() {
      buildScreen = false;
    });
    DocumentSnapshot doc = await usersRef.document(ourUser.uid).get();
    User user = User.fromDocument(doc);
    setState(() {
      this.user = user;
      buildScreen = true;
    });
    usernameTextEditingController.text = user.username;
    photoTextEditingController.text = user.photoUrl;
  }

  // @override
  // Future<void> initState() async {
  //   // TODO: implement initState
  //   super.initState();
  //   getUser();
  // }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    photoTextEditingController.dispose();
    usernameTextEditingController.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  _loadPicker(ImageSource source) async {
    File picked = await ImagePicker.pickImage(source: source);
    if (picked != null) {
      _cropImage(picked);
    }
    Navigator.pop(context);
  }

  _cropImage(File picked) async {
    File cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Theme.of(context).accentColor,
        toolbarColor: Theme.of(context).accentColor,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      maxWidth: 800,
    );
    if (cropped != null) {
      setState(() {
        _pickedImage = cropped;
      });
    }
  }

  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Profile Photo"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: () {
                  _loadPicker(ImageSource.camera);
                },
              ),
              SimpleDialogOption(
                  child: Text("Image from Gallery"),
                  onPressed: () {
                    _loadPicker(ImageSource.gallery);
                  }),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Profile Photo'),
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
              child: ListView(
              children: [
                uploading == true
                    ? LinearProgressIndicator(
                        backgroundColor: accent,
                      )
                    : SizedBox(),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    _showPickOptionsDialog(context);
                  },
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 100,
                      child: _pickedImage == null
                          ? user.photoUrl.length == 0 || user.photoUrl == null
                              ? Icon(Icons.add_a_photo,
                                  size: 50, color: Colors.grey[200])
                              : null
                          : null,
                      backgroundImage: _pickedImage == null
                          ? user.photoUrl.length == 0
                              ? null
                              : CachedNetworkImageProvider(user.photoUrl)
                          : FileImage(_pickedImage),
                    ),
                  ),
                ),
                EnterTile(
                    title: 'Full Name',
                    controller: usernameTextEditingController,
                    node: usernameFocusNode),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Button(
                    text: 'Save',
                    onTap: uploading == true ? null : handelEdit,
                    color: uploading == true ? Colors.grey : Colors.green,
                    shadowColor:
                        uploading == true ? Colors.grey : Colors.greenAccent,
                  ),
                )
              ],
            )),
    );
  }
}
