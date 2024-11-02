import 'package:film_finder/methods/user.dart';
import 'package:film_finder/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';

import '../widgets/change_password_widget.dart';
import '../widgets/delete_account_widget.dart';
import '../widgets/text_field_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String name;
  late String location;
  late String about;
  late String imagePath;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    name = widget.user['name'];
    location = widget.user['location'];
    about = widget.user['about'];
    imagePath = widget.user['imagePath'];
  }

  Future<void> _onProfilePictureClicked() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });

    }
  }

  Future<void> _updateUserProfile() async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'name': name,
        'location': location,
        'about': about,
        'imagePath': imagePath, // Actualizar con la URL si se sube a Storage
      });
      Navigator.pop(context);
    } catch (e) {
      print("Error al actualizar el perfil: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar el perfil: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: imagePath,
            onClicked: _onProfilePictureClicked,
            isEdit: true,
          ),
          const SizedBox(height: 35),
          TextFieldWidget(
            label: 'Nombre de usuario',
            text: name,
            onChanged: (value) => setState(() => name = value),
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: 'Ubicación',
            text: location,
            onChanged: (value) => setState(() => location = value),
          ),
          const SizedBox(height: 15),
          TextFieldWidget(
            label: 'Sobre mí',
            text: about,
            maxLines: 5,
            onChanged: (value) => setState(() => about = value),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ChangePasswordDialog();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                        color: Color.fromRGBO(190, 49, 68, 1),
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Cambiar contraseña',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showDeleteAccountDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(190, 49, 68, 1),
                    backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                        color: Color.fromRGBO(190, 49, 68, 1),
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Borrar cuenta',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: _updateUserProfile,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(
                  color: Color.fromRGBO(190, 49, 68, 1),
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: const Text(
              'CONFIRMAR',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}