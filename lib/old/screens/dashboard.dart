import 'package:agenda_surat/old/helpers/models.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget{
  final String data;

  Dashboard(this.data);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Container(
        child: Center(
          child: Text('Welcome '+ 'data.username'),
        ),
      ),
    );
  }
}