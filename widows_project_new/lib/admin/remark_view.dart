import 'package:flutter/material.dart';

class RemarkView extends StatelessWidget {
  const RemarkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Remark View")),
      body: const Center(
        child: Text(
          "This is the Remark View Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
