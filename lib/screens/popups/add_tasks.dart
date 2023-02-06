import 'package:flutter/material.dart';
import 'package:magator/utils/textbox/dialog_text_box.dart';
import 'package:magator/utils/themes/colors.dart';
import '../../db/models.dart' as models;
import '../../utils/buttons/dropdown.dart';
import '../../utils/buttons/submit.dart';
import '../../utils/datepicker/date_picker.dart';
import 'utility.dart';

class AddNewTask extends StatefulWidget {
  final String parentSubSection;
  final void Function(models.Task data) onSubmit;
  const AddNewTask({super.key, required this.parentSubSection, required this.onSubmit});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  dynamic valueOfColor;
  dynamic valueOfStatus;
  dynamic valueOfPriority;
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
      icon: const Icon(Icons.add_task_rounded, color: primaryColor),
      title: const Text("Add New Task"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: CustomTextBox("Title", MediaQuery.of(context).size.width-70, titleController)
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: CustomTextBox("Description", MediaQuery.of(context).size.width-70, descriptionController)
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
                      "Status",
                      statusDropDown(),
                      value: valueOfStatus,
                      width: MediaQuery.of(context).size.width/2-69,
                      onChange: (value) {
                        setState(() {
                          valueOfStatus = value;
                        });
                        print("Value: $value");
                      }
                    )
                  ),
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
                models.Task task = models.Task();
                task.assigned = "";
                task.deadline = deadline;
                task.description = descriptionController.text;
                task.priority = valueOfPriority;
                task.startDate = startDate;
                task.status = valueOfStatus;
                task.title = titleController.text;

                widget.onSubmit(task);
                Navigator.pop(context);
              },
              validator: () {
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  if (valueOfPriority != null && valueOfStatus != null) {
                    if (startDate != null) {
                      return true;
                    }
                  }
                }
                return false;
              }
            ) //Submit Buttom
          ]
        )
      ),
    );
  }
}