import 'dart:convert';
import 'dart:io';
import 'package:agenda_surat/data_upload.dart';
import 'package:agenda_surat/file_upload.dart';
import 'package:agenda_surat/helpers/constanta.dart';
import 'package:agenda_surat/main.dart';
import 'package:agenda_surat/screens/add_letter.dart';
import 'package:agenda_surat/screens/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PageHome(),
    );
  }
}

class PageHome extends StatefulWidget {
  @override
  _PageHome createState() => _PageHome();
}

class _PageHome extends State<PageHome> {
  String email = "";
  Response response;
  Dio dio = new Dio();

  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }

  Future getData() async {
    var url = Uri.parse(ENDPOINT_READ_ALL);
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future exportExcel() async {
    // final taskId = await FlutterDownloader.enqueue(
    //   url: ENDPOINT_EXPORT_EXCEL,
    //   savedDir: 'the path of directory where you want to save downloaded files',
    //   showNotification: true, // show download progress in status bar (for Android)
    //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    // );
    var url = ENDPOINT_EXPORT_EXCEL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Url Not Found';
    }
  }

  deleteData(BuildContext context, var id, var idImage) async {
    String uploadurl = ENDPOINT_DELETE_BY_ID;

    FormData formdata = FormData.fromMap({
      "id": id,
      "image": idImage,
    });

    response = await dio.post(
      uploadurl,
      data: formdata,
    );

    if (response.statusCode == 200) {
      print(response.toString());
      Fluttertoast.showToast(
        msg: 'Data Deleted',
        textColor: Colors.green,
      );
      //print response from server
    } else {
      print("Error during connection to server.");
      Fluttertoast.showToast(
        msg: 'Fail to Delete',
        textColor: Colors.red,
      );
    }
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
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DataUpload(),
            ));
        break;
      case 'Excel':
        exportExcel();
        break;
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

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit Dialog'),
            content: Text('Do you want to exit Visit Kudus App?'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _deleteOrEdit(var id, var idImage, List list, var index) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Action Dialog'),
        content: Text('What do you want?'),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddLetter(
                        list: list,
                        index: index,
                      ),
                ),
              );
              Navigator.of(context).pop(false);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.edit),
                Text('Edit'),
              ],
            ),
          ),
          MaterialButton(
            onPressed: () => {
              _deletePopUp(id, idImage),
            Navigator.of(context).pop(false),
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.delete),
                Text('Delete'),
              ],
            ),
          ),
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.cancel),
                Text('Cancel'),
              ],
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  Future<bool> _deletePopUp(var id, var idImage) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Dialog'),
        content: Text('Do you want to delete this data?'),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          MaterialButton(
            onPressed: () => {
              deleteData(context, id, idImage),
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Home())),
            },
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  String filterFileExtension(var extension){
    print(extension);
    String extensionSPlit = extension.split('.')[1];
    print(extensionSPlit);
    if(extensionSPlit == 'pdf'){
      return 'assets/images/pdf.png';
    }else if(extensionSPlit == 'jpg'){
      return 'assets/images/file_jpg.png';
    }else if(extensionSPlit == 'png'){
      return 'assets/images/file_png.png';
    }else{
      return 'assets/images/pdf.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Agenda Surat'),
            actions: [
              PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {'Logout', 'Settings', 'Upload', 'Excel'}.map((e) {
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
                  builder: (context) => AddLetter(),
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
                        return GestureDetector(
                          child: Card(
                            margin: EdgeInsets.all(8),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 3,
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              margin: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      border: new Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                      ),
                                      image: DecorationImage(
                                          image:
                                          AssetImage(filterFileExtension(list[index]['image'])),
                                          scale: 0.2,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        Waktu(DateTime.parse(
                                            list[index]['tglsurat']))
                                            .yMMMMEEEEd(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 2),
                                        child: Text(
                                          list[index]['nosurat'],
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 22,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddLetter(
                                                list: list,
                                                index: index,
                                              ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit_rounded),
                                    color: Colors.yellow,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _deletePopUp(
                                          list[index]['id'],
                                          list[index]['image'],
                                        );
                                        print(list[index]['id']);
                                        print(list[index]['image']);
                                      });
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onLongPress: () => _deleteOrEdit(
                            list[index]['id'],
                            list[index]['image'],
                            list,
                            index
                          ),
                          onTap: () {
                            debugPrint('Edit Clicked');
                          },
                        );
                      })
                  : Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        onWillPop: _onWillPop);
  }
}
