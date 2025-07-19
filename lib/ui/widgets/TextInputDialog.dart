import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  final Function(String) onSubmitted;
  final String value;

  const TextInputDialog(
      {required this.onSubmitted, required this.value, super.key});

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.value;

    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter text here',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmitted(_controller.text);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
