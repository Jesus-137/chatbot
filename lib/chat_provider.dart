import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat_message.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  // Historial para guardar los prompts enviados
  List<String> _promptsHistory = [];

  Future<void> sendMessage(String message) async {
    // Agrega el mensaje del usuario a la lista
    _messages.add(ChatMessage(message: message, isUser: true));
    notifyListeners();

    // Guardar el mensaje en el historial
    _promptsHistory.add(message);

    // Combinar el historial de prompts para enviar a la IA (si deseas mantener contexto)
    String combinedMessages = _promptsHistory.join(' ');

    // Enviar solicitud a la API de Gemini (reemplaza con tu propia URL y lógica)
    final response = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyAQ8hJOCIOMrJJpl8fqzgMGvceVcswGke4'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": combinedMessages}
            ]
          }
        ]
      }),
    );

    // Imprimir el cuerpo de la respuesta en la consola
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Accede a la respuesta de la IA
      String reply = data['candidates'][0]['content']['parts'][0]['text'];
      _promptsHistory.add(reply);

      // Agrega la respuesta de la IA a la lista de mensajes
      _messages.add(ChatMessage(message: reply, isUser: false));
      notifyListeners();
    } else {
      // Manejo de errores
      _messages.add(ChatMessage(
          message: 'Error: No se pudo obtener la respuesta', isUser: false));
      notifyListeners();
    }
  }

  // Método para reiniciar el historial si es necesario
  void resetHistory() {
    _promptsHistory.clear();
  }
}
