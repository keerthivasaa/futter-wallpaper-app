import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  ImageView({@required this.imgUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _save();
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xff1C1B1B).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24, width: 1),
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                                colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Download",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _save() async {
    if (Platform.isAndroid) {
      await _askPermission();
    }
    if (Platform.isAndroid) {
      PermissionStatus permissionStorage = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permissionStorage != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissionStatus =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        permissionStorage = permissionStatus[PermissionGroup.storage] ??
            PermissionStatus.unknown;

        if (permissionStorage != PermissionStatus.granted) {
          print("❌----------has no Permission");
          return;
        }
      }
    }
    var response = await Dio()
        .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.photos]);
    } else {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
  }
}
