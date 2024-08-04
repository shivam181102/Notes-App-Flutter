import 'package:flutter/material.dart';

class Otpverify extends StatelessWidget {
  Otpverify({super.key});

  @override
  Widget build(BuildContext context) {
    void _login() {}

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
              "Verify OTP",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "OTP",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Enter OTP",
                      enabledBorder: borders,
                      focusedBorder: borders),
                  keyboardType: TextInputType.phone,
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
                    "Register",
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
                        "Don't receive OTP? Register",
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
