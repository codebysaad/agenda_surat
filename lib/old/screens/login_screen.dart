import 'dart:convert';

import 'package:agenda_surat/old/helpers/models.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  Models _models;
  ProgressDialog pr;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    pr.style(
      message: 'Loading...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    Future<Models> getRequest(var _email, var _password) async {
      //replace your restFull API here.
      var url = Uri.parse("https://script.google.com/macros/s/AKfycbwC6svCnHGUigwobE7GdZoIuUgBmjZhNhVXhRvvzH2cpxINgprmMgLMZv1pHPqcogIn/exec?sheetName=users&action=login&email=$_email&password=$_password");
      // var url = Uri.parse("https://script.google.com/macros/s/AKfycbzEOd1CZ2XkdGG07DcSS8grYSXH-D_ILoQNuRGid_Yh4N7wDXawdihprPa5NjuLvESW/exec");
      // final response = await http.post(url, body: {
      //   "sheetName": "users",
      //   "action": "login",
      //   "email": _email,
      //   "password": _password
      // });
      final response = await http.get(url);
      var responseData = json.decode(response.body);
      print('Response request' + responseData);
      //Creating a list to store input data;
      // List<Models> models = [];
      // for (var responses in responseData) {
      //   Models data = Models(
      //       statusCode: responses["statusCode"],
      //       message: responses["message"],
      //       email: responses["email"],
      //       username: responses["username"],
      //       password: responses["password"]
      //   );
      return userModelFromJson(responseData);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerEmail,
              decoration: InputDecoration(
                hintText: 'Masukkan email anda...',
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controllerPassword,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Masukkan password anda...',
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            _models == null ? Container():
                Text("Username ${_models.nama}"),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: MaterialButton(
                highlightElevation: 0.0,
                splashColor: Colors.lightBlueAccent,
                highlightColor: Colors.blueAccent,
                elevation: 0.0,
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.white, width: 2)),
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  if(_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty){
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Pastikan semua field sudah terisi!'),
                          );
                        });
                  }else {
                    final Models data = await getRequest(_controllerEmail.text, _controllerPassword.text);

                    setState(() {
                      _models = data;
                    });
                    // FutureBuilder(
                    //   future: getRequest(_controllerEmail.text, _controllerPassword.text),
                    //   builder: (context, snapshot){
                    //     if(snapshot.hasData){
                    //       print(snapshot.data);
                    //       var responses = snapshot.data;
                    //       return ListView.builder(
                    //           itemCount: responses.length,
                    //           itemBuilder: (context, index){
                    //             return ListTile(
                    //               contentPadding: EdgeInsets.all(8),
                    //               title: Text(responses['username']),
                    //             );
                    //           });
                    //     }else{
                    //       return Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }
                    //   },
                    // );
                    // Future.delayed(Duration(seconds: 10)).then((onValue) {
                    //   pr.hide();
                    // });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}