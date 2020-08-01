import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/data/data.dart';
import 'package:wallpaper/model/wallpaper_model.dart';
import 'package:wallpaper/widgets/widget.dart';

class Categories extends StatefulWidget {
  final String categorieName;
  Categories({this.categorieName});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<WallpaperModel> wallpapers = new List();

  getCategoriesWallpapers(String query) async {
    var response = await http.get(
        "https://api.pexels.com/v1/search?query=$query&per_page=50&page=1 ",
        headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach(
      (element) {
        WallpaperModel wallpaperModel = new WallpaperModel();
        wallpaperModel = WallpaperModel.fromMap(element);
        wallpapers.add(wallpaperModel);
      },
    );

    setState(() {});
  }

  @override
  void initState() {
    getCategoriesWallpapers(widget.categorieName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: brandName(),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[wallpaperList(wallpapers, context)],
            ),
          ),
        ));
  }
}
