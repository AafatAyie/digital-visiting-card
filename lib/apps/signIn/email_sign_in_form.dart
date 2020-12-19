import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:digitalcard/services/auth.dart';
import 'package:digitalcard/services/validators.dart';
import 'package:digitalcard/widgets/form_submit_button.dart';
import 'package:digitalcard/widgets/platformExceptionAlertDialog.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInFormStateful extends StatefulWidget
    with EmailandPasswordValidator {
  final EmailSignInFormType type;

  EmailSignInFormStateful({Key key, @required this.type}) : super(key: key);
  @override
  _EmailSignInFormStatefulState createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  String get _phone => _phoneController.text;
  String get _name => _nameController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  bool _submitted = false;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formType = widget.type;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password, _name);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        exception: e,
        title: 'Sign In Failed',
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  Widget _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return _formType == EmailSignInFormType.signIn
        ? buildSignInScreen()
        : buildRegisterScreen();
    // [
    //   _buildEmailTextField(),
    //   SizedBox(height: 8.0),
    //   _buildPasswordTextField(),
    //   SizedBox(height: 8.0),
    //   FormSubmitButton(
    //     text: primaryText,
    //     onPressed: submitEnabled ? _submit : null,
    //   ),
    //   SizedBox(height: 8.0),
    //   FlatButton(
    //     child: Text(secondaryText),
    //     onPressed: !_isLoading ? _toggleFormType : null,
    //   ),
    // ];
  }

  buildSignInScreen() {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor
                ]),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                        child: Text('Hello',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                        child: Text('There',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(240.0, 175.0, 0.0, 0.0),
                        child: Text('.',
                            style: TextStyle(
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                      )
                    ],
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        _buildEmailTextField(),
                        SizedBox(height: 20.0),
                        _buildPasswordTextField(),
                        SizedBox(height: 40.0),
                        GestureDetector(
                          onTap: _isLoading == false
                              ? () {
                                  print('LogIn');
                                  _submit();
                                }
                              : null,
                          child: Container(
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: _isLoading == false
                                  ? Colors.greenAccent
                                  : Colors.grey,
                              color: _isLoading == false
                                  ? Colors.green
                                  : Colors.grey,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'LOG IN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    )),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'New to $appName ?',
                      style: TextStyle(),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: _toggleFormType,
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  buildRegisterScreen() {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor
                ]),
          ),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                          child: Text('Hello',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                          child: Text('There',
                              style: TextStyle(
                                  fontSize: 80.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(240.0, 175.0, 0.0, 0.0),
                          child: Text('.',
                              style: TextStyle(
                                  fontSize: 80.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          _buildNameTextField(),
                          SizedBox(height: 10.0),
                          _buildEmailTextField(),
                          SizedBox(height: 10.0),
                          _buildPasswordTextField(),
                          SizedBox(height: 50.0),
                          GestureDetector(
                            onTap: _isLoading == false
                                ? () {
                                    print('Register');
                                    _submit();
                                  }
                                : null,
                            child: Container(
                                height: 40.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: _isLoading == false
                                      ? Colors.greenAccent
                                      : Colors.grey,
                                  color: _isLoading == false
                                      ? Colors.green
                                      : Colors.grey,
                                  elevation: 7.0,
                                  child: Center(
                                    child: Text(
                                      'Create Account',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'WorkSans'),
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Already Registered $appName ?',
                                style: TextStyle(),
                              ),
                              SizedBox(width: 5.0),
                              InkWell(
                                onTap: _toggleFormType,
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                ]),
          ),
        ));
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.emailValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'PASSWORD',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildPhoneTextField() {
    // bool showErrorText = _submitted && !widget.phoneValidator.isValid(_phone);
    return TextField(
      controller: _phoneController,
      focusNode: _phoneFocusNode,
      decoration: InputDecoration(
        labelText: 'PHONE NO.',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        hintStyle: TextStyle(color: Colors.grey),
        // errorText: showErrorText,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      },
    );
  }

  TextField _buildNameTextField() {
    // bool showErrorText = _submitted && !widget.phoneValidator.isValid(_phone);
    return TextField(
      controller: _nameController,
      focusNode: _nameFocusNode,
      decoration: InputDecoration(
        labelText: 'FULL NAME',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        hintStyle: TextStyle(color: Colors.grey),
        // errorText: showErrorText,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_phoneFocusNode);
      },
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'EMAIL',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildChildren();
  }

  void _updateState() {
    setState(() {});
  }
}
