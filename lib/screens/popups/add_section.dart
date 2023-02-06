import 'package:flutter/material.dart';

import '../../utils/themes/colors.dart';

class AddNewSection extends StatelessWidget {
  final void Function(String name) onSubmit;
  AddNewSection({super.key, required this.onSubmit});

  final TextEditingController sectionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    alignment: Alignment.center,
    elevation: 3,
    // shadowColor: Colors.white,
    backgroundColor: const Color.fromARGB(255, 57, 56, 56),
    icon: const Icon(Icons.add_card_rounded, color: primaryColor),
    title: const Text("Add New Section"),
    shape:  RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          // enabled: isGetOtpButtonPressed ? false : true,
          controller: sectionController,
          style: const TextStyle(color: Color.fromARGB(255, 28, 29, 77)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 135, 212, 182),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50)),
            hintText: "section name",
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 136, 108, 55)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only( top: 10.0),
          child: InkWell(
            child: Container(
              width: 300,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(                color: const Color.fromARGB(255, 49, 212, 150),
                borderRadius: BorderRadius.circular(50)
              ),
              child: const Text("Add",
                style: TextStyle(
                  color: Color.fromARGB(255, 28, 29, 77),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
            onTap: () async {
              if (sectionController.text.isNotEmpty) {
                Navigator.pop(context);
                onSubmit(sectionController.text);
              }
            }
          ),
        ),
      ]
    ),
  );
  }
}

AlertDialog addNewSection({required void Function(String name) onTap}) {
  TextEditingController sectionController = TextEditingController();
  return AlertDialog(
    alignment: Alignment.center,
    elevation: 3,
    // shadowColor: Colors.white,
    backgroundColor: const Color.fromARGB(255, 57, 56, 56),
    icon: const Icon(Icons.add_card_rounded),
    title: const Text("Add New Section"),
    shape:  RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          // enabled: isGetOtpButtonPressed ? false : true,
          controller: sectionController,
          style: const TextStyle(color: Color.fromARGB(255, 28, 29, 77)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 135, 212, 182),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50)),
            hintText: "section name",
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 136, 108, 55)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only( top: 10.0),
          child: InkWell(
            child: Container(
              width: 300,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(                color: const Color.fromARGB(255, 49, 212, 150),
                borderRadius: BorderRadius.circular(50)
              ),
              child: const Text("Add",
                style: TextStyle(
                  color: Color.fromARGB(255, 28, 29, 77),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
            onTap: () async {
              if (sectionController.text.isNotEmpty) {
                // Navigator.pop(context);
                onTap(sectionController.text);
              }
            }
          ),
        ),
      ]
    ),
  );
}