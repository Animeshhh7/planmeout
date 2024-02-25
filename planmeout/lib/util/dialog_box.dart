import 'package:flutter/material.dart';
import 'package:planmeout/util/buttons.dart'; 

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // No curved edges
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), // Increased padding
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // Set width to 80% of the screen width
        height: MediaQuery.of(context).size.height * 0.3, // Set height to 30% of the screen height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min, // Ensure the dialog size fits its content
          children: [
            // get user input
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new plan",
              ),
            ),

            // buttons -> save + cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // save button
                Button(text: "Save", onPressed: onSave),
                const SizedBox(width: 8),

                // cancel button
                Button(text: "Cancel", onPressed: onCancel),
              ],
            )
          ],
        ),
      ),
    );
  }
}
