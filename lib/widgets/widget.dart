import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/model/wallpaper_model.dart';
import 'package:wallpaper/views/image_view.dart';

Widget brandName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Text(
        "Wallpaper",
        style: TextStyle(color: Color(0xff3d471f), fontFamily: 'Overpass'),
      ),
      Text(
        "Stack",
        style: TextStyle(color: Color(0xff98b53f), fontFamily: 'Overpass'),
      )
    ],
  );
}

Widget wallpaperList(List<WallpaperModel> wallpapers, context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((wallpaper) {
        return GridTile(
          child: Container(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            imgUrl: wallpaper.src.portrait,
                          )),
                );
              },
              child: Hero(
                tag: wallpaper.src.portrait,
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      wallpaper.src.portrait,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
