import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garden/models/fruit.dart';
import 'package:garden/service/network_service.dart';
import 'package:garden/utils.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController nameFruit = TextEditingController();
  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  bool isAvailabel = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sk,
      appBar: AppBar(title: Text('tambah data')),
      body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                createTextField(nameFruit, 'nama buah', Icon(Icons.add)),
                SizedBox(height: 10),
                Text('buah ini tersedia?'),
                Switch(
                    value: isAvailabel,
                    onChanged: (val) {
                      setState(() {
                        isAvailabel = val;
                      });
                    }),
               (isLoading)? Center(child: RefreshProgressIndicator(),):FlatButton(
                  onPressed: () => execAdd(),
                  child: Text('tambah'),
                  color: Colors.blueAccent,
                )
              ],
            ),
          )),
    );
  }

  execAdd() async {
    setState(() {
      isLoading = true;
    });
    String isAvailable = (isAvailabel) ? 'Available' : 'Not-available';
    if (nameFruit.text.isEmpty) {
      _sk.currentState.removeCurrentSnackBar();
      _sk.currentState
          .showSnackBar(createSnackbar('nama buah tidak boleh kosong'));
    } else {
      String name = nameFruit.text;
      try {
       bool result = await NetworkService()
            .addFruit(Fruit(name: name, isAvailable: isAvailable));
        if(result){
          _sk.currentState.showSnackBar(createSnackbar('buah berhasil dtambahkan'));
          await NetworkService().sendNotification('buah $name dengan status $isAvailable ditambahkan', 'buah ditambahkan');
          Timer(Duration(seconds: 1), (){
            Navigator.of(context).pop(true);
          });
        }else{
          _sk.currentState.showSnackBar(createSnackbar('buah  gagal dtambahkan'));
          setState(() {
            isLoading=false;
          });
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
