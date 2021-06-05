import 'package:agenda_surat/old/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:agenda_surat/old/components/clipper.dart';
import 'package:agenda_surat/old/components/bottom_sheet.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _emailController,
      _passwordController,
      _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //GO logo widget
    Widget logo() {
      return Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          child: Stack(
            children: <Widget>[
              Positioned(
                  child: Container(
                child: Align(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    width: 150,
                    height: 150,
                  ),
                ),
                height: 154,
              )),
              Positioned(
                child: Container(
                    height: 154,
                    child: Align(
                      child: Text(
                        "GO",
                        style: TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                bottom: MediaQuery.of(context).size.height * 0.046,
                right: MediaQuery.of(context).size.width * 0.22,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                bottom: 0,
                right: MediaQuery.of(context).size.width * 0.32,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    void _loginSheet(context) {
      showBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomBottomSheet(
            emailController: _emailController,
            passwordController: _passwordController,
          );
        },
      );
    }

    void _registerSheet(context) {
      showBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomBottomSheet(
            emailController: _emailController,
            passwordController: _passwordController,
            nameController: _nameController,
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: Builder(builder: (context) {
        return Column(
          children: <Widget>[
            logo(),
            Padding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomButton(
                    label: "LOGIN",
                    primaryColor: Colors.white,
                    secondaryColor: Theme.of(context).primaryColor,
                    onPressed: () => _loginSheet(context),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    label: "REGISTER",
                    primaryColor: Theme.of(context).primaryColor,
                    secondaryColor: Colors.white,
                    onPressed: () => _registerSheet(context),
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: 80, left: 20, right: 20),
            ),
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Colors.white,
                    height: 300,
                  ),
                  clipper: BottomWaveClipper(),
                ),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        );
      }),
    );
  }
}