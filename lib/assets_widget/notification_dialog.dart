import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final IconData iconDialog;
  final Color colorIconDialog;
  final String titleDialog;

  const NotificationDialog({
    Key? key,
    required this.iconDialog,
    required this.colorIconDialog,
    required this.titleDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconDialog,
            color: colorIconDialog,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            titleDialog,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 8),
        ],
      ),
      // actions: [
      //   TextButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     child: const Text('OK'),
      //   ),
      // ],
    );
  }
}
