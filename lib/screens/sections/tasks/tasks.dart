import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:magator/utils/themes/colors.dart';
import '../../../db/config.dart';
import '../../../db/models.dart' as models;
import '../../../broker/broker.dart';
import '../../popups/add_tasks.dart';
import 'task.dart';

class MyTasks extends StatefulWidget {
  final String title;
  final int colorIndex;
  const MyTasks({super.key, required this.title, required this.colorIndex});

  @override
  State<MyTasks> createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {

  late models.Tasks taskNames;
  late DataBase db;
  late Broker broker;

  bool isKeyNotesVisible = false;
  bool isMoreVisible = false;
  bool isReorderEnabled = false;

  uiEventListner() {
    broker.listen(widget.title, (event) {
      Protocol protocol = (event as Protocol);
      if (protocol.publisher == "delete_task") {
        taskNames.tasks.removeAt(protocol.data);
        String saveTasks = taskNames.toString();
        db.set("todos", "${widget.title}_tasks", saveTasks);
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    taskNames = models.Tasks();
    db = GetIt.I.get<DataBase>(instanceName: "db");
    String? savedTask = db.get("todos", "${widget.title}_tasks");
    if (savedTask != null) {
      taskNames.toObject(savedTask);
    }

    broker = getBroker();
    broker.register(widget.title);
    broker.registerBroadCaster("${widget.title}_reorder");
    uiEventListner();
  }

  @override
  void dispose() {
    super.dispose();
    broker.delete(widget.title);
    broker.delete("${widget.title}_reorder");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: cardColors[widget.colorIndex],
        actions: [
          Visibility(
            visible: !isReorderEnabled,
            child: IconButton(
              icon: const Icon(Icons.add_task_rounded),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddNewTask(
                    parentSubSection: widget.title,
                    onSubmit: (task) {
                      
                      String jsonEncodedTask = task.toString();
                      db.set("todos", "${task.title}_t", jsonEncodedTask);
                      
                      taskNames.tasks.add("${task.title}_t");
                      String jsonEncodedTasks = taskNames.toString();
                      db.set("todos", "${widget.title}_tasks", jsonEncodedTasks);
                      setState(() {});
                    },
                  )
                );
              },
            ),
          ),
          Visibility(
            visible: !isReorderEnabled,
            child: IconButton(
              icon: const Icon(Icons.notes_rounded),
              onPressed: () {
                if (isKeyNotesVisible) {
                  setState(() {isKeyNotesVisible = false;});
                } else {
                  setState(() {
                    isMoreVisible = false;
                    isKeyNotesVisible = true;
                  });
                }
              },
            ),
          ),
          Visibility(
            visible: !isReorderEnabled,
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                if (isMoreVisible) {
                  setState(() {isMoreVisible = false;});
                } else {
                  setState(() {
                    isKeyNotesVisible = false;
                    isMoreVisible = true;
                  });
                }
              },
            ),
          ),
          Visibility(
            visible: isReorderEnabled,
            child: IconButton(
              icon: Icon(Icons.done_rounded),
              onPressed: () {
                broker.publish(widget.title, "${widget.title}_reorder", "disable");
                setState(() {
                  isReorderEnabled = false;
                });
              },
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                alignment: Alignment.center,
                child: ReorderableListView.builder(
                  itemCount: taskNames.tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MyTask(
                      index,
                      parent: widget.title,
                      key: ValueKey(taskNames.tasks[index]),
                      taskName: taskNames.tasks[index]);
                  },
                  onReorder: (oldIndex, newIndex) {
                    newIndex = (newIndex>oldIndex) ? newIndex-1 : newIndex;
                    String temp = taskNames.tasks[newIndex];
                    taskNames.tasks[newIndex] = taskNames.tasks[oldIndex];
                    taskNames.tasks[oldIndex] = temp;
                    String saving = taskNames.toString();
                    db.set("todos", "${widget.title}_tasks", saving);
                  },
                )
              ),
            ),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
            Visibility(
              visible: isKeyNotesVisible,
              child: Positioned(
                right: 5,
                top: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width/1.5,
                  height: MediaQuery.of(context).size.height/1.4,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 61, 60, 60),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const Flexible(
                                flex: 9,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("KEY NOTES",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:18,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600
                                    )
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {},
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(color: Colors.white),
                      )
                    ]
                  )
                )
              ),
              
            ),
            Visibility(
              visible: isMoreVisible,
              child: Positioned(
                right: 5,
                top: 5,
                child: Container(
                  width: MediaQuery.of(context).size.width/3.3,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 61, 60, 60),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        horizontalTitleGap: 5,
                        leading: const Icon(Icons.reorder_rounded, color: Colors.white),
                        title: const Text("Reorder",
                          style: TextStyle(
                            color: Colors.white
                          )
                        ),
                        dense: true,
                        onTap: () {
                          broker.publish(widget.title, "${widget.title}_reorder", "enabled");
                          setState(() {
                            isReorderEnabled = true;
                            isMoreVisible = false;
                          });
                        },
                      ),
                      const ListTile(
                        horizontalTitleGap: 5,
                        leading: Icon(Icons.delete, color: Colors.white),
                        title: Text("Delete",
                          style: TextStyle(
                            color: Colors.white
                          )
                        ),
                        dense: true
                      )
                    ]
                  )
                )
              ),
            )
          ]
        )
      ),
    );
  }
}