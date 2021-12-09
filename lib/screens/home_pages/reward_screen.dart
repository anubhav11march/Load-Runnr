import 'package:flutter/material.dart';

class OffersAndReward extends StatefulWidget {
  const OffersAndReward({Key? key}) : super(key: key);

  @override
  _OffersAndRewardState createState() => _OffersAndRewardState();
}

class _OffersAndRewardState extends State<OffersAndReward> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Offers & Rewards",
          style: TextStyle(
            color: Color(0xFFFD6204),
          ),
        ),
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
      ),
      body: Image.asset(
        "assets/images/reward_page.jpg",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
