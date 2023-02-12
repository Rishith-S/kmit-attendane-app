// ignore_for_file: use_key_in_widget_constructors, no_logic_in_create_state, must_be_immutable

import 'package:flutter/material.dart';

class QR extends StatefulWidget {
  String img;
  QR({required this.img});
  @override
  State<QR> createState() => _QRState(img);
}

class _QRState extends State<QR> {
  String img;
  _QRState(this.img);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRcode'),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height/10,),
          Image.network(
                  'http://teleuniv.in/netra/studentQR/getQR.php?qr=${img.toUpperCase()}.png'),
        ],
      ),
    );
  }
}
