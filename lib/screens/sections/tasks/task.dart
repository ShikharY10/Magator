import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../db/config.dart';
import '../../../db/models.dart' as models;
import '../../../broker/broker.dart';
import '../../popups/edit_task.dart';
import '../../popups/utility.dart';

class MyTask extends StatefulWidget {
  final int index;
  final String parent;
  final String taskName;
  const MyTask(this.index, {required this.parent, required super.key, required this.taskName});

  @override
  State<MyTask> createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {

  late DataBase db;
  late Broker broker;
  models.Task task = models.Task();
  bool isExpanded = false;
  bool isStartReordering = false;
  bool showDeleteButton = false;

  listenToUiEvent() {
    broker.listenBroadCast("${widget.parent}_reorder", (event) {
      Protocol prototcol = (event as Protocol);
      if (event.publisher == widget.parent) {
        if (event.data == "enabled") {
          setState(() {
            isExpanded = false;
            isStartReordering = true;
          });
        } else if (event.data == "disable") {
          setState(() {
            isStartReordering = false;
          });
        }
      }
    });

    broker.listen(widget.taskName, (event) {
      if (event.publisher == "taskEditService") {
        if ((event.data as models.Task).title == task.title) {
          setState(() {
            task = (event.data as models.Task);
            showDeleteButton = false;
          });
        }
      }
    });

  }

  @override
  void initState() {
    super.initState();
    db = GetIt.I.get<DataBase>(instanceName: "db");
    broker = getBroker();
    broker.register(widget.taskName);

    String? savedTask = db.get("todos", widget.taskName);
    if (savedTask != null) {
      task.toObject(savedTask);
    }
    listenToUiEvent();
  }

  @override
  void dispose() {
    super.dispose();
    broker.delete(widget.taskName);
  }

  @override
  Widget build(BuildContext context) {
    print("taskName: ${widget.taskName}");
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, bottom: 5),
      child: ReorderableDragStartListener(
        enabled: isStartReordering,
        index: widget.index,
        child: Column(
          children: [
            Stack(
              children: [
                InkWell(
                  child: Container(
                    height: 105,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 37, 38, 40),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft: isExpanded ? const Radius.circular(0)  : const Radius.circular(15),
                        bottomRight: isExpanded ? const Radius.circular(0) : const Radius.circular(15)
                      ),
                      border: isStartReordering ? Border.all(color: Colors.white) : null
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(task.title!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                    )
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:8, vertical:2),
                                  child: Text(task.description!,
                                    style: const TextStyle(
                                      color: Colors.grey
                                    )
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    children: [
                                      Flexible(flex: 5,child: TaskDetailDisplay(
                                        name: "Status",
                                        value: statusDict[task.status]!,
                                      )),
                                      const SizedBox(width: 3),
                                      Flexible(flex: 5,child: TaskDetailDisplay(
                                        name: "Priority",
                                        value: preorityDict[task.priority]!
                                      )),
                                    ]
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(),
                                  child: Row(
                                    children: [
                                      Flexible(flex: 5,child: TaskDetailDisplay(
                                        name: "Started",
                                        value: formateDate(task.startDate!)
                                      )),
                                      const SizedBox(width: 3),
                                      Flexible(flex: 5,child: TaskDetailDisplay(
                                        name: "Deadline",
                                        value: formateDate(task.deadline!)
                                      )),
                                    ]
                                  ),
                                ),
                              ]
                            ),
                          )
                        ),
                      ]
                    )
                  ),
                  onTap: () {
                    print("ontap working");
                    if (showDeleteButton) {
                      setState(() {showDeleteButton = false;});
                    } else {
                      // if (!isStartReordering) {
                      //   if (isExpanded) {
                      //     setState(() {
                      //       isExpanded = false;
                      //     });
                      //   } else {
                      //     setState(() {
                      //       isExpanded = true;
                      //     });
                      //   }
                      // }
                    }
                    
                  },
                  onLongPress: () {
                    print("long press working, DELETE");
                    if (showDeleteButton) {
                      setState(() {showDeleteButton = false;});
                    } else {
                      setState(() {showDeleteButton = true;});
                    }
                  },
                ),
                Visibility(
                  visible: showDeleteButton,
                  child: Positioned(
                    right: 0.1,
                    top: 0.1,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50))
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              splashRadius: 25,
                              splashColor: Colors.black,
                              color: Colors.green,
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditTask(task: task)
                                );
                              },
                            ),
                            IconButton(
                              splashRadius: 25,
                              splashColor: Colors.black,
                              color: Colors.red,
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                broker.publish("delete_task", widget.parent, widget.index);
                              },
                            )
                          ]
                        )
                      ),
                    )
                  ),
                )
              ],
            ),
            // TODO: Implement expanded mode feature
          ],
        ),
      ),
    );
  }
}


class TaskDetailDisplay extends StatefulWidget {
  final String name;
  final String value;
  const TaskDetailDisplay({super.key, required this.name, required this.value});

  @override
  State<TaskDetailDisplay> createState() => _TaskDetailDisplayState();
}

class _TaskDetailDisplayState extends State<TaskDetailDisplay> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          border: Border.all(color: Colors.black) 
        ),
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50)
                  ),
                ),
                child: Text(widget.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12
                  )
                ),
              )
            ),
            Flexible(
              flex: 6,
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Text(widget.value,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    )
                  ),
                )
              ),
            )
          ]
        )
      )
    );
  }
}