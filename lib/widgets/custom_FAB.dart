import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({
    Key? key,
    required this.iconAddress,
    required this.func,
  }) : super(key: key);

  final String iconAddress;
  final void Function() func;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        // decoration: BoxDecoration(color: Colors.white),
        width: 50,
        height: 50,
        child: RawMaterialButton(
          fillColor: Colors.white,
          shape: const CircleBorder(), onPressed: func,
          //  elevation: 0.0,
          child: Image.asset(
            iconAddress,
            color: Colors.black,
            width: 24,
          ),
        ),
      ),
    );
  }
}
