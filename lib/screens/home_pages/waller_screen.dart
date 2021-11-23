// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:load_runner/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:load_runner/model/paymentHistoryModel.dart';
import 'package:load_runner/screens/home_pages/pPay.dart';
import 'package:load_runner/screens/ride_pages/pickup_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class Wallet2 extends StatefulWidget {
  final String name, number, token;

  Wallet2(this.name, this.number, this.token);

  @override
  _Wallet2State createState() => _Wallet2State();
}

class _Wallet2State extends State<Wallet2> {
  int minBalance = 300;
  late int withdrawBalance = 100;
  late int walletBalance = 0;
  late int walletRecharge;
  late int walletWithdraw;
  List<PaymentHistoryModel> _list = [];

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    getPayment();
    test();
    super.initState();
    // Future.delayed(Duration.zero, () => showDialog1(context: context));
  }

  void showDialog1({
    required BuildContext context,
    String title = "Withdraw",
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Size size = MediaQuery.of(context).size;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)), //this right here
            child: SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xfffd6204)),
                        ),
                        labelText: '₹',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        alignLabelWithHint: true,
                        helperText: xy(title),
                        helperStyle: TextStyle(
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Container(
                        width: size.width / 2,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: const BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              walletRecharge =
                                  int.parse(_textEditingController.text);
                              walletWithdraw =
                                  int.parse(_textEditingController.text);
                            });

                            if (title == "Recharge") {
                              if (int.parse(_textEditingController.text) >
                                  299) {
                                setState(() {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                            builder: (_) => pPay(
                                                _textEditingController.text,
                                                widget.name,
                                                widget.number)),
                                      )
                                      .then((val) => val ? getPayment() : null);
                                });
                              } else {
                                _showCupertinoDialog1(
                                    'Please make a minimum recharge of ₹300');
                              }
                            }
                            if (title == "Withdraw") {
                              _showCupertinoDialog2(
                                  'Withdraw Request has been Submitted');
                            }
                          },
                          child: Text(
                            title == "Withdraw" ? 'SUBMIT' : "NEXT",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'WALLET',
          style: TextStyle(color: Color.fromRGBO(253, 98, 4, 1)),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(width: 2, color: Colors.grey),
                    bottom: BorderSide(width: 2, color: Colors.grey))),
            height: size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 6,
                ),
                const Center(
                  child: Text(
                    'YOUR WALLET BALANCE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Center(
                  child: Text(
                    '₹ ' + walletBalance.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Minimum Recharge amount ₹ 300 '),
                    Text(' Minimum Withdraw Above ₹ 300  '),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog1(context: context, title: "Recharge");
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 18, right: 18, top: 10, bottom: 10),
                            decoration: const BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: const Text(
                              'RECHARGE',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (walletBalance > 299) {
                              showDialog1(context: context, title: "Withdraw");
                            } else
                              _showCupertinoDialog1(
                                  'Your Wallet Balance is below minimum');
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 18, right: 18, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Text(
                              'WITHDRAW',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Flexible(
            child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      leading: Text(_list[index].amount.toString()),
                      subtitle: Text(_list[index].status!),
                      trailing: Text(
                        _list[index].startDate.toString().substring(0, 11),
                        style: TextStyle(color: Colors.green, fontSize: 15),
                      ),
                      title: Text(_list[index].transactionType!));
                }),
          ),
        ],
      ),
    );
  }

  String xy(String text) {
    final String Itype;
    if (text == "Withdraw") {
      Itype = "Minimum Withdraw Balance:300";
    } else {
      Itype = "Minimum Recharge Balance:300";
    }
    return Itype;
  }

  Widget _pPayment() {
    String Url =
        "https://bf94-2402-3a80-1b25-91d2-aea8-7552-69b6-9106.ngrok.io/api/payment/neworder/";
    return WebView(
      initialUrl: 'https://flutter.dev',
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  Future test() async {
    try {
      var jsonResponse;
      var response = await http.get(
          Uri.parse(
              "https://loadrunner12.herokuapp.com/api/payment/getBalance"),
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
          });
      print("jsonResponse20");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("jsonResponse3");
        print(response.body);
        print("jsonResponse14");

        var cookies = response.headers['set-cookie'];
        if (cookies != null) {
          print("helloworld");
          print(cookies);
          jsonResponse = json.decode(response.body);
          setState(() {
            walletBalance = jsonResponse['balance'];
          });
          print("jsonResponse4");
          print(jsonResponse);
        }
      } else {
        return null;
      }
    } on TimeoutException catch (_) {
      // print("Hello");
    }
  }

  Future getPayment() async {
    String url = "https://loadrunner12.herokuapp.com/api/payment/getBalance";
    try {
      var balanceResponse = await http.get(
          Uri.parse(
              "https://loadrunner12.herokuapp.com/api/payment/getBalance"),
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            'Cookie': "token2=${widget.token}"
          });
      var paymentHistoryResponse = await http.get(
          Uri.parse("https://loadrunner12.herokuapp.com/api/payment/history"),
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            'Cookie': "token2=${widget.token}"
          });

      if (balanceResponse.statusCode == 200) {
        print(balanceResponse.body);
        var cookies = balanceResponse.headers['set-cookie'];
        if (cookies != null) {
          print(cookies);
        }
        var jsonResponse = json.decode(balanceResponse.body);
        setState(() {
          walletBalance = jsonResponse['balance'];
        });
      } else {
        return null;
      }
      if (paymentHistoryResponse.statusCode == 200) {
        var jsonResponse1 = json.decode(paymentHistoryResponse.body);

        _list = (jsonResponse1 as List)
            .map((data) => PaymentHistoryModel.fromJson(data))
            .toList();
      }
    } on TimeoutException catch (_) {
      // print("Hello");
    }
  }

  void _showCupertinoDialog1(String text) {
    showDialog(
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Icon(
              Icons.error,
              color: Colors.red,
            ),
            content: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7)),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Color(0xfffd6206)),
                  )),
            ],
          );
        });
  }

  void _showCupertinoDialog2(String text) {
    showDialog(
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Icon(
              CupertinoIcons.checkmark_seal_fill,
              color: Colors.green,
            ),
            content: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7)),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Color(0xfffd6206)),
                  )),
            ],
          );
        });
  }
}
