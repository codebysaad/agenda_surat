import 'package:agenda_surat/old/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    Key key,
    @required TextEditingController emailController,
    @required TextEditingController passwordController,
    TextEditingController nameController,
  })  : _emailController = emailController,
        _passwordController = passwordController,
        _nameController = nameController,
        super(key: key);

  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _nameController;

  List<Widget> get _registerLogo => [
    Positioned(
      child: Container(
        padding: EdgeInsets.only(bottom: 25, right: 40),
        child: Text(
          "REGI",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.center,
      ),
    ),
    Positioned(
      child: Align(
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 28),
          width: 130,
          child: Text(
            "STER",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 38),
          ),
        ),
        alignment: Alignment.center,
      ),
    ),
  ];

  List<Widget> get _loginLogo => [
    Align(
      alignment: Alignment.center,
      child: Container(
        child: Text(
          "LOGIN",
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        alignment: Alignment.center,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).canvasColor),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        child: Container(
          child: ListView(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 10,
                      top: 10,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _emailController.clear();
                          _passwordController.clear();
                          _nameController?.clear();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
                height: 50,
                width: 50,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 140,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor),
                              ),
                              alignment: Alignment.center,
                            ),
                            ..._nameController != null
                                ? _registerLogo
                                : _loginLogo
                          ],
                        ),
                      ),
                      SizedBox(height: 60),
                      if (_nameController != null)
                        CustomTextField(
                          controller: _nameController,
                          hint: "NAME",
                          icon: Icon(Icons.person),
                        ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: _emailController,
                        hint: "EMAIL",
                        icon: Icon(Icons.email),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: _passwordController,
                        hint: "PASSWORD",
                        icon: Icon(Icons.lock),
                        obsecure: true,
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        label: "REGISTER",
                        primaryColor: Theme.of(context).primaryColor,
                        secondaryColor: Colors.white,
                        onPressed: () {},
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height / 1.1,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
        ),
      ),
    );
  }
}