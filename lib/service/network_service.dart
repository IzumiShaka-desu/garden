import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:garden/models/fruit.dart';
import 'package:garden/models/response_auth.dart';
import 'package:http/http.dart' as http;

abstract class BaseNetworkService{
  Future<ResponseAuth> login(String email,String password);
  Future<List<Fruit>> getFruits();
  Future<ResponseAuth> register(String email,String password,String fullName);
  Future<bool> addFruit(Fruit fruit);
  Future<void> deleteFruit(int id);
  Future<void> sendNotification(String body,String title);

}
class NetworkService implements BaseNetworkService{
  var client=http.Client();
  String host="http://192.168.43.150";
  @override
  Future<List<Fruit>> getFruits() async{
    String url="$host/fruits";
    List<Fruit> list=[];
    var response=await client.get(url);
    if(response.statusCode==200){
      var result=jsonDecode(response.body) as List;
     list.addAll(result.map((e) => Fruit.fromJson(e)).toList());
    }
    return list;
  }

  @override
  Future<ResponseAuth> login(String email, String password) async{
    String url="$host/auth/login";
    var result;
    var response=await client.post(url,body:{
      'email':email,
      'password':password
    });
    if(response.statusCode==200){
       result =jsonDecode(response.body);


    }
    return ResponseAuth.fromJson(result??{});
  }

  @override
  Future<ResponseAuth> register(String email, String password, String fullName) async{
    String url="$host/auth/register";
    var result;
    var response=await client.post(url,body:{
      'email':email,
      'password':password,
      'fullname':fullName
    });
    if(response.statusCode==200){
      result=jsonDecode(response.body);
    }
    return ResponseAuth.fromJson(result??{});

  }

  @override
  Future<bool> addFruit(Fruit fruit) async{
    Map body=fruit.toJson();
    body.removeWhere((key, value) => key==null || value==null);
    String url="$host/fruits";
    bool result;
    var response=await client.post(url,body:body);
    
    (response.statusCode==200)?result= true:
    result= false;
    return result;
  }

  @override
  Future<void> deleteFruit(int id) async{
    String url="$host/fruits/$id";
    await client.delete(url);
  }

  @override
  Future<void> sendNotification(String body, String title) async{
    String to = await  FirebaseMessaging().getToken();
    String serverToken='AAAAS4Fiovk:APA91bH8e43vfwQLSEOBMip3kTL6lw8T-a4obOMXfahJrRYt6onYRccNcWFGmApQH-8s8bLAQfPa3bzURX1HsSv2ejUeXjyEDAltUgg7N6psBISI0yMXWk3mC3nuYUXRz78oNeJAEkNZ';
    await client.post('https://fcm.googleapis.com/fcm/send',
        headers: {
          'Content-Type':'application/json',
          'Authorization':'key=$serverToken'
        },
        body:jsonEncode({
          'notification':{
            'title':title,
            'body':body
          },
          'priority':'high',
          'data':{
            'click_action':'FLUTTER_NOTIFICATION_CLICK'
          },
          'to':'$to'
        })
    );
  }
  
}