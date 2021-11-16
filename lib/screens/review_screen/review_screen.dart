import 'package:flutter/material.dart';
import 'package:load_runner/screens/registration_pages/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueAccent)),
                child: Text(
                    "YOUR ACCOUNT IS IN REVIEW \n WILL BE APPROVED WITHIN 24 HOURS"),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SignInPage(),
                      ),
                    );
                  },
                  child: Text("Logout"))
            ],
          ),
        ),
      ),
    );
  }
}
