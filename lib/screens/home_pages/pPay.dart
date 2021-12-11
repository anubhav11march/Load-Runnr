import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:load_runner/model/paymentHistoryModel.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class pPay extends StatefulWidget {
  String amount, name, phone;
  pPay(this.amount, this.name, this.phone);

  @override
  _pPayState createState() => _pPayState();
}

class _pPayState extends State<pPay> {
  String Url = "https://loadrunner12.herokuapp.com/api/payment/neworder/";
  WebViewController? _webViewController;
  List<PaymentHistoryModel> _list = [];
  @override
  void initState() {
    _webViewController = null;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String pass = Url + widget.amount + "/" + widget.name + "/" + widget.phone;
    print(pass);
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
          'RECHARGE',
          style: TextStyle(color: Color.fromRGBO(253, 98, 4, 1)),
        ),
      ),
      body: WebView(
        debuggingEnabled: false,
        initialUrl: pass,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onPageFinished: (page) {
          print(page);

          if (page.contains("/verify")) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            });
          }
        },
      ),
    );
  }

  Future test() async {
    String url = "https://loadrunner12.herokuapp.com/api/payment/getBalance";
    try {
      var jsonResponse;
      var response = await http.get(
          Uri.parse(
              "https://loadrunner12.herokuapp.com/api/payment/getBalance"),
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
          });
      if (response.statusCode == 200) {
        print("jsonResponse1");
        print(response.body);
        print("jsonResponse1");
        var cookies = response.headers['set-cookie'];
        if (cookies != null) {
          print(cookies);
        }
        jsonResponse = json.decode(response.body);
        print("jsonResponse1");
        print(jsonResponse);
      } else {
        return null;
      }
    } on TimeoutException catch (_) {
      // print("Hello");
    }
  }

  Future getHistory() async {
    String url = "https://loadrunner12.herokuapp.com/api/payment/history";
    try {
      var jsonResponse;
      var response = await http.get(
          Uri.parse("https://loadrunner12.herokuapp.com/api/payment/history"),
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
          });
      if (response.statusCode == 200) {
        print("jsonResponse1");
        print(response.body);
        print("jsonResponse1");
        var cookies = response.headers['set-cookie'];
        if (cookies != null) {
          print(cookies);
        }
        jsonResponse = json.decode(response.body);
        print("jsonResponse1");
        print(jsonResponse);
      } else {
        return null;
      }
    } on TimeoutException catch (_) {
      // print("Hello");
    }
  }
}
