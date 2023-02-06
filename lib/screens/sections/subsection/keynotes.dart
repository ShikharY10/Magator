import 'package:flutter/material.dart';

class KeyNotes extends StatefulWidget {
  final bool isVisible;
  const KeyNotes({super.key, required this.isVisible});

  @override
  State<KeyNotes> createState() => _KeyNotesState();
}

class _KeyNotesState extends State<KeyNotes> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
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
      
    );
  }
}