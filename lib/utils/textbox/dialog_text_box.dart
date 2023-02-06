import 'package:flutter/material.dart';

class CustomTextBox extends StatefulWidget {
  final String hint;
  final double width;
  final TextEditingController controller;
  final int? limit;
  const CustomTextBox(this.hint, this.width, this.controller, {super.key, this.limit});

  @override
  State<CustomTextBox> createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<CustomTextBox> {
  late int leftSpace;

  @override
  void initState() {
    super.initState();
    if (widget.limit != null) {
      leftSpace = widget.limit!-widget.controller.text.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: widget.width,
      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(color: Color.fromARGB(255, 28, 29, 77)),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 135, 212, 182),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50)
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 136, 108, 55)),
          suffix: (widget.limit != null) ? Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            child: Text("$leftSpace")
          ) : null
        ),
        onChanged: (text) {
          if (widget.limit != null) {
            setState(() {
              leftSpace = widget.limit! - text.length;
            });
          }
        },
      ),
    );
  }
}

Widget textBox(String hint, double width, TextEditingController controller, {int? limit}) {
  return SizedBox(
    height: 50,
    width: width,
    child: TextFormField(
      controller: controller,
      style: const TextStyle(color: Color.fromARGB(255, 28, 29, 77)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 135, 212, 182),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(50)
        ),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 136, 108, 55)),
        suffix: (limit != null) ? Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          child: Text("")
        ) : null
      ),
    ),
  );
}