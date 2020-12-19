import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:digitalcard/apps/signIn/email_sign_in_form.dart';
import 'package:digitalcard/apps/signIn/signInBLoC.dart';
import 'package:digitalcard/apps/signIn/sign_in_button.dart';
import 'package:digitalcard/apps/signIn/social_sign_in_button.dart';
import 'package:digitalcard/services/auth.dart';
import 'package:digitalcard/constants.dart';
import 'package:digitalcard/widgets/platformExceptionAlertDialog.dart';

class SignInPage extends StatelessWidget {
  final SignInBloc bloc;

  const SignInPage({Key key, @required this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
          builder: (context, bloc, _) => SignInPage(bloc: bloc)),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(title: "Sign In Failed", exception: exception)
        .show(context);
  }

  Future<void> signInAnonymusly(BuildContext context) async {
    try {
      await bloc.signInAnonymusly();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  // Future<void> signInWithgoogle(BuildContext context) async {
  //   try {
  //     await bloc.signInWithGoogle();
  //   } on PlatformException catch (e) {
  //     if (e.code != "ERROR_ABORTED_BY_FATHER") {
  //       _showSignInError(context, e);
  //     }
  //   }
  // }

  void signInWithEmail(BuildContext context) {
    // final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EmailSignInFormStateful(
                  type: EmailSignInFormType.signIn,
                ),
            fullscreenDialog: true));
  }

  void registerWithEmail(BuildContext context) {
    // final auth = Provider.of<AuthBase>(context, listen: false);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EmailSignInFormStateful(
                  type: EmailSignInFormType.register,
                ),
            fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
          stream: bloc.isloadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }),
      // backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Container(
                  //   alignment: Alignment.center,
                  //   child: Text('Hello',
                  //       style: TextStyle(
                  //           fontSize: 40.0, fontWeight: FontWeight.bold)),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(appName,
                            style: TextStyle(
                                fontSize: 40.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        child: Text('.',
                            style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  children: [
                    Text('Welcome To $appName',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        "Create your digital card in 15 sec and quickly follow-up with millions of people with sharing it among your contacts.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w300))
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () => registerWithEmail(context),
                      child: Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(15.0),
                          // shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 2.0,
                          child: Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text('Or',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: GestureDetector(
                      onTap: () => signInWithEmail(context),
                      child: Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(15.0),
                          // shadowColor: Colors.grey,
                          color: Colors.grey,
                          elevation: 2.0,
                          child: Center(
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
    //  Padding(
    //   padding: EdgeInsets.all(16.0),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: <Widget>[
    //       isLoading == true
    //           ? Center(child: CircularProgressIndicator())
    //           : Text(
    //               'Sign in',
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                 fontSize: 32.0,
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //       SizedBox(height: 48.0),
    //       SignInButton(
    //         text: 'Sign in',
    //         textColor: Colors.white,
    //         color: Colors.teal[700],
    //         onPressed: isLoading ? null : () => signInWithEmail(context),
    //       ),
    //       SizedBox(height: 8.0),
    //       Text(
    //         'or',
    //         style: TextStyle(
    //           fontSize: 14.0,
    //         ),
    //         textAlign: TextAlign.center,
    //       ),
    //       SizedBox(height: 8.0),
    //       SignInButton(
    //         text: 'Register',
    //         textColor: Colors.white,
    //         color: Colors.teal[700],
    //         onPressed: isLoading ? null : () => registerWithEmail(context),
    //       ),
    //       // SignInButton(
    //       //   text: 'Go anonymous',
    //       //   textColor: Colors.black,
    //       //   color: Colors.lime[300],
    //       //   onPressed: isLoading ? null : () => signInAnonymusly(context),
    //       // ),
    //     ],
    //   ),
    // );
  }
}
