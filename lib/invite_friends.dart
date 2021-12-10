import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:load_runner/main.dart';
import 'package:share/share.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({Key? key}) : super(key: key);

  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          "Invite Friends",
          style: TextStyle(color: Color(0xfffd6204)),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Container(
              //   padding: const EdgeInsets.all(10),
              //   height: size.height * 0.2,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       border: Border.all(color: Colors.white)),
              //   width: size.width * 0.8,
              //   child: const Text(
              //     "SHARE THIS APP WITH\nYOUR FRIENDS",
              //     textAlign: TextAlign.left,
              //     style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Color(0xfffd6204)),
              //   ),
              // ),
              Image.asset("assets/images/refer_icon.PNG"),
              const SizedBox(
                height: 10,
              ),
              const Text("Refer Friend Via"),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.grey,
                width: size.width * 0.8,
                child: InkWell(
                  onTap: () {
                    Share.share(
                        'Become "LoadRunnr Delivery Partner"\n*Earn Upto Rs.1000/Day\n*Earn Lifetime Refferal Income\nUse Referral Number ${globalSharedPref.getString("Phone_No")}\n\nInstall The App Now\nplay.google.com/store/apps/details?id=com.driver.load_runner');
                  },
                  child: const ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Whatsapp",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Color(0xFFFD6204),
                width: size.width * 0.8,
                child: InkWell(
                  onTap: () {
                    Share.share(
                        'Become "LoadRunnr Delivery Partner"\n*Earn Upto Rs.1000/Day\n*Earn Lifetime Refferal Income\nUse Referral Number ${globalSharedPref.getString("Phone_No")}\n\nInstall The App Now\nplay.google.com/store/apps/details?id=com.driver.load_runner');
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.sms_rounded,
                      color: Colors.white,
                    ),
                    title: Text(
                      "SMS",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: InkWell(
                        child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width * 0.8,
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children:  [
                //     InkWell(
                //         onTap:(){
                //           Share.share('check out my website https://youtube.com');
                //         },
                //         child: const Icon(Icons.email,color: Color(0xfffd6204),)),
                //     Container(
                //       height: 80,
                //       padding:  EdgeInsets.all(10),
                //       child: const VerticalDivider(
                //         color: Colors.black,
                //         thickness: 3,
                //         indent: 20,
                //         endIndent: 0,
                //         width: 20,
                //       ),
                //     ),
                //     InkWell(onTap:(){
                //       Share.share('check out my website https://youtube.com');
                //     },child: const Icon(Icons.share,color: Color(0xfffd6204),)),

                //   ],
                // )
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Disclaimer",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Text(
                  "Refer your friends become LoadRunnr Delivery Partner & Earn Upto 2% Of Their Earnings From LoadRunnr , Should Be A Verified LoadRunnr Delivery Partner, Should Have At least Completed an Order With LoadRunnr, LoadRunnr Has Every Right To Block The Delivery Partner If Found Fraud, LoadRunnr Has The Right To Modify The Referral Plans.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
