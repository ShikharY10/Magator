import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:magator/screens/popups/utility.dart';
import 'package:magator/utils/buttons/submit.dart';
import '../../broker/broker.dart';
import '../../db/config.dart';
import '../../db/models.dart' as models;
import '../../utils/buttons/dropdown.dart';
import '../../utils/datepicker/date_picker.dart';
import '../../utils/textbox/dialog_text_box.dart';
import '../../utils/themes/colors.dart';

class EditTask extends StatefulWidget {
  final models.Task task;
  const EditTask({super.key, required this.task});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController descriptionController = TextEditingController();
  dynamic valueOfStatus;
  dynamic valueOfPriority;
  DateTime? deadline;

  models.Task updatedTask = models.Task();

  bool isEqual(models.Task savedTask, models.Task updatedTask) {
    if (savedTask.deadline == updatedTask.deadline) {
      if (savedTask.description == updatedTask.description) {
        if (savedTask.priority == updatedTask.priority) {
          if (savedTask.status == updatedTask.status) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void copyValue(models.Task to, models.Task from) {
    to.assigned = from.assigned;
    to.deadline = from.deadline;
    to.description = from.description;
    to.priority = from.priority;
    to.startDate = from.startDate;
    to.status = from.status;
    to.title = from.title;
  }

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.task.description ?? "";
    valueOfPriority = widget.task.priority;
    valueOfStatus = widget.task.status;
    deadline = widget.task.deadline;

    copyValue(updatedTask, widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 3,
      backgroundColor: const Color.fromARGB(255, 57, 56, 56),
      icon: const Icon(Icons.edit, color: primaryColor),
      title: Text("Edit Task: ${widget.task.title}"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: CustomTextBox("Description", MediaQuery.of(context).size.width-69, descriptionController, limit: 27)
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
                      "Status",
                      statusDropDown(),
                      value: valueOfStatus,
                      width: MediaQuery.of(context).size.width/2-69,
                      onChange: (value) {
                        setState(() {
                          valueOfStatus = value;
                          updatedTask.status = value;
                        });
                      }
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomDropDown(
                      "Priority",
                      preorityDropDown(), 
                      width: MediaQuery.of(context).size.width/2-69,
                      value: valueOfPriority,
                      onChange: (value) {
                        setState(() {
                          valueOfPriority = value;
                          updatedTask.priority = value;
                        });                        
                      }
                    )
                  )
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomDatePicker(
                      hint: "Deadline",
                      placeHolder: formateDate(widget.task.deadline!),
                      width: MediaQuery.of(context).size.width/2-69,
                      onTap: (date) {
                        setState(() {
                          deadline = date;
                          updatedTask.deadline = date;
                        });
                      }
                    )
                  )
                ]
              ),
            ),
            CustomSubmitButton(
              hint: "Edit", 
              width: MediaQuery.of(context).size.width-69, 
              onTap: () {
                DataBase db = GetIt.I.get<DataBase>(instanceName: "db");
                String saveTask = updatedTask.toString();
                db.set("todos", "${widget.task.title!}_t", saveTask);
                Broker broker = getBroker();
                broker.publish("taskEditService", "${widget.task.title!}_t", updatedTask);
                Navigator.pop(context);
              }, 
              validator: () {
                updatedTask.description = descriptionController.text;
                bool isTasksEqual = isEqual(widget.task, updatedTask);
                if (!isTasksEqual) {
                  return true;
                }
                return false;
              }
            )
          ]
        )
      )
    );
  }
}