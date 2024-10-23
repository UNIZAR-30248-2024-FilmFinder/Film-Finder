import 'package:film_finder/methods/user.dart';
import 'package:film_finder/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';

import '../widgets/change_password_widget.dart';
import '../widgets/delete_account_widget.dart';
import '../widgets/text_field_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreen createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProfileScreen> {
  late User user;

  late String imagePath;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    imagePath = widget.user.imagePath;
  }

  //ESTO DEBERA ACTUALIZAR LA FOTO DE LA BASE DE DATOS (cambiar el imagePath)
  Future<void> _onProfilePictureClicked() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
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
          const SizedBox(
            height: 35,
          ),
          TextFieldWidget(
            label: 'Nombre de usuario',
            text: user.name,
            onChanged: (name) {},
          ),
          const SizedBox(
            height: 15,
          ),
          TextFieldWidget(
            label: 'Ubicación',
            text: user.location,
            onChanged: (location) {},
          ),
          const SizedBox(
            height: 15,
          ),
          TextFieldWidget(
            label: 'Sobre mi',
            text: user.about,
            maxLines: 5,
            onChanged: (about) {},
          ),
          const SizedBox(
            height: 20,
          ),
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
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
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
            ),
            child: const Text(
              'CONFIRMAR',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
