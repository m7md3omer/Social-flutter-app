import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:social/UI/constants.dart';
import 'package:social/UI/helpers/AuthenticationPageMixin.dart';
import 'package:social/UI/helpers/curved_painter.dart';
import 'package:social/UI/helpers/loading_indicator.dart';
import 'package:social/UI/screens/home.dart';
import 'package:social/UI/screens/register.dart';
import 'package:social/UI/widgets/button.dart';
import 'package:social/bloc/login_bloc/login_bloc.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with AuthenticationPageMixin {
  LoginBloc bloc;
  TextEditingController email, password;
  @override
  void initState() {
    super.initState();
    bloc = LoginBloc();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        body: BlocConsumer(
          bloc: bloc,
          listener: (context, state) async {
            if (state is LoginError) {
              showAlert(state.error, context);
            } else if (state is LoginSuccess) {
              await setPreferences(state);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(
                    id: state.user.id,
                    userName: state.user.name,
                    email: state.user.email,
                    imageUrl: state.user.imageUrl,
                  ),
                ),
              );
            }
          },
          buildWhen: (previous, current) => current is! LoginSuccess,
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state is LoginLoading,
              dismissible: false,
              progressIndicator: getLoadingIndicator(),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 150,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/app_store.png'),
                                  radius: 30,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Social',
                                  style: TextStyle(
                                      fontSize: 40, fontFamily: 'Mont'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: formKey,
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      validator: emailValidator,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) {
                                        email.text = value;
                                      },
                                      decoration: kTextFieldDecoration.copyWith(
                                          hintText: 'Email'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      obscureText: true,
                                      validator: passwordValidator,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) {
                                        password.text = value;
                                      },
                                      decoration: kTextFieldDecoration.copyWith(
                                          hintText: 'Password'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Button(
                                      text: 'Login',
                                      color: mediumBlue,
                                      onPress: () {
                                        if (formKey.currentState.validate()) {
                                          final credentials = {
                                            'email': email.text.trim(),
                                            'password': password.text.trim()
                                          };
                                          bloc.add(
                                            LoginSubmitted(
                                                credentials: credentials),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: CustomPaint(
                        painter: CurvedPainter(curve: 0.5),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Don\'t have an account?'),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
