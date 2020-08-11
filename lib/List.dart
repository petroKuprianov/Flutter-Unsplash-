import 'package:flutter/material.dart';
import 'package:flutter_test_work/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class CList extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    return CListState();
  }
}

class CListState extends State<CList> {
  List<CData> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Photo list')
      ),
      body: Container(
        child: ListView(
          children: _buildList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _loadPhoto(),
      ),
    );
  }


  _loadPhoto() async
  {
  final response = await http.get('https://api.unsplash.com/photos/random/?client_id=cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0&count=10');
  if(response.statusCode == 200) {
    final value = json.decode(response.body);

    var ccDataList = List<CData>();
    var record;
    for(var key=0;key<10;key++)
      {
        record = CData(photoName: value[key]['alt_description'],authorName: value[key]['user']['first_name'],pathSmall: value[key]['urls']['raw'], pathFull: value[key]['urls']['full']);
        ccDataList.insert(key, record);
      }

    setState(() {
      data = ccDataList;
    });

  }

  }

  void test(pathFull){
    if(MyOverlay._isVisible == false){
      MyOverlay.show(context,pathFull);
    }
    else {
      MyOverlay.hide();
    }

  }

    List<Widget> _buildList(){
      return data.map((CData f) => ListTile(
          leading:  Image.network(f.pathSmall,width: 150.0,height: 150.0,fit: BoxFit.cover),
          subtitle: Text(f.authorName),
          title: Text(f.photoName),
         onTap: (){test(f.pathFull);}
//        MyOverlay.show(context,f.pathFull);

      )).toList();

    }
  @override
  void initState(){
    super.initState();
    _loadPhoto();
  }


  }

class MyOverlay {


  static final MyOverlay _singleton = MyOverlay._internal();
  MyOverlay(){_singleton;}
  MyOverlay._internal();

  static OverlayEntry _overlayEntry;
  static OverlayState _overlayState;
  static bool _isVisible = false;

  static void show(BuildContext context,String url) {
    if (!_isVisible) {
      _overlayState = Overlay.of(context);
      _overlayEntry = _createOverlayEntry(url);
      _overlayState.insert(_overlayEntry);
      _isVisible = true;
    }
  }

  static void hide() {
    if (_isVisible) {
      _overlayEntry.remove();
      _isVisible = false;
    }
  }

  static OverlayEntry _createOverlayEntry(String url) {
    return OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: Image.network(url),
      );
    });
  }
}




