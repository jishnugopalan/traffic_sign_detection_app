

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading=true;
  late File? _image;
  late List _output;
  final picker=ImagePicker();
  void initState(){
    super.initState();
    loadModel().then((value){
      setState((){

      });
    });
  }
  detectImage(File image) async {
    print("in detect");

    var output=await Tflite.runModelOnImage(path: image.path,numResults: 43);
    setState(() {
      print("in set state");
      _output=output!;
      print(_output);
      _loading=false;
      print(_loading);
    });
  }
  loadModel() async{
    print("in load model");
    await Tflite.loadModel(model: 'assets/model.tflite',labels: 'assets/model.txt',numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,);
  }
  @override
  void dispose(){
    super.dispose();
  }
  pickImage() async{
    var image=await picker.pickImage(source: ImageSource.camera,);
    if(image==null) return null;
    setState(() {
      _image=File(image.path);
    });
    detectImage(File(_image!.path));
  }
  pickGalleryImage() async{
    var image=await picker.pickImage(source: ImageSource.gallery);
    if(image==null) return null;
    setState(() {
      _image=File(image.path);
    });
    print("in detect");
    print(image.path);
    var output=await Tflite.runModelOnImage(path: image.path,numResults: 43);
    setState(() {
      print("in set state");
      _output=output!;
      print(_output);
      _loading=false;
    });
  }



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Traffic Sign Detection"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(

        child: ListView(

          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Select Image",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.purple),),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width*.05),
              child:ElevatedButton.icon(
                onPressed: pickGalleryImage,
                icon: Icon(Icons.photo),
                label: Text("Pick Image"),

                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: 15),

                ),
              )

            ),
            Container(
                margin: EdgeInsets.all(MediaQuery.of(context).size.width*.05),
                child:ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: Icon(Icons.camera_alt),
                  label: Text("Take Photo"),

                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 15),

                  ),
                )

            ),



            SizedBox(
              height: 80,
            ),
            Center(
                child: _loading ?
                Container(
                  width: 350,
                  child: Column(children: [
                   Text("Please choose an option"),
                    //   SizedBox(height: 10,)
                  ],),
                ):Container(
                  child: Column(
                    children: [
                      Container(
                          height: 250,
                          child: Image.file(File(_image!.path))
                      ),
                      SizedBox(height: 10,),
                      _output !=null && _output.length!=0 ? Text('Traffic Sign Predicted As',style: TextStyle(color: Colors.black,fontSize: 20),) : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Text('${_output[0]['label']}',style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),)
                    ],
                  ),
                )
            ),





          ],
        ),
      ),

    );
  }
}
