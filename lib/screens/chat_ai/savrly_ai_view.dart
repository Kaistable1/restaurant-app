import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaistable_website/screens/chat_ai/savrly_ai_controller.dart';

class SavrlyAIView extends StatelessWidget {
  SavrlyAIView({super.key});
  final controller = Get.put(SavrlyAIController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SAVRLY AI'),
        leading: const Icon(Icons.sort, color: Colors.black),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Obx(
              () => controller.messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Hello! How can I assist you today?',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];
                        return _buildMessageBubble(message);
                      },
                    ),
            ),
          ),

          // Loading indicator
          Obx(
            () => controller.isLoading.value
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      child:
                          const TypingBullet().paddingSymmetric(horizontal: 8),
                    ).paddingSymmetric(vertical: 8, horizontal: 16),
                  )
                : const SizedBox.shrink(),
          ),

          // Suggestion chips
          Obx(
            () => controller.messages.isEmpty
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => controller.sendSuggestion(
                              'Design a database schema for an online merch store'),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Design a database schema',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                Text(
                                  'for an online merch store',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF3C3C3C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        InkWell(
                          onTap: () => controller.sendSuggestion(
                              'Explain airplain to someone 5 years old'),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Explain airplain',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                Text(
                                  'to someone 5 years old',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF3C3C3C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Message input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xFFE5E5E1)),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xFFE5E5E1)),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xFFE5E5E1)),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (value) {
                        controller.sendMessage(value);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black, shape: BoxShape.circle),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      controller.sendMessage(controller.messageController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: Get.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class TypingBullet extends StatefulWidget {
  const TypingBullet({super.key});

  @override
  State<TypingBullet> createState() => _TypingBulletState();
}

class _TypingBulletState extends State<TypingBullet>
    with SingleTickerProviderStateMixin {
  RxString animatedText = ''.obs;
  final String bullet = '\u2022';
  late Timer _timer;
  int index = 0;

  @override
  void initState() {
    super.initState();

    // Repeat the bullet like typing animation
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!mounted) return;

      if (index >= 3) {
        index = 0;
        animatedText.value = '';
      } else {
        animatedText.value += bullet;
        index++;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
          animatedText.value,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ));
  }
}
