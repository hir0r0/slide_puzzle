import 'package:flutter/material.dart';

class PuzzleTile extends StatelessWidget {
  const PuzzleTile({Key? key, required this.number}) : super(key: key);

  final String number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
          color: number.isEmpty ? Colors.white : Colors.lightBlueAccent,
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}
