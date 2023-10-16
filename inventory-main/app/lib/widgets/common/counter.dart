import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final int value;
  final void Function(int nvalue) onChanged;
  const Counter({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (value > 0) {
              onChanged(value - 1);
            }
          },
        ),
        Text(
          '$value',
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onChanged(value + 1),
        ),
      ],
    );
  }
}
