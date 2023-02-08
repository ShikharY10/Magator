import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import '../../../db/config.dart';
import '../../../db/models.dart';

class KeyNotes extends StatefulWidget {
  final bool isVisible;
  final String parent;
  const KeyNotes({super.key, required this.isVisible, required this.parent});

  @override
  State<KeyNotes> createState() => _KeyNotesState();
}

class _KeyNotesState extends State<KeyNotes> {

  TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  KeyNotesModel keynotes = KeyNotesModel();
  Map<int, bool> deleteRegistry = {};
  bool showDeleteOptions = false;
  late DataBase db;

  @override
  void initState() {
    super.initState();
    db = GetIt.I.get<DataBase>(instanceName: "db");
    String? savedKN = db.get("settings", "${widget.parent}_kn");
    if (savedKN != null) {
      keynotes.toObject(savedKN);
    }

    for (int i=0; i<keynotes.keynotes.length; i++) {
      deleteRegistry[i] = false;
    }
  }

  @override
  void dispose() {
    for (int i=0; i<deleteRegistry.length; i++) {
      deleteRegistry[i] = false;
    }
    setState(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Positioned(
        right: 5,
        top: 5,
        child: Container(
          width: MediaQuery.of(context).size.width/1.5,
          height: MediaQuery.of(context).size.height/2.3,
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
                padding: const EdgeInsets.only(top: 3.0),
                child: Container(
                  alignment: Alignment.center,
                  child: showDeleteOptions ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        color: Colors.red,
                        icon: const Icon(Icons.delete),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          int deleteCount = 0;
                          deleteRegistry.forEach((key, value) {
                            if (value) {
                              keynotes.keynotes.removeAt(key-deleteCount);
                              deleteCount++;
                            }
                          });
                          String saveKeyNotes = keynotes.toString();
                          db.set("settings", "${widget.parent}_kn", saveKeyNotes);
                          for (int i=0; i<deleteRegistry.length; i++) {
                            deleteRegistry[i] = false;
                          }
                          setState(() {
                            showDeleteOptions = false;
                          });
                        }
                      ),
                      IconButton(
                        color: Colors.green,
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          for (int i=0; i<deleteRegistry.length; i++) {
                            deleteRegistry[i] = false;
                          }
                          setState(() {
                            showDeleteOptions = false;
                          });
                        }
                      )
                    ],
                  ) : const Text("KEY NOTES",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500
                    )
                  )
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.white),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: keynotes.keynotes.length,
                  dragStartBehavior: DragStartBehavior.down,
                  itemBuilder: (context, index) {
                    return Notes(
                      index: index,
                      parent: "${widget.parent}_kn",
                      notes: keynotes.keynotes[index],
                      isDeleteEnabled: showDeleteOptions,
                      isSelected: deleteRegistry[index]!,
                      onTap: (noteIndex) {
                        if (showDeleteOptions) {
                          if (deleteRegistry[index]!) {
                            setState(() {deleteRegistry[index] = false;});
                          } else {
                            setState(() {deleteRegistry[index] = true;});
                          }
                        }
                      },                      
                      onLongPress: (index) {
                        if (!showDeleteOptions) {
                          setState(() {
                            showDeleteOptions = true;  
                          });
                        }
                      },
                    );
                  }
                ),
              ),
              Container(
                constraints: const BoxConstraints(
                  minHeight: 40,
                  maxHeight: 100,
                ),
                child: TextFormField(
                  autofocus: false,
                  controller: controller,
                  maxLines: 6,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 33, 34, 34),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  hintText: "key notes",
                  hintStyle: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 136, 108, 55)),
                  suffixIcon: Container(
                    width: 40,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          if (controller.text.isNotEmpty) {
                            String keyNote = controller.text;
                            int index = keynotes.keynotes.length;
                            keynotes.keynotes.add(keyNote);
                            db.set("settings", "${widget.parent}_kn", keynotes.toString());
                            deleteRegistry[index] = false;
                            
                            await Future.delayed(const Duration(milliseconds: 100));
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 4),
                                curve: Curves.fastOutSlowIn
                              );
                            });

                            setState(() {
                              controller.clear();
                            });
                          }
                        },
                      )
                    ),
                  ),
                  
                ),
                )
              )
            ]
          )
        )
      ),
      
    );
  }
}

class Notes extends StatelessWidget {
  final int index;
  final String parent;
  final String notes;
  final bool isDeleteEnabled;
  final bool isSelected;
  final void Function(int) onTap;
  final void Function(int) onLongPress;
  const Notes({
    super.key, 
    required this.index, 
    required this.parent, 
    required this.notes, 
    required this.isDeleteEnabled, 
    required this.isSelected, 
    required this.onTap, 
    required this.onLongPress
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(index);
      },
      onLongPress: () {
        onLongPress(index);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: isDeleteEnabled ? Border.all(
                  color: Colors.white,
                ) : null
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  notes,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

