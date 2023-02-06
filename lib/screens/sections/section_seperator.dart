import 'package:flutter/material.dart';
import '../../broker/broker.dart';

class SectionSeperator extends StatefulWidget {
  final String name;
  const SectionSeperator(this.name, {super.key, });

  @override
  State<SectionSeperator> createState() => _SectionSeperatorState();
}

class _SectionSeperatorState extends State<SectionSeperator> {

  bool isClose = true;
  late Broker broker;

  @override
  void initState() {
    super.initState();
    broker = getBroker();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
      child: Row(
        children: [
          Visibility(
            visible: isClose,
            replacement: IconButton(
              color: Colors.white,
              splashRadius: 20,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              onPressed: () {
                broker.publish("${widget.name}_seperator", widget.name, true);
                setState(() {
                  isClose = true;
                });
              },
            ),
            child: IconButton(
              color: Colors.white,
              splashRadius: 20,
              icon: const Icon(Icons.keyboard_arrow_right_rounded),
              onPressed: () {
                broker.publish("${widget.name}_seperator", widget.name, false);
                setState(() {
                  isClose = false;
                });
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 1,
                      decoration  : const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white
                    )
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 1,
                      decoration  : const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          )
        ]
      ),
    );
  }
}