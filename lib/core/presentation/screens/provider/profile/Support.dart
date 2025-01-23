import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      // Handle sending support message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Support message sent!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'If you have any issues or feedback, feel free to send us a message.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Send Message',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
