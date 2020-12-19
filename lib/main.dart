import 'package:digitalcard/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digitalcard/apps/landingPage.dart';
import 'package:digitalcard/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xff000002),
          canvasColor: Color(0xff000002),
          fontFamily: 'WorkSans',
          primaryIconTheme: IconThemeData(color: Color(0xffB2BCCF)),
          accentColor: Colors.grey[900],
        ),
        home: LandingPage(),
      ),
    );
  }
}

//  theme: ThemeData(
//           brightness: Brightness.dark,
//           primaryColor: Color(0xff000002),
//           canvasColor: Color(0xff000002),
//           fontFamily: 'WorkSans',
//           primaryIconTheme: IconThemeData(color: Color(0xffB2BCCF)),
//           accentColor: Colors.green,
//         ),

// theme: ThemeData(
//          brightness: Brightness.dark,
//          primaryColor: Color(0xff162345),
//          canvasColor: Color(0xff162345),
//          fontFamily: 'WorkSans',
//          primaryIconTheme: IconThemeData(color: Color(0xffB2BCCF)),
//           accentColor:
// Colors.green,
// Color(0xff212E4E)
//        ),
