import 'dart:convert';
import 'package:agenda_surat/file_upload.dart';
import 'package:agenda_surat/helpers/constanta.dart';
import 'package:agenda_surat/main.dart';
import 'package:agenda_surat/screens/add_letter.dart';
import 'package:agenda_surat/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'add_edit_page.dart';
import 'screens/image_upload.dart';

class Dashboard extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PageDashboard(),
    );
  }
}

class PageDashboard extends StatefulWidget {
  @override
  _PageDashboardState createState() => _PageDashboardState();
}

class _PageDashboardState extends State<PageDashboard> {
  String email = "";

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }

  Future getData() async {
    var url = Uri.parse(ENDPOINT_READ);
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        logOut(context);
        break;
      case 'Settings':
        Fluttertoast.showToast(
            msg: "Settings",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white);
        break;
      case 'Upload':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => FileUpload(),
        ));
        break;
      case 'New':
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => UploadImageDemo()));
    }
  }

  Future logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('email');
    Fluttertoast.showToast(
        msg: "Logout Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.amber,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyApp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda Surat'),
        actions: [
          PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Logout', 'Settings', 'Upload', 'New'}.map((e) {
                  return PopupMenuItem<String>(value: e, child: Text(e));
                }).toList();
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditPage(),
            ),
          );
          debugPrint('Clicked FloatingActionButton Button');
        },
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List list = snapshot.data;
                    return ListTile(
                      leading: GestureDetector(
                        child: Icon(Icons.edit),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditPage(
                                list: list,
                                index: index,
                              ),
                            ),
                          );
                          debugPrint('Edit Clicked');
                        },
                      ),
                      title: Text(list[index]['lastname']),
                      subtitle: Text(list[index]['phone']),
                      trailing: GestureDetector(
                        child: Icon(Icons.delete),
                        onTap: () {
                          setState(() {
                            var url = Uri.parse(ENDPOINT_DELETE);
                            http.post(url, body: {
                              'id': list[index]['id'],
                            });
                          });
                          debugPrint('delete Clicked');
                        },
                      ),
                    );
                  })
              : CircularProgressIndicator();
        },
      ),
      // MaterialButton(
      //   color: Colors.purple,
      //   onPressed: (){
      //     logOut(context);
      //   },child: Text("Log Out",style: TextStyle(color: Colors.white),),),
    );
  }
}
