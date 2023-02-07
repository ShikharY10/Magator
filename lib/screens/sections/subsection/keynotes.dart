import 'package:flutter/material.dart';
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
  KeyNotesModel keynotes = KeyNotesModel();
  late DataBase db;

  @override
  void initState() {
    super.initState();
    db = GetIt.I.get<DataBase>(instanceName: "db");
    String? savedKN = db.get("settings", "${widget.parent}_kn");
    if (savedKN != null) {
      keynotes.toObject(savedKN);
    }
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
          height: MediaQuery.of(context).size.height/2,
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
                  child: const Text("KEY NOTES",
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
                  itemCount: keynotes.keynotes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      subtitle: Text(
                        keynotes.keynotes[index],
                        style: const TextStyle(
                          color: Colors.white
                        )
                      ),
                    );
                  }
                ),
              ),
              Container(
                constraints: const BoxConstraints(
                  minHeight: 40,
                  maxHeight: 120,
                ),
                child: TextFormField(
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
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            String keyNote = controller.text;
                            keynotes.keynotes.add(keyNote);
                            db.set("settings", "${widget.parent}_kn", keynotes.toString());
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