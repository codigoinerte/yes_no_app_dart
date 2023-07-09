import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/get_yes_no_answer.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final getYesOrNoAnswer = GetYesNoAnswer();

  List<Message> messageList = [
  ];

  ChatProvider(){

    cargarMensajes()
    .then((storageMessages){

      messageList = [...storageMessages];
      notifyListeners();
      moveScrollToBottom();  
    });
    
  }
    // Message(text: 'holaaaa', fromWho: FromWho.me),
    // Message(text: 'Que paso!?', fromWho: FromWho.hers),

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    final newMessage = Message(text: text, fromWho: FromWho.me);

    messageList.add(newMessage);

      herReply(newMessage.text);
    // if (text.endsWith('?')) {
    // }

    notifyListeners();

    moveScrollToBottom();
  }

  Future<void> herReply(String message) async {
    final herMessage = await getYesOrNoAnswer.getAnswer(message, messageList);
    messageList.add(herMessage);
    
    guardarMensajes(messageList);

    notifyListeners();

    moveScrollToBottom();
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));

    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  Future<void> guardarMensajes(List<Message> mensajes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Convierte la lista de mensajes a una lista de mapas
    List<Map<String, dynamic>> mensajesMap = mensajes.map((mensaje) {
      return {
        'text': mensaje.text,
        'opcional': mensaje.opcional,
        'fromWho': mensaje.fromWho.toString(),
      };
    }).toList();

    // Convierte la lista de mapas a una cadena de texto JSON
    String mensajesJson = json.encode(mensajesMap);

    // Guarda la cadena de texto JSON en shared_preferences
    await prefs.setString('mensajesKey', mensajesJson);
  }

    Future<List<Message>> cargarMensajes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obtiene la cadena de texto JSON de shared_preferences
    String? mensajesJson = prefs.getString('mensajesKey');

    if (mensajesJson != null) 
    {
      // Convierte la cadena de texto JSON a una lista de mapas
      List<Map<String, dynamic>> mensajesMap = List<Map<String, dynamic>>.from(json.decode(mensajesJson));

      // Convierte la lista de mapas a una lista de mensajes
      List<Message> mensajes = mensajesMap.map((mensajeMap) {
        return Message(
          text: mensajeMap['text'],
          opcional: mensajeMap['opcional'],
          fromWho: mensajeMap['fromWho'] == 'FromWho.me' ? FromWho.me : FromWho.hers,
        );
      }).toList();

      return mensajes;
    }

    return [];
  }

  Future<void > loadMessages() async {
    final storageMessages = await cargarMensajes();
    messageList = [...storageMessages];
  }

  void clearMessages (){
    messageList.clear();

    notifyListeners();

    moveScrollToBottom();
  }
}
