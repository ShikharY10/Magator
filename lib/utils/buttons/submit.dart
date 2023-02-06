
import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  final String hint;
  final double width;
  final void Function() onTap;
  final bool Function() validator;
  const CustomSubmitButton({super.key, required this.hint, required this.width, required this.onTap, required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only( top: 10.0),
          child: InkWell(
            child: Container(
              width: 300,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(                
                color: const Color.fromARGB(255, 49, 212, 150),
                borderRadius: BorderRadius.circular(50)
              ),
              child: Text(hint,
                style: const TextStyle(
                  color: Color.fromARGB(255, 28, 29, 77),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
            onTap: () async {
              if (validator()) {
                onTap();
              }
            }
          ),
        );
  }
}