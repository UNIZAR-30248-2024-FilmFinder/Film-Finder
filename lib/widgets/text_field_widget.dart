import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String text;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const TextFieldWidget(
      {super.key,
      required this.label,
      required this.text,
      this.maxLines = 1,
      required this.onChanged});

  @override
  // ignore: library_private_types_in_public_api
  _TextFieldWidget createState() => _TextFieldWidget();
}

class _TextFieldWidget extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          maxLines: widget.maxLines,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromRGBO(190, 49, 68, 1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
