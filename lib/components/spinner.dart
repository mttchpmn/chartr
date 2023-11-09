import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text("Loading...")),
      ],
    );
  }
}
