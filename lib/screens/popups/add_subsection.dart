import 'package:flutter/material.dart';
import 'package:magator/utils/buttons/submit.dart';
import 'package:magator/utils/datepicker/date_picker.dart';
import 'package:magator/utils/themes/colors.dart';
import '../../utils/buttons/dropdown.dart';
import '../../utils/textbox/dialog_text_box.dart';
import 'utility.dart';

class AddNewSubSection extends StatefulWidget {
  final void Function(Map<String, dynamic> data) onSubmit;
  final List<String> sections;
  const AddNewSubSection({super.key, required this.sections, required this.onSubmit});

  @override
  State<AddNewSubSection> createState() => _AddNewSubSectionState();
}

class _AddNewSubSectionState extends State<AddNewSubSection> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  dynamic valueOfPriority;
  dynamic valueOfColor;
  dynamic valueOfSection;
  DateTime? startDate;
  DateTime? deadline;

  String startDateHint = "Start Date";
  String deadlineHint = "Deadline";
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 3,
      backgroundColor: const Color.fromARGB(255, 57, 56, 56),
      icon: const Icon(Icons.add_card_rounded, color: primaryColor),
      title: const Text("Add New Card"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: textBox("Title", MediaQuery.of(context).size.width-70, titleController)
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: textBox("Description", MediaQuery.of(context).size.width-70, descriptionController)
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: textBox("Status", MediaQuery.of(context).size.width/2-69 , statusController)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomDropDown(
                      "Section",
                      sectionDropDown(widget.sections),
                      value: valueOfSection,
                      width: MediaQuery.of(context).size.width/2-69,
                      onChange: (value) {
                        setState(() {
                          valueOfSection = value;
                        });
                        print("Value: $value");
                      }
                    )
                  )
                ]
              ),  
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomDropDown(
                      "Preority",
                      preorityDropDown(),
                      value: valueOfPriority,
                      width: MediaQuery.of(context).size.width/2-69,
                      onChange: (value) {
                        setState(() {
                          valueOfPriority = value;
                        });
                        print("Value: $value");
                      }
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomDropDown(
                      "Color",
                      colorsDropDown(), 
                      width: MediaQuery.of(context).size.width/2-69,
                      value: valueOfColor,
                      onChange: (value) {
                        setState(() {
                          valueOfColor = value;
                        });
                        print("Value: $value");
                        
                      }
                    )
                  )
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomDatePicker(
                      hint: "Start Date",
                      width: MediaQuery.of(context).size.width/2-69,
                      onTap: (date) {
                        setState(() {
                          startDate = date;
                        });
                      }
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomDatePicker(
                      hint: "Deadline",
                      width: MediaQuery.of(context).size.width/2-69,
                      onTap: (date) {
                        setState(() {
                          deadline = date;
                        });
                      }
                    )
                  )
                ]
              ),
            ),
            CustomSubmitButton(
              hint: "Add", 
              width: MediaQuery.of(context).size.width-69, 
              onTap: () {
                Map<String, dynamic> data = {
                  "title": titleController.text,
                  "description": descriptionController.text,
                  "status": statusController.text,
                  "section": valueOfSection,
                  "priority": valueOfPriority,
                  "color": valueOfColor,
                  "startingDate": startDate,
                  "deadline": deadline
                };
                Navigator.pop(context);
                widget.onSubmit(data);
              },
              validator: () {
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && statusController.text.isNotEmpty) {
                  if (valueOfPriority != null && valueOfColor != null && valueOfSection != null) {
                    if (startDate != null) {
                      return true;
                    }
                  }
                }
                return false;
              }
            )
          ]
        ),
      )
    );
  }
}


