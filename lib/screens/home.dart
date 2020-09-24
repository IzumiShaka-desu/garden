import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:garden/models/fruit.dart';
import 'package:garden/screens/add.dart';
import 'package:garden/screens/profile.dart';
import 'package:garden/service/network_service.dart';
import 'package:garden/service/sharepref_service.dart';

class Home extends StatefulWidget {
  Home(this.refresh);
  final VoidCallback refresh;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseMessaging fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
 
  @override
  void initState() {
    initializeLocalNotif();
    configureFcm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('kebunku'),
        actions: [
          IconButton(
              icon: Icon(Icons.person_pin),
              onPressed: () async {
                Map profile = await SFService().getLoginDetails();
                if (profile != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => Profile(profile: profile)));
                }
              }),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                bool isWantExit = await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Peringatan!'),
                          content: Row(
                            children: [
                              Expanded(
                                child: Text('Apakah Anda Yakin Akan Keluar ?'),
                              )
                            ],
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Ya'),
                              color: Colors.redAccent,
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('batal'),
                              color: Colors.blueAccent,
                            )
                          ],
                        ));
                if (isWantExit??false) {
                  await SFService().removeSaveLogin();
                  widget.refresh();
                }
              })
        ],
      ),
      body: StreamBuilder<List<Fruit>>(
          stream: NetworkService().getFruits().asStream(),
          builder: (ctx, snapshot) {
            List<Fruit> fruits = snapshot.data;
            return (snapshot.hasData)
                ? Container(
                    child: Center(
                    child: ListView.builder(
                        itemCount: fruits.length,
                        itemBuilder: (ctx, index) => Dismissible(
                            background: Container(
                              color: Colors.redAccent,
                              child: Row(children: [
                                Icon(Icons.delete, color: Colors.white)
                              ]),
                            ),
                            key: GlobalKey(),
                            confirmDismiss: (direction) async {
                              return showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('Peringatan!'),
                                        content: Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                                    'apakah anda yakin data ini akan dihapus ?'))
                                          ],
                                        ),
                                        actions: [
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text('Ya'),
                                            color: Colors.redAccent,
                                          ),
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: Text('batal'),
                                            color: Colors.blueAccent,
                                          )
                                        ],
                                      ));
                            },
                            onDismissed: (direction) async {
                              try {
                                await NetworkService()
                                    .deleteFruit(fruits[index].id);
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            child: Container(
                                child: Card(
                                  child: ListTile(
                                      title: Row(
                                    children: [
                                      Text("name :" + fruits[index].name),
                                      Text(" status :" +
                                          fruits[index].isAvailable)
                                    ],
                                  )),
                                ),
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5)))),
                  ))
                : Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            setState(() {});
            bool refresh = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => Add()));
            if (refresh == null || refresh) {
              setState(() {});
            }
          }),
    );
  }
  
  displayNotifikasi(Map<String, dynamic> message) async {
    var android =
        AndroidNotificationDetails("1", "channelName", "channelDescription");
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android, ios);

    await flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        platform);
  }

  initializeLocalNotif() async {
    var android = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var platform = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  void configureFcm() async {
    fcm.getToken().then((value) => debugPrint(value.toString()));
    await fcm.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );
    fcm.configure(onResume: (msg) async {
      debugPrint('message: $msg');
      debugPrint('resume');

      return null;
    }, onMessage: (msg) async {
      debugPrint('message: $msg');
      debugPrint('onmessage');
      displayNotifikasi(msg);
      return null;
    }, onLaunch: (msg) async {
      debugPrint('message: $msg');
      debugPrint('onLaunch');
      return null;
    });
  }

}
