import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowAllUploads extends StatefulWidget {
  @override
  _ShowAllUploadsState createState() => _ShowAllUploadsState();
}

class _ShowAllUploadsState extends State<ShowAllUploads> {
  Future allPerson() async {
    var url = Uri.parse("http://192.168.43.204/surat/viewAll.php");
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    allPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person All Data'),
      ),
      body: FutureBuilder(
        future: allPerson(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List list = snapshot.data;
                    return Card(
                      child: ListTile(
                        title: Container(
                          width: 100,
                          height: 100,
                          child: Image.network(
                              "http://192.168.43.204/surat/uploads/${list[index]['image']}"),
                        ),
                        subtitle: Center(child: Text(list[index]['name'])),
                      ),
                    );
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
