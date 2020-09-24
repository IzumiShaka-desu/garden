import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  Profile({@required this.profile});
  final Map profile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Profil')),
      body: Container(
        padding: EdgeInsets.only(top:50),
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Transform.scale(
              scale: 2,
              child: CircleAvatar(child: Icon(Icons.person_pin),)),
            SizedBox(height: 50,),
            Text(profile['name'],style: TextStyle(fontSize:20),),
            Text(profile['email'],style: TextStyle(fontSize:20),),

          ],),
        )
      ),
      
    );
  }
}