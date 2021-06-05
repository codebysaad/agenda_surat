import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'show_all_uploads.dart';

class FileUpload extends StatefulWidget {
  @override
  _FileUpload createState() => _FileUpload();
}

class _FileUpload extends State<FileUpload> {
  File _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController noSuratController = TextEditingController();

  Future choiceImage() async {
    var pickedImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  Future uploadImage() async {
    final uri = Uri.parse("http://192.168.43.204/surat/upload.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = nameController.text;
    request.fields['nosurat'] = noSuratController.text;
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploded');
    } else {
      print('Image Not Uploded');
    }
    setState(() {});
  }

  // String _mySelection;
  // List<Map> _myJson = [
  //   {"id": 0, "name": "<New>"},
  //   {"id": 1, "name": "Test Practice"}
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: noSuratController,
                decoration: InputDecoration(labelText: 'No Surat'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                choiceImage();
              },
            ),
            Container(
              child: _image == null
                  ? Text('No Image Selected')
                  : Image.file(_image),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              child: Text('Upload Image'),
              onPressed: () {
                uploadImage();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowAllUploads(),
                  ),
                );
              },
            ),
            // Center(
            //   child: new DropdownButton(
            //     isDense: true,
            //     hint: new Text("Select"),
            //     value: _mySelection,
            //     onChanged: (newValue) {
            //       setState(() {
            //         _mySelection = newValue;
            //       });
            //
            //       print(_mySelection);
            //     },
            //     items: _myJson.map((Map map) {
            //       return new DropdownMenuItem(
            //         value: map["id"].toString(),
            //         child: new Text(
            //           map["name"],
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}