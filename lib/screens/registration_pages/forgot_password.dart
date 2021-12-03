import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:load_runner/screens/registration_pages/create_new_password_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _reEnterPasswordController = TextEditingController();
  TextEditingController otp = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool _showCreateNewPassFields = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _topImage(),
              _forgotPasswordText(),
              SizedBox(
                height: 20,
              ),
              _loginText(),
              SizedBox(
                height: 40,
              ),
              _phoneNumberdWidget(),
              SizedBox(
                height: 30,
              ),
              _otpWidget(),
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

  _forgotPasswordText() {
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

  _phoneNumberdWidget() {
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
        controller: _phoneNumberController,
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

  _otpWidget() {
    return Visibility(
      visible: verificationId != null,
      child: Container(
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
          controller: otp,
          maxLength: 6,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
            hintText: "Enter OTP",
            hintStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Colors.grey.shade500,
              ),
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
            onPressed: () {
              verificationId == null ? getOtp() : _verifyOTP();
            },
            color: Colors.pinkAccent,
            textColor: Colors.white,
            child: Text(
              verificationId == null ? "Generate OTP" : "Verify OTP",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getOtp() async {
    await _auth.verifyPhoneNumber(
      timeout: Duration(milliseconds: 59000),
      phoneNumber: "+91" + _phoneNumberController.text,
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          // isLoading = false;
        });
      },
      verificationFailed: (verificationFailed) async {
        setState(() {
          // isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(verificationFailed.message!),
          ),
        );
      },
      codeSent: (verificationId, [resendingToken]) async {
        setState(() {
          // isLoading = false;
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
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

  _verifyOTP() {
    if (otp.text.isEmpty || otp.text == "") {
              ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Enter OTP"),
          ),
        );
    } else {
      AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId.toString(), smsCode: otp.text);
      signInWithPhoneAuthCredential(phoneAuthCredential);
    }
  }

  Future<void> signInWithPhoneAuthCredential(
      AuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        print("User entered right otp");
        setState(() {
          _showCreateNewPassFields = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNewPasswordScreen(
              phoneNumber: _phoneNumberController.text,
            ),
          ),
        );
      } else {
                      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Enter Correct OTP"),
          ),
        );
      }
    } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Enter Correct OTP"),
          ),
        );
    }
  }

  Widget passwordFormFields() {
    return ListView(
      children: [
        Container(
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
            controller: _newPasswordController,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.call),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
              hintText: "Enter New Password",
              hintStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
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
            controller: _reEnterPasswordController,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.call),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
              hintText: "Re Enter Password",
              hintStyle: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
