import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:garden/models/response_auth.dart';
import 'package:garden/service/network_service.dart';
import 'package:garden/service/sharepref_service.dart';
import 'package:garden/utils.dart';

class LoginRegister extends StatefulWidget {
  LoginRegister(this.refresh);
  final VoidCallback refresh;
  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  Map<String, TextEditingController> loginController = {
    'email': TextEditingController(),
    'password': TextEditingController()
  };
  Map<String, TextEditingController> registerController = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'fullname': TextEditingController()
  };
  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isLoginPage = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
      appBar: AppBar(title: Text('MyKebun')),
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(children: [
            AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastLinearToSlowEaseIn,
                top: (isLoginPage) ? size.height * 2 : 0,
                child: Container(
                  height: size.height,
                  width: size.width,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Title(
                            child: Text(
                              'Daftar',
                              style: TextStyle(fontSize: 24),
                            ),
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: createTextField(registerController['fullname'],
                              'fullname', Icon(Icons.face)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: createTextField(registerController['email'],
                              'email', Icon(Icons.email)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: createTextField(registerController['password'],
                              'password', Icon(Icons.lock_outline),
                              isObscure: true),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (isLoading)
                                ? Center(child: RefreshProgressIndicator())
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: MaterialButton(
                                        onPressed: () => executeRegister(),
                                        child: Text(
                                          'daftar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Anda sudah memiliki akun?, '),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoginPage = true;
                                });
                              },
                              child: Text('Login',
                                  style: TextStyle(color: Colors.blue)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )),
            AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastLinearToSlowEaseIn,
                top: (!isLoginPage) ? size.height * 2 : 0,
                child: Container(
                  height: size.height,
                  width: size.width,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Title(
                          child: Text(
                            'Masuk',
                            style: TextStyle(fontSize: 24),
                          ),
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: createTextField(loginController['email'],
                            'email', Icon(Icons.email)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: createTextField(loginController['password'],
                            'password', Icon(Icons.lock_outline),
                            isObscure: true),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (isLoading)
                              ? Center(child: RefreshProgressIndicator())
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: MaterialButton(
                                      onPressed: () => executeLogin(),
                                      child: Text(
                                        'masuk',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Anda belum memiliki akun?, '),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLoginPage = false;
                              });
                            },
                            child: Text('Daftar',
                                style: TextStyle(color: Colors.blue)),
                          )
                        ],
                      )
                    ]),
                  ),
                )),
          ])),
    );
  }

  executeLogin() async {
    setState(() {
      isLoading = true;
    });
    ResponseAuth responseAuth=ResponseAuth();
    if (checkNullTextController(loginController)) {
      _sk.currentState.removeCurrentSnackBar();
      _sk.currentState.showSnackBar(createSnackbar('field Tidak boleh kosong'));
    } else if (!EmailValidator.validate(loginController['email'].text)) {
      _sk.currentState.removeCurrentSnackBar();
      _sk.currentState.showSnackBar(createSnackbar('email tidak valid'));
    } else {
      String email = loginController['email'].text;
      String password = loginController['password'].text;
      NetworkService networkService = NetworkService();
      try {
        responseAuth = await networkService.login(email, password);
        if (responseAuth.data['result']) {
          
          _sk.currentState
              .showSnackBar(createSnackbar("${responseAuth.data['message']} "));

         
        } else {
          _sk.currentState
              .showSnackBar(createSnackbar(responseAuth.data['message']));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
     if(responseAuth.data['result']??false==true)
     {
       SFService sfService = SFService();
           
            await sfService.saveLoginDetails(
                responseAuth.data['email'], responseAuth.data['fullname']);
          Timer(Duration(seconds: 2), () async{
            widget.refresh();
          });}
    setState(() {
      isLoading = false;
    });
  }

  executeRegister() async {
    setState(() {
      isLoading = true;
    });
    if (checkNullTextController(registerController)) {
      _sk.currentState.removeCurrentSnackBar();
      _sk.currentState.showSnackBar(createSnackbar('field Tidak boleh kosong'));
    } else if (!EmailValidator.validate(registerController['email'].text)) {
      _sk.currentState.removeCurrentSnackBar();
      _sk.currentState.showSnackBar(createSnackbar('email tidak valid'));
    } else if (registerController['password'].text.length < 6) {
      _sk.currentState.removeCurrentSnackBar();
      _sk.currentState.showSnackBar(
          createSnackbar('password tidak boleh kurang dari 6 digit'));
    } else {
      String email = registerController['email'].text;
      String password = registerController['password'].text;
      String fullname = registerController['fullname'].text;
      NetworkService networkService = NetworkService();
      try {
        ResponseAuth responseAuth =
            await networkService.register(email, password, fullname);
        if (responseAuth.data['result']) {
          _sk.currentState.showSnackBar(createSnackbar(
              "${responseAuth.data['message']}, silahkan login "));
          setState(() {
            isLoginPage = true;
          });
        } else {
          _sk.currentState
              .showSnackBar(createSnackbar(responseAuth.data['message']));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
