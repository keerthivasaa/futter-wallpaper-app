import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper/data/data.dart';
import 'package:wallpaper/model/categories_model.dart';
import 'package:wallpaper/model/wallpaper_model.dart';
import 'package:wallpaper/views/category.dart';
import 'package:wallpaper/views/image_view.dart';
import 'package:wallpaper/views/search.dart';
import 'package:wallpaper/widgets/widget.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategorieModel> categories = new List();
  List<WallpaperModel> wallpapers = new List();
  TextEditingController searchController = new TextEditingController();

  getTrendingWallpapers() async {
    var response = await http.get(
        "https://api.pexels.com/v1/search?query=nature+coding&per_page=50&page=1 ",
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
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: brandName(),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xfff5f8fd),
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: "Search wallpaper",
                              border: InputBorder.none),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Search(searchQuery: searchController.text),
                            ),
                          );
                        },
                        child: Container(
                          child: Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 80,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CategoriesTile(
                        title: categories[index].categorieName,
                        imgUrl: categories[index].imgUrl,
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                wallpaperList(wallpapers, context)
              ],
            ),
          ),
        ));
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;
  CategoriesTile({this.title, this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Categories(
                    categorieName: title.toLowerCase(),
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            imgUrl: null,
                          )),
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: 4),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imgUrl,
                        height: 50,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 50,
              width: 100,
              alignment: Alignment.center,
              child: Text(
                title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
