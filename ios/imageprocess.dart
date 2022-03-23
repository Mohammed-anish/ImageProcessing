import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'dart:math' as m;

class ImageProcess {
  final String name;
  ImageProcess(this.name);
  StreamController change = StreamController();
  img.Image? _image;

  img.Image? get image => _image;

  set setimage(img.Image? image) {
    _image = image;
  }

  Future<img.Image> openImage() async {
    ByteData rawBytes = (await rootBundle.load(name));

    setimage = img.decodeImage(rawBytes.buffer.asUint8List());
    return image!;
  }

  Uint8List _extractPixels() {
    return image!.getBytes(format: img.Format.rgba);
  }

  List _constructRBGAfromBytes() {
    Uint8List pixels = _extractPixels();
    List imgArr = [];

    for (int y = 0; y < image!.height; y++) {
      imgArr.add([]);
      for (int x = 0; x < image!.width; x++) {
        var distance = (y * image!.width + x) * 4;

        int red = pixels[distance];
        int green = pixels[distance + 1];
        int blue = pixels[distance + 2];
        int alpha = pixels[distance + 3];

        imgArr[y].add([red, green, blue, alpha]);
      }
    }
    return imgArr;
  }

  apply(ProcessType type, List<int> kernel) {
    List pixelList = _constructRBGAfromBytes();

    if (type == ProcessType.kernel) {
      var height = image!.height;
      var width = image!.width;

      for (var y = 0; y < height - 2; y++) {
        for (var x = 0; x < width - 2; x++) {
          List<int> pixel = pixelList[y][x];
          int r = 0, g = 0, b = 0, a = 0;

          for (var ky = 0; ky < m.sqrt(kernel.length).floor(); ky++) {
            for (var kx = 0; kx < m.sqrt(kernel.length).floor(); kx++) {
              List<int> px = pixelList[y + ky][x + kx];
              var metrixPosition = (ky * 3 + kx);

              r += ((px[0] * kernel[metrixPosition])).round();
              g += ((px[1] * kernel[metrixPosition])).round();
              b += ((px[2] * kernel[metrixPosition])).round();
              a += ((px[3] * kernel[metrixPosition])).round();
            }
          }
          image!.setPixelRgba(x, y, r, g, b);
        }
      }
    }
    change.add(m.Random(500));
  }

  List<int> encodeTemporary() {
    return img.encodeJpg(image!);
  }
}

enum ProcessType { filter, kernel }
















/***import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../ios/imageprocess.dart';

void main() {
  runApp(MyApp(
    process: "",
  ));
}

class MyApp extends StatefulWidget {
  final process;
  const MyApp({Key? key, this.process}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List imgArr = [];
  var ph;
  late Uint8List extractPixels;
  ImageProcess process = ImageProcess("image/imagees.jpg");

  @override
  void initState() {
    super.initState();

    // Future<img.Image?>? openImage = process.openImage("image/imagees.jpg");
    // openImage!.then((img.Image? photo) {
    //   extractPixels = process.extractPixels(photo);

    //   // construct(extractPixels, photo);

    //   // log(pixelList[0][0].toString());
    //   //  ph = photo;
    //   ph = photo;

    //   setState(() {});
    //   // log(imgArr[0][0].toString());
    // });
  }

// _open()async{
// await process
// }

  // construct(extractPixels, photo) {
  //   for (int y = 0; y < photo!.height; y++) {
  //     imgArr.add([]);
  //     for (int x = 0; x < photo.width; x++) {
  //       var distance = (y * photo.width + x) * 4;

  //       int red = extractPixels[distance];
  //       int green = extractPixels[distance + 1];
  //       int blue = extractPixels[distance + 2];
  //       int alpha = extractPixels[distance + 3];

  //       imgArr[y].addAll([red, green, blue, alpha]);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // log(pixelList[0][0].toString());

    // log(process.image!.getBytes()[0].toString());
    return MaterialApp(
        home: Scaffold(
      body: FutureBuilder(
          future: process.openImage(),
          builder: (context, AsyncSnapshot<img.Image> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  StreamBuilder(
                      stream: process.change.stream,
                      builder: (context, snapshot) {
                        return Image.memory(
                            process.encodeTemporary() as Uint8List);
                      }),
                  TextButton(
                    onPressed: () {
                      process.apply(
                        ProcessType.kernel,
                        [],
                      );
                    },
                    child: Text("Outline"),
                  )
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    ));
  }
}
 */