import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walkmeter_app/screens/login_screen.dart';
import 'package:walkmeter_app/services/authenticationService.dart';
import '';

class RegistrationScreen extends StatefulWidget {

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _key = GlobalKey<FormState>();

  final AuthenticationService _auth = AuthenticationService();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text("Registration"),
      ),
      body: isLoading? Center(
          child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(16),
              alignment: Alignment.center,
        child: Form(
            key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return value.length > 0 ? null : "Enter valid Name";
                    },
                    decoration: InputDecoration(
                        hintText: "Enter Name",
                        labelText: "Name",
                        border: OutlineInputBorder()),

                  ),
                  SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return value.contains("@")
                          ? null
                          : "Enter valid Email";
                    },

                    decoration: InputDecoration(
                        hintText: "Enter Email",
                        labelText: "Email",
                        border: OutlineInputBorder()),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return value.length > 6
                          ? null
                          : "Password must be 6 characters";
                    },

                    decoration: InputDecoration(
                        hintText: "Enter Password",
                        labelText: "Password",
                        border: OutlineInputBorder()),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (value) {
                      return value.length < 10
                          ? "Enter valid Mobile"
                          : null;
                    },

                    decoration: InputDecoration(
                        hintText: "Enter Mobile Number",
                        labelText: "Mobile Number",
                        border: OutlineInputBorder()),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return value.contains("0") ? "Enter Valid Age": null;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter Your Age",
                        labelText: "Age",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    controller: _dobController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return value.contains("123456789") ? "Enter Your Date of birth": null;
                    },
                    decoration: InputDecoration(
                        hintText: "Enter Your Date of birth",
                        labelText: "Date of birth",
                        helperText: "Provide DOB on dd-mm-yyyy",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.orangeAccent,
                      onPressed: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LoginScreen()));
                        signup();
                      },
                      child: Text(
                        "Register",
                      ),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              )),
      ),
          ),
    );
}

  void signup() {
    if (_key.currentState.validate()) {
      createUser();
      setState(() {
        isLoading = true;
      });
    };
  }

  void createUser() async {
    dynamic result = await _auth.createNewUser(
        _nameController.text, _emailController.text, _passwordController.text, _mobileController.text, _ageController.text, _dobController.text);
    if (result == null) {
      print('Enter correct details');
    } else {
      print(result.toString());
      _nameController.clear();
      _passwordController.clear();
      _emailController.clear();
      _mobileController.clear();
      _ageController.clear();
      _dobController.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LoginScreen()));
    }
  }
}




