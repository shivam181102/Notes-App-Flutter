import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumberController.text.trim(),
      'password': passwordController.text.trim(),
    };
  }

  @override
  Widget build(BuildContext context) {
    void _login() {
      final Map<String, dynamic> data = toJson();
      print("User Login is $data");
    }

    const borders = OutlineInputBorder(
        borderSide: BorderSide(width: 10, color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10)));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Enter Phone Number",
                      enabledBorder: borders,
                      focusedBorder: borders),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Password",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Enter Password",
                      enabledBorder: borders,
                      focusedBorder: borders),
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _login,
                  style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(12),
                      shadowColor: const WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      fixedSize: const WidgetStatePropertyAll(
                          Size(double.maxFinite, 45))),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'register'),
                      child: const Text(
                        "Don't have Account? Register",
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
    );
  }
}
