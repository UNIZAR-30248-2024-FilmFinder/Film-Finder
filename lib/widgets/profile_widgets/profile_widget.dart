import 'package:flutter/material.dart';
import 'dart:io';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;

  const ProfileWidget({
    super.key,
    required this.imagePath,
    required this.onClicked,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: imagePath.isNotEmpty
                  ? (Uri.tryParse(imagePath)?.isAbsolute == true
                  ? Ink.image(
                image: NetworkImage(imagePath), // Carga imagen desde la web
                fit: BoxFit.cover,
                width: 128,
                height: 128,
                child: InkWell(
                  onTap: onClicked,
                ),
              )
                  : Ink.image(
                image: FileImage(File(imagePath)), // Carga imagen desde archivo local
                fit: BoxFit.cover,
                width: 128,
                height: 128,
                child: InkWell(
                  onTap: onClicked,
                ),
              ))
                  : Ink.image(
                image: const AssetImage('assets/images/user.avif'), // Imagen por defecto
                fit: BoxFit.cover,
                width: 128,
                height: 128,
                child: InkWell(
                  onTap: onClicked,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: ClipOval(
              child: Container(
                color: const Color.fromRGBO(190, 49, 68, 1),
                padding: const EdgeInsets.all(1.5),
                child: ClipOval(
                  child: Container(
                    color: const Color.fromRGBO(21, 4, 29, 1),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isEdit ? Icons.add_a_photo : Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
