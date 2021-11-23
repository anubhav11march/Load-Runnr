import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _topImage(),
              _welcomeText(),
              SizedBox(
                height: 20,
              ),
              _loginText(),
              SizedBox(
                height: 40,
              ),
              _emailIdWidget(),
              SizedBox(
                height: 30,
              ),
              _loginButton(),
              _forgotpassDesignText(),
            ],
          ),
        ),
      ),
    );
  }

  _topImage() {
    return Image(
      image: AssetImage(
        "assets/images/AppIcon.jpeg",
      ),
      height: 200,
      width: 500,
    );
  }

  _welcomeText() {
    return RichText(
      text: TextSpan(
        text:
            "Forgot your password? Confirm your phone number to reset password",
        style: GoogleFonts.lato(
            textStyle: TextStyle(color: Colors.pink, fontSize: 16)),
      ),
    );
  }

  _loginText() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Text(
            'Forgot Password',
            textAlign: TextAlign.left,
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 20),
            ),
          ),
        )
      ],
    );
  }

  _emailIdWidget() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        style: TextStyle(
          color: Colors.black,
        ),
        keyboardType: TextInputType.number,
        maxLength: 10,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.call),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
          hintText: "Enter your phone number",
          hintStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }

  _loginButton() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 30),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.pinkAccent)),
            onPressed: () {},
            color: Colors.pinkAccent,
            textColor: Colors.white,
            child: Text(
              "Get Your Password",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _forgotpassDesignText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 10),
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              'Forgot Password',
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 30, color: Colors.pink.shade100),
              ),
            ),
          ),
        )
      ],
    );
  }
}
