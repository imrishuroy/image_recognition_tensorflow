import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Recognition',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  final _picker = ImagePicker();
  bool _isLoading = false;

  List _result;
  String _name = '';
  String _confidence = '';

  selectImage() async {
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
      _isLoading = true;
    });
    applyModalOnImage(File(pickedImage.path));
  }

  loadImage() async {
    var resultant = await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
    print(resultant.toString());
  }

  applyModalOnImage(File image) async {
    var res = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _result = res;

      String str = _result[0]['label'];
      _name = str.substring(2);
      _confidence = _result != null
          ? (_result[0]['confidence'] * 100).toString().substring(0, 2) + '%'
          : '';
    });
  }

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: selectImage,
        tooltip: 'Pick a image',
        child: Icon(Icons.image),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Image Recognition'),
      ),
      body: Column(
        children: [
          _isLoading
              ? Container(
                  margin: EdgeInsets.all(15.0),
                  height: 300,
                  width: double.infinity,
                  child: Image.file(_image),
                )
              : Center(
                  child: Text('No Image Found!'),
                ),
          SizedBox(height: 100.0),
          Text('Name : $_name'),
          SizedBox(height: 20.0),
          Text('Confidence : $_confidence')
        ],
      ),
    );
  }
}
