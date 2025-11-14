import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class SavrlyAIController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final Dio _dio = Dio();

  final String apiUrl = 'https://savrli-ai.vercel.app/ai/chat';

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> sendMessage(String prompt) async {
    if (prompt.trim().isEmpty) return;

    // Add user message to the chat
    messages.add(ChatMessage(
      text: prompt,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    // Clear input field
    messageController.clear();

    // Scroll to bottom
    _scrollToBottom();

    // Set loading state
    isLoading.value = true;

    try {
      // Make API call using Dio
      final response = await _dio.post(
        apiUrl,
        data: {
          'prompt': prompt,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Add AI response to the chat
        messages.add(ChatMessage(
          text: data['response'] ?? data.toString(),
          isUser: false,
          timestamp: DateTime.now(),
        ));
      } else {
        // Handle error
        messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }
    } catch (e) {
      // Handle network or parsing errors
      messages.add(ChatMessage(
        text:
            'Sorry, I couldn\'t connect to the server. Please check your internet connection.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  void sendSuggestion(String suggestion) {
    sendMessage(suggestion);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
