import 'package:digitalcard/apps/homePage.dart';
import 'package:digitalcard/apps/signIn/signInScreen.dart';
import 'package:digitalcard/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:introduction_screen/introduction_screen.dart';

class BenifitsPage extends StatefulWidget {
  @override
  _BenifitsPageState createState() => _BenifitsPageState();
}

class _BenifitsPageState extends State<BenifitsPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      boxDecoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff212121), Color(0xff000002)]),
      ),
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      // pageColor: Color(0xff000002),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          titleWidget: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(appName,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  Text('.',
                      style: TextStyle(color: Colors.green, fontSize: 50)),
                ],
              ),
              SizedBox(
                height: 130,
              ),
              Text("Business cards meet, the digital age",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700)),
            ],
          ),
          // title: "Fractional shares",
          body:
              "Create your digital card in 15 sec and quickly follow-up with people",
          // image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(appName,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  Text('.',
                      style: TextStyle(color: Colors.green, fontSize: 50)),
                ],
              ),
              SizedBox(
                height: 130,
              ),
              Text("No need to carry business cards",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700)),
            ],
          ),
          body:
              "Share your digital business card easily via SMS, Email or Whatsapp.",
          // image: _buildImage('img2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(appName,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  Text('.',
                      style: TextStyle(color: Colors.green, fontSize: 50)),
                ],
              ),
              SizedBox(
                height: 130,
              ),
              Text("Click, Call and Business!",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700)),
            ],
          ),
          body:
              "Your recipients can just click to communicate with you by your digital card.",
          // image: _buildImage('img3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(appName,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  Text('.',
                      style: TextStyle(color: Colors.green, fontSize: 50)),
                ],
              ),
              SizedBox(
                height: 130,
              ),
              Text("Contactless Visiting Card Sharing",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700)),
            ],
          ),
          body:
              "Growth of your network should not be stop any pandemic so you can now share your visiting card their mobile",
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(appName,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                  Text('.',
                      style: TextStyle(color: Colors.green, fontSize: 50)),
                ],
              ),
              SizedBox(
                height: 130,
              ),
              Text("One Click, Endless possibilities",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700)),
            ],
          ),
          body:
              "Click to send Email, save your contact, navigation to your store or website, or Call you.",
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('End', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        activeColor: Colors.green,
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}

class UpdatesSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Features Coming Soon',
        ),
        backgroundColor: Color(0xff212121),
        centerTitle: true,
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff212121), Color(0xff000002)]),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).accentColor,
                  //   borderRadius: BorderRadius.circular(15),
                  //   // border: Border.all(width: 1, color: Colors.white10),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Text('1'),
                      title:
                          Text('Create digital card for your company as well'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).accentColor,
                  //   borderRadius: BorderRadius.circular(15),
                  //   // border: Border.all(width: 1, color: Colors.white10),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Text('2'),
                      title:
                          Text('Create your services or product digital store'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).accentColor,
                  //   borderRadius: BorderRadius.circular(15),
                  //   // border: Border.all(width: 1, color: Colors.white10),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Text('3'),
                      title: Text(
                          'Accept Payment from clients on your digital store'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).accentColor,
                  //   borderRadius: BorderRadius.circular(15),
                  //   // border: Border.all(width: 1, color: Colors.white10),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Text('4'),
                      title: Text('Save and never forget your passwords'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).accentColor,
                  //   borderRadius: BorderRadius.circular(15),
                  //   // border: Border.all(width: 1, color: Colors.white10),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Text('5'),
                      title: Text('Increse in Security'),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
