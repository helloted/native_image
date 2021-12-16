import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class NativeImage extends StatefulWidget {
  final String textureName;
  final double height;
  final double width;
  NativeImage(
      {required this.textureName, required this.width, required this.height});

  static const MethodChannel _channel = const MethodChannel('native_image');
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  State<StatefulWidget> createState() {
    return _NativeImageState();
  }
}

class _NativeImageState extends State<NativeImage> {
  static const MethodChannel _channel = const MethodChannel('native_image');
  int _textureId = -1;

  @override
  void initState() {
    super.initState();
    _updateTexture();
  }

  void _updateTexture() async {
    _textureId = await _channel.invokeMethod(widget.textureName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width, //image的真实宽
      height: widget.height, //image的真实高
      child: Texture(
        filterQuality: FilterQuality.none,
        textureId: _textureId,
      ),
    );
  }
}
