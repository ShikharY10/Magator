import 'package:flutter/material.dart';
import 'package:magator/utils/themes/colors.dart';

class CustomDatePicker extends StatefulWidget {
  final String hint;
  final dynamic value;
  final double? width;
  final String? placeHolder;
  final void Function(DateTime value) onTap;
  const CustomDatePicker({super.key, required this.hint, this.value, this.width, this.placeHolder, required this.onTap});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late String buttonHint;
  bool isValuePicked = false;

  String formateDate(DateTime date) {
    String initial = date.toString().split(" ")[0];
    List<String> splited = initial.split("-");
    String newDate = splited[2] + "/" + splited[1] + "/" + splited[0];
    return newDate;
  }

  @override
  void initState() {
    super.initState();
    buttonHint = widget.hint;
    if (widget.placeHolder != null) {
      isValuePicked = true;
      buttonHint = widget.placeHolder!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: primaryColor,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      child: Container(
        height: 50,
        width: widget.width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 135, 212, 182),
          borderRadius: BorderRadius.all(Radius.circular(50))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Flexible(
                flex: 7,
                child: Text(buttonHint,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isValuePicked ? FontWeight.w500 : null,
                    color: isValuePicked ? const Color.fromARGB(255, 28, 29, 77) : const Color.fromARGB(255, 136, 108, 55)
                  ),
                )
              ),
              Flexible(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.date_range_rounded)
                )
              ),
            ],
          ),
        )
      ),
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context, 
          initialDate: DateTime.now(), 
          firstDate: DateTime.now().subtract(const Duration(days: 2*365)),
          lastDate: DateTime.now().add(const Duration(days: 5* 365)),
          helpText: "Select ${widget.hint}",
          confirmText: "SELECT",
        );
        if (selectedDate != null) {
          String newHint = formateDate(selectedDate);
          setState(() {
            isValuePicked = true;
            buttonHint = newHint;
          });
          widget.onTap(selectedDate);
        }
      },
    );
  }
}