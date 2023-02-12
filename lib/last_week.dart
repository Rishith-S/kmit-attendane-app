import 'package:flutter/material.dart';
import 'package:netra/qr_screen.dart';

class LastWeek extends StatefulWidget {
  String showday,showatt,img;
  LastWeek({super.key, required this.showday,required this.showatt,required this.img});

  @override
  State<LastWeek> createState() => _LastWeekState(showday,showatt,img);
}

class _LastWeekState extends State<LastWeek> {
  String showday,showatt,img;
  _LastWeekState(this.showday,this.showatt,this.img);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Last 2 weeks "),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> QR(img: img)));
          }, icon: const Icon(Icons.qr_code))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/10,),
              const Text('Last 2 weeks : ',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
              const SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(showday,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Text(showatt,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}
