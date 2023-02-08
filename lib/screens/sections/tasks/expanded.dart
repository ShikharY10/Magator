import 'package:flutter/material.dart';

class TaskExpander extends StatefulWidget {
  final bool isVisible;
  const TaskExpander({super.key, required this.isVisible});

  @override
  State<TaskExpander> createState() => _TaskExpanderState();
}

class _TaskExpanderState extends State<TaskExpander> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0),
      child: Visibility(
        visible: widget.isVisible,
        child: Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 56, 57, 61),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)
            )
          ),
          child: Center(child: Text("Expanded Mode"))
        ),
      ),
    );
  }
}