// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rolling_switch/rolling_switch.dart';

class MyHomePageState extends StatefulWidget {
//   String? status;
// MyHomePageState(this.status);
  @override
  _MyHomePageStateState createState() => _MyHomePageStateState();
}

class _MyHomePageStateState extends State<MyHomePageState> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((_){
    //   if(widget.status == "Pending"){
    //
    //     _showCupertinoDialog();
    //    }
    //   // Add Your Code here.
    // });

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      // drawer: Drawer(
      //   child:ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         child: Text(
      //           'Side menu',
      //           style: TextStyle(color: Colors.white, fontSize: 25),
      //         ),
      //         decoration: BoxDecoration(
      //             color: Colors.green,
      //             image: DecorationImage(
      //                 fit: BoxFit.fill,
      //                 image: AssetImage('assets/images/cover.jpg'))),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.input),
      //         title: Text('Welcome'),
      //         onTap: () => {},
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.account_balance_wallet_outlined),
      //         title: Text('Wallet'),
      //         onTap: () => { Navigator.push(
      //         context, new MaterialPageRoute(builder: (context) => Wallet2()))
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         title: Text('Pickup'),
      //         onTap: () => { Navigator.push(
      //             context, new MaterialPageRoute(builder: (context) => MapScreen()))},
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.border_color),
      //         title: Text('Feedback'),
      //         onTap: () => {Navigator.of(context).pop()},
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.exit_to_app),
      //         title: Text('Logout'),
      //         onTap: () => {
      //           Navigator.push(
      //             context, new MaterialPageRoute(builder: (context) => SignInPage()))},
      //       ),
      //     ],
      //   ),
      // ),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    InkWell(
                      onTap: (){
                        _scaffoldKey.currentState!.openDrawer();

                      },
                      child: Icon(
                        Icons.widgets_outlined,
                        color: Colors.deepOrange,
                        size: 40,
                      ),
                    ),
                    RollingSwitch.widget(
                      onChanged: (bool state) {
                        print('turned ${(state) ? 'on' : 'off'}');
                      },
                      rollingInfoRight: RollingWidgetInfo(
                        //icon: FlutterLogo(),
                        text: Text('Online'),
                        backgroundColor: Color.fromRGBO(253, 98, 4, 1),
                      ),
                      rollingInfoLeft: RollingWidgetInfo(
                        // icon: FlutterLogo(
                        //   style: FlutterLogoStyle.stacked,
                        // ),
                        backgroundColor: Color.fromRGBO(253, 98, 4, 1),
                        text: Text('Offline'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          child: Center(
                            child: Text(
                              'Support Icon',
                              style: TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          child: Center(
                            child: Text(
                              'GPS Icon',
                              style: TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: size.height / 2,
                alignment: Alignment.center,
                child: Container(
                  width: size.width - 40,
                  height: size.height / 4,
                  child: Text(
                    'Your Account is in Review Will be approved within 24hrs'
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("hi"),
        ));
  }

   drawerMenu(){
    return Drawer(
      child:ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {},
          ),
        ],
      ),
    );
   }

}
