import 'package:flutter/material.dart';
import 'package:magator/utils/themes/colors.dart';

class CustomDropDown extends StatelessWidget {
  final String hint;
  final Map<dynamic, Widget> items;
  final dynamic value;
  final double width;
  final void Function(dynamic value) onChange;
  const CustomDropDown(this.hint, this.items, {super.key, required this.width, required this.value, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
    height: 50,
    width: width,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: Color.fromARGB(255, 135, 212, 182),
      borderRadius: BorderRadius.all(Radius.circular(50))
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButton(
        items: [
          for (int i = 0; i < items.length; i++)
            DropdownMenuItem(value: items.keys.toList()[i],child: items.values.toList()[i])
        ],
        value: value,
        onChanged: (value) {
          onChange(value);
        },
        hint: Text(hint,
          style: const TextStyle(
            color: Color.fromARGB(255, 136, 108, 55)
          )
        ),
        isExpanded: true,
        dropdownColor: const Color.fromARGB(255, 17, 15, 15),
        itemHeight: 50,
        menuMaxHeight: 200,
        style: const TextStyle(color: Colors.white),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        iconSize: 30,
        iconEnabledColor: primaryColor,
      ),
    ),
  );
  }
}