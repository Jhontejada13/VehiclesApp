import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vehicles_app/models/response.dart';

class DisplayPictureScreen extends StatefulWidget {
  final XFile image;

  DisplayPictureScreen({required this.image});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa de tu foto'),
      ),
      body: Column(
        children: [
          Image.file(
            File(widget.image.path),
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover            
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: <Widget> [
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Usar Foto'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return const Color(0xFF207398);
                        }
                      ),
                    ),
                    onPressed: () {
                      Response response = Response(isSucces: true, result: widget.image);
                      Navigator.pop(context, response);
                    }
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Volver a tomar'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return const Color(0xFFE03B8B);
                        }
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                  ),
                ),
              ]
            ),
          )
        ],
      )
    );
  }
}