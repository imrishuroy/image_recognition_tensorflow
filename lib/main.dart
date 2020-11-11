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

  selectImage() async {
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _isLoading = true;
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('Something went wrong');
      }
    });
  }

  @override
  void initState() {
    super.initState();
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
              : Center(child: Text('No Image Found!')),
        ],
      ),
    );
  }
}
