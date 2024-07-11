// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/common/toast.dart';
import 'package:notes/user_auth/firebase_auth_implementation/firebase_auth_google.dart';
import 'package:notes/user_auth/firebase_auth_implementation/firebase_auth_services.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  bool visible = true;
  bool loader = false;
  final TextEditingController emailController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borders = OutlineInputBorder(
        borderSide:
            BorderSide(width: 10, color: Color.fromARGB(255, 47, 36, 30)),
        borderRadius: BorderRadius.all(Radius.circular(10)));

    final shadowStore = BoxDecoration(boxShadow: [
      BoxShadow(
        color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
        spreadRadius: 5,
        blurRadius: 9,
        offset: Offset(0, 0), // changes position of shadow
      ),
    ]);
    return Scaffold(
      backgroundColor: dark(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        backgroundColor: dark(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Email Address",
                      style: TextStyle(
                          color: light2(),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration: shadowStore,
                    child: TextField(
                      controller: emailController,
                      cursorColor: mid2(),
                      style: TextStyle(color: light()),
                      decoration: InputDecoration(
                          fillColor: mid(),
                          filled: true,
                          hintText: "Enter email",
                          hintStyle: TextStyle(color: light()),
                          enabledBorder: borders,
                          focusedBorder: borders),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Name",
                      style: TextStyle(
                          color: light2(),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration: shadowStore,
                    child: TextField(
                      controller: nameController,
                      cursorColor: mid2(),
                      style: TextStyle(color: light()),
                      decoration: InputDecoration(
                          fillColor: mid(),
                          filled: true,
                          hintText: "Enter Name",
                          hintStyle: TextStyle(color: light()),
                          enabledBorder: borders,
                          focusedBorder: borders),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Password",
                      style: TextStyle(
                          color: light2(),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration: shadowStore,
                    child: TextField(
                      obscureText: visible,
                      controller: passwordController,
                      cursorColor: mid2(),
                      style: TextStyle(color: light()),
                      decoration: InputDecoration(
                          fillColor: mid(),
                          filled: true,
                          hintText: "Enter Password",
                          hintStyle: TextStyle(color: light()),
                          enabledBorder: borders,
                          focusedBorder: borders,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              visible = !visible;
                              print(visible);
                            },
                            child: Icon(visible
                                ? Icons.visibility_off
                                : Icons.visibility),
                          )),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, "otpverify");
                      _signUp();
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(mid()),
                        shadowColor: const WidgetStatePropertyAll(
                            Color.fromARGB(112, 255, 255, 255)),
                        fixedSize: const WidgetStatePropertyAll(
                            Size(double.maxFinite, 45))),
                    child: Text(
                      "Register",
                      style: TextStyle(
                          color: light(),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        {FirebaseAuthGoogle.signInWithGoogle(context)},
                    style: ButtonStyle(
                        // elevation: const WidgetStatePropertyAll(10),
                        shadowColor: const WidgetStatePropertyAll(
                            Color.fromARGB(112, 255, 255, 255)),
                        backgroundColor: WidgetStateProperty.all(mid()),
                        fixedSize: const WidgetStatePropertyAll(
                            Size(double.maxFinite, 45))),
                    child: loader
                        ? CircularProgressIndicator(
                            color: light(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                color: light2(),
                              ),
                              Text(
                                "  SignIn with Google",
                                style: TextStyle(
                                    color: light2(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, 'login'),
                        child: const Text(
                          "Already Have Account?\n Login",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white60, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _signUp() async {
    setState(() {
      loader = true;
    });
    String uname = nameController.text;
    String password = passwordController.text;
    String email = emailController.text;
    User? user = await _auth.signUpWithEmailAndPassword(email, password, uname);
    setState(() {
      loader = false;
    });

    if (user != null) {
      showToast(message: "Successful Register");
      Navigator.pushNamed(context, 'login');
    } else {
      print("Some Errorrrrrrrrrrrrrrrrrrrr");
    }
  }
}
