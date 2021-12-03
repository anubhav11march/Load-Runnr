import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Earnings extends StatefulWidget {
  const Earnings({Key? key}) : super(key: key);

  @override
  _EarningsState createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  // final List<BarChartModel> data = [
  //   BarChartModel(
  //     year: "2014",
  //     financial: 250,
  //     color: charts.ColorUtil.fromDartColor(Color(0xFF47505F)),
  //   ),
  //   BarChartModel(
  //     year: "2015",
  //     financial: 300,
  //     color: charts.ColorUtil.fromDartColor(Colors.red),
  //   ),
  //   BarChartModel(
  //     year: "2016",
  //     financial: 100,
  //     color: charts.ColorUtil.fromDartColor(Colors.green),
  //   ),
  //   BarChartModel(
  //     year: "2017",
  //     financial: 450,
  //     color: charts.ColorUtil.fromDartColor(Colors.yellow),
  //   ),
  //   BarChartModel(
  //     year: "2018",
  //     financial: 630,
  //     color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
  //   ),
  //   BarChartModel(
  //     year: "2019",
  //     financial: 1000,
  //     color: charts.ColorUtil.fromDartColor(Colors.pink),
  //   ),
  //   BarChartModel(
  //     year: "2020",
  //     financial: 400,
  //     color: charts.ColorUtil.fromDartColor(Colors.purple),
  //   ),
  // ];
  //


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Earnings",style: TextStyle(
          color: Color(0xfffd6206)

        ),),
      ),
      body: Column(
        children:  [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,50,0,0),
              child: Column(
                children: const [
                  Text("Total Earnings",style: TextStyle(
                    fontSize: 15,
                    color: Color(0xfffd6206)
                  ),),
                  Text("Rs\ 1832.5",style: TextStyle(
                    fontSize: 25
                  ),),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text("0\nRIDES",textAlign: TextAlign.center,style: TextStyle(
                color: Color(0xfffd6206)
              ),),
              Text("0\nCANCELLED",textAlign: TextAlign.center,style: TextStyle(
                color: Color(0xfffd6206)
              ),),
              Text("0\nUPCOMING",textAlign: TextAlign.center,style: TextStyle(
                color: Color(0xfffd6206)
              ),),
            ],
          ),
          const SizedBox(height: 30,),
          // Container(
          //   height: 100,
          //   child: DatePicker(
          //     DateTime.now(),
          //     width: 60,
          //     height: 80,
          //     controller: _controller,
          //     initialSelectedDate: DateTime.now(),
          //     selectionColor: Color(0xfffd6206),
          //     selectedTextColor: Colors.white,
          //     // inactiveDates: [
          //     //   DateTime.now().add(const Duration(days: 3)),
          //     //   DateTime.now().add(const Duration(days: 4)),
          //     //   DateTime.now().add(const Duration(days: 7))
          //     // ],
          //     onDateChange: (date) {
          //       // New date selected
          //       setState(() {
          //         _selectedValue = date;
          //       });
          //     },
          //   ),
          // ),
          const SizedBox(height: 10,),
          TableCalendar(focusedDay: DateTime.now(), firstDay: DateTime(2020), lastDay: DateTime(2200),calendarFormat: CalendarFormat.week,),
          const SizedBox(height: 10,),
          Container(
            height: 200,
          ),
          const SizedBox(height: 10,),


          Container(
            height: 206,
            color: Colors.white,
            child: Column(
              children: [
                Flexible(
                  // color: Colors.white,
                  child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (BuildContext context,int index){
                        return const ListTile(
                            trailing: Text("Bookings",
                              style: TextStyle(
                                  color: Colors.green,fontSize: 15),),
                            title:Text("Oct 22, 2021"),
                          subtitle: Text("Rs 10.0"),
                        );
                      }
                  ),
                ),
              ],
            ),
          )

          // Center(
          //   child: EarningChart(
          //     data: data,),
          // ),
        ],
      ),
    );
  }

}