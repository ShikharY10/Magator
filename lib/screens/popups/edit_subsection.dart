import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../db/config.dart';
import '../../db/models.dart' as models;
import '../../broker/broker.dart';
import '../../utils/buttons/dropdown.dart';
import '../../utils/buttons/submit.dart';
import '../../utils/datepicker/date_picker.dart';
import '../../utils/textbox/dialog_text_box.dart';
import '../../utils/themes/colors.dart';
import 'utility.dart';

class EditSubSection extends StatefulWidget {
  final models.Card card;
  const EditSubSection({super.key, required this.card});

  @override
  State<EditSubSection> createState() => _EditSubSectionState();
}

class _EditSubSectionState extends State<EditSubSection> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  dynamic valueOfPriority;
  dynamic valueOfColor;
  DateTime? deadline;

  bool isAnyValueChanged = false;
  models.Card updatedCard = models.Card();

  String formateDate(DateTime date) {
    String initial = date.toString().split(" ")[0];
    List<String> splited = initial.split("-");
    String newDate = splited[2] + "/" + splited[1] + "/" + splited[0];
    return newDate;
  }

  bool isEqual(models.Card cardOne, models.Card cardTwo) {
    if (cardOne.colorIndex == cardTwo.colorIndex) {
      if (cardOne.deadline == cardTwo.deadline) {
        if (cardOne.description == cardTwo.description) {
          if (cardOne.priority == cardTwo.priority) {
            if (cardOne.status == cardTwo.status) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  void copyValue(models.Card to, models.Card from) {
    to.colorIndex = from.colorIndex;
    to.deadline = from.deadline;
    to.description = from.description;
    to.parent = from.parent;
    to.priority = from.priority;
    to.startingDate = from.startingDate;
    to.status = from.status;
    to.title = from.title;
  }

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.card.description!;
    statusController.text = widget.card.status!;
    valueOfPriority = widget.card.priority!;
    valueOfColor = widget.card.colorIndex!;
    deadline = widget.card.deadline!;

    copyValue(updatedCard, widget.card);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 3,
      backgroundColor: const Color.fromARGB(255, 57, 56, 56),
      icon: const Icon(Icons.edit, color: primaryColor),
      title: Text("Edit Card: ${widget.card.title}"),
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
                      "Preority",
                      preorityDropDown(),
                      value: valueOfPriority,
                      width: MediaQuery.of(context).size.width/2-69,
                      onChange: (value) {
                        setState(() {
                          valueOfPriority = value;
                          updatedCard.priority = value;
                        });
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
                          updatedCard.colorIndex = value;
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
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: textBox("Status", MediaQuery.of(context).size.width/2-69 , statusController)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomDatePicker(
                      hint: "Deadline",
                      placeHolder: formateDate(widget.card.deadline!),
                      width: MediaQuery.of(context).size.width/2-69,
                      onTap: (date) {
                        setState(() {
                          deadline = date;
                          updatedCard.deadline = date;
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
                String jsonEncoded = updatedCard.toString();
                db.set("todos", "${updatedCard.title}_c", jsonEncoded);
                Broker broker = getBroker();
                broker.publish("editService", widget.card.title!, updatedCard);
                // broker.publish("editService", widget.card.parent!, widget.card.title!);
                Navigator.pop(context);
              },
              validator: () {
                updatedCard.description = descriptionController.text;
                updatedCard.status = statusController.text;
                bool equal = isEqual(widget.card, updatedCard);
                if (!equal) {
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