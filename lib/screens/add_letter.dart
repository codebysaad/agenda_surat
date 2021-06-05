import 'dart:io';
import 'package:agenda_surat/helpers/constanta.dart';
import 'package:agenda_surat/screens/home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

class AddLetter extends StatefulWidget {
  final List list;
  final int index;

  AddLetter({this.list, this.index});

  @override
  _AddLetter createState() => _AddLetter();
}

class _AddLetter extends State<AddLetter> {
  File _image;
  File fileUpload;
  final imagePicker = ImagePicker();
  Response response;
  String progress;
  var _jnsSurat;
  Dio dio = new Dio();
  TextEditingController noSuratController = TextEditingController();
  TextEditingController isiSuratController = TextEditingController();
  TextEditingController dariController = TextEditingController();
  TextEditingController kepadaController = TextEditingController();
  TextEditingController ketController = TextEditingController();
  DateTime dateReceivedController = DateTime.parse('2021-03-15 00:00:00.000');
  DateTime dateLetterController = DateTime.parse('2021-03-15 00:00:00.000');

  bool editMode = false;

  DateTime dateReceived = DateTime.now();
  DateTime dateLetter = DateTime.now();

  Future<Null> _dateReceived(BuildContext context) async {
    // Initial DateTime FIinal Picked
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateReceived,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateReceived)
      setState(() {
        dateReceived = picked;
      });
  }

  Future<Null> _dateReceivedController(BuildContext context) async {
    // Initial DateTime FIinal Picked
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateReceivedController,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateReceivedController)
      setState(() {
        dateReceivedController = picked;
        print(dateReceivedController);
      });
  }

  Future<Null> _dateLetter(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateLetter,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateLetter)
      setState(() {
        dateLetter = picked;
      });
  }

  Future<Null> _dateLetterController(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateLetterController,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateLetterController)
      setState(() {
        dateLetterController = picked;
      });
  }

  String convertDateToDatabase(var date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String finalDate = formatter.format(date);
    return finalDate;
  }

  Future choiceImage() async {
    var pickedImage = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  selectFile() async {
    //for file_pocker plugin version 2 or 2+

    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'pdf', 'png'],
      //allowed extension to choose
    );

    setState(() {
      if (result != null) {
        //if there is selected file
        fileUpload = File(result.files.single.path);
      }
    }); //update the UI so that file name is shown
  }

  /*
  Future uploadImage() async {
    final uri = Uri.parse(ENDPOINT_INSERT);
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = convertDateToDatabase(dateReceived);
    request.fields['nosurat'] = noSuratController.text;
    request.fields['tglsurat'] = convertDateToDatabase(dateLetter);
    request.fields['isisurat'] = isiSuratController.text;
    request.fields['dari'] = dariController.text;
    request.fields['kepada'] = kepadaController.text;
    request.fields['ket'] = ketController.text;
    var pic = await http.MultipartFile.fromPath('image', fileUpload.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploded');
      Fluttertoast.showToast(
        msg: 'Files Uploaded',
        textColor: Colors.green,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else {
      print('Image Not Uploded');
      Fluttertoast.showToast(
        msg: 'Fail to Upload',
        textColor: Colors.red,
      );
    }
    setState(() {});
  }

   */

  addOrUpdateData(BuildContext context) {
    if (editMode) {
      updateData(context);
    } else {
      insertData(context);
    }
  }

  insertData(BuildContext context) async {
    String uploadurl = ENDPOINT_INSERT;
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    FormData formdata = FormData.fromMap({
      "jnssurat": _jnsSurat,
      "name": convertDateToDatabase(dateReceived),
      "nosurat": noSuratController.text,
      "tglsurat": convertDateToDatabase(dateLetter),
      "isisurat": isiSuratController.text,
      "dari": dariController.text,
      "kepada": kepadaController.text,
      "ket": ketController.text,
      "image": await MultipartFile.fromFile(fileUpload.path,
          filename: basename(fileUpload.path)
          //show only filename from path
          ),
    });

    response = await dio.post(
      uploadurl,
      data: formdata,
      onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);
        setState(() {
          progress = "$sent" +
              " Bytes of " "$total Bytes - " +
              percentage +
              " % uploaded";
          //update the progress
        });
      },
    );

    if (response.statusCode == 200) {
      print(response.toString());
      Fluttertoast.showToast(
        msg: 'Files Uploaded',
        textColor: Colors.green,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
      //print response from server
    } else {
      print("Error during connection to server.");
      Fluttertoast.showToast(
        msg: 'Fail to Upload',
        textColor: Colors.red,
      );
    }
  }

  updateData(BuildContext context) async {
    String uploadurl = ENDPOINT_UPDATE;
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    FormData formdata = FormData.fromMap({
      "id": widget.list[widget.index]['id'],
      "jnssurat": _jnsSurat,
      "tglterima": dateReceivedController,
      "nosurat": noSuratController.text,
      "tglsurat": dateLetterController,
      "isisurat": isiSuratController.text,
      "dari": dariController.text,
      "kepada": kepadaController.text,
      "ket": ketController.text,
    });

    response = await dio.post(
      uploadurl,
      data: formdata,
    );

    if (response.statusCode == 200) {
      print(response.toString());
      Fluttertoast.showToast(
        msg: 'Data Updated',
        textColor: Colors.green,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
      //print response from server
    } else {
      print("Error during connection to server.");
      Fluttertoast.showToast(
        msg: 'Fail to Update',
        textColor: Colors.red,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      editMode = true;
      dateReceivedController = DateTime.tryParse(
          "${widget.list[widget.index]['tglterima']} 00:00:00.000");
      noSuratController.text = widget.list[widget.index]['nosurat'];
      dateLetterController = DateTime.tryParse(
          "${widget.list[widget.index]['tglsurat']} 00:00:00.000");
      isiSuratController.text = widget.list[widget.index]['isisurat'];
      dariController.text = widget.list[widget.index]['dari'];
      kepadaController.text = widget.list[widget.index]['kepada'];
      ketController.text = widget.list[widget.index]['ket'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editMode ? 'Update Surat' : 'Simpan Surat'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8),
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                ),
                onPressed: () => {
                  editMode
                      ? _dateReceivedController(context)
                      : _dateReceived(context),
                },
                child: Container(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 6),
                        child: Text('Tanggal Diterima'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.date_range_rounded,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            editMode
                                ? Waktu(dateReceivedController).yMMMMEEEEd()
                                : Waktu(dateReceived).yMMMMEEEEd(),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'No Surat',
                  hintText: 'Masukkan Nomor Surat',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                controller: noSuratController,
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                ),
                onPressed: () => {
                  editMode
                      ? _dateLetterController(context)
                      : _dateLetter(context),
                },
                child: Container(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 6),
                        child: Text('Tanggal Surat'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.date_range_rounded,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            editMode
                                ? Waktu(dateLetterController).yMMMMEEEEd()
                                : Waktu(dateLetter).yMMMMEEEEd(),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Isi Surat',
                  hintText: 'Masukkan Isi Ringkas Surat',
                  prefixIcon: Icon(Icons.edit_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                controller: isiSuratController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Dari',
                  hintText: 'Asal Surat',
                  prefixIcon: Icon(Icons.send),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                controller: dariController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Kepada',
                  hintText: 'Tujuan Surat',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                controller: kepadaController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: DropdownButton<String>(
                focusColor:Colors.white,
                value: _jnsSurat,
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                iconEnabledColor:Colors.black,
                items: <String>[
                  'Surat Masuk',
                  'Surat Keluar'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,style:TextStyle(color:Colors.black),),
                  );
                }).toList(),
                hint:Text(
                  "Jenis Surat",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                onChanged: (String value) {
                  setState(() {
                    _jnsSurat = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Keterangan',
                  hintText: 'Masukkan Keterangan Yang Diperlukan',
                  prefixIcon: Icon(Icons.speaker_notes),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                controller: ketController,
              ),
            ),
            editMode
                ? Container()
                : Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.camera),
                              onPressed: () {
                                selectFile();
                              },
                            ),
                            // Container(
                            //   margin: EdgeInsets.all(8),
                            //   child: fileUpload == null
                            //       ? Text('No Image Selected')
                            //       : Image.file(_image),
                            // ),
                            Container(
                              margin: EdgeInsets.all(8),
                              child: fileUpload == null
                                  ? Text('No File Selected')
                                  : Text(fileUpload.path),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        //show file name here
                        child: progress == null
                            ? Text("Progress: 0%")
                            : Text(
                                basename("Progress: $progress"),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                        //show progress status here
                      ),
                    ],
                  ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  // uploadImage();
                  addOrUpdateData(context);
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 40.0,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    editMode ? 'Update' : 'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
