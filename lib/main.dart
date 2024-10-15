import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: MaterialApp(
        home: ChatScreen(),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                return ListTile(
                  title: Align(
                    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message.isUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(message.message),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Escribe un mensaje...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _controller.text;
                    if (message.isNotEmpty) {
                      chatProvider.sendMessage(message);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
