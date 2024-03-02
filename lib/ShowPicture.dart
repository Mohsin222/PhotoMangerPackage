import 'dart:io';

import 'package:flutter/material.dart';

class SHowPic extends StatefulWidget {
  final List<File?> images;
  const SHowPic({super.key, required this.images});

  @override
  State<SHowPic> createState() => _SHowPicState();
}

class _SHowPicState extends State<SHowPic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: List.generate(
            widget.images.length,
            (index) => SizedBox(
                height: 100, child: Image.file(widget.images[index]!))),
      ),
    );
  }
}
