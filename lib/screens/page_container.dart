import 'package:flutter/material.dart';
import 'package:garden/screens/login_register.dart';
import 'package:garden/service/sharepref_service.dart';

import 'home.dart';

class PageContainer extends StatefulWidget {
  @override
  PageContainerState createState() => PageContainerState();
}

class PageContainerState extends State<PageContainer> {
void refresh(){
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
          stream: SFService().isLogin().asStream(),
          builder: (ctx, snapshot) {
            return (snapshot.hasData)
                ? (snapshot.data) ? Home(refresh) : LoginRegister(refresh)
                : Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          }),
    );
  }
}
