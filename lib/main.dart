import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_manipulae/src/image_editing.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ImageProcessing process = ImageProcessing("image/castle.jpg");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Processing',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Image Processing'),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future: process.openImage(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  process.apply(
                      ProcessType.kernel, [-1, -1, -1, -1, 8, -1, -1, -1, -1]);

                  if (snapshot.connectionState == ConnectionState.done) {
                    return Image.memory(process.encode() as Uint8List);
                  } else {
                    return Text("error");
                  }
                },
              ),
            ],
          )),
    );
  }
}
