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
        title: const Text('Ask Kai'),
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
                              'Where can I find a Date Night Restaurant'),
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
                                  'Where can I find a Date Night Restaurant',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                // Text(
                                //   'a Date Night Restaurant',
                                //   style: TextStyle(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w400,
                                //     color: Color(0xFF3C3C3C),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        InkWell(
                          onTap: () => controller
                              .sendSuggestion('Where is the closest Bar'),
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
                                  ' Where is the closest Bar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                // Text(
                                //   'to someone 5 years old',
                                //   style: TextStyle(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w400,
                                //     color: Color(0xFF3C3C3C),
                                //   ),
                                // ),
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
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Icon(Icons.add),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(
                        width: 1,
                        color: Color(0xFFE5E5E1),
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.messageController,
                            decoration: InputDecoration(
                              hintText: 'Message',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (value) {
                              controller.sendMessage(value);
                            },
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 32,
                          child: Image.asset('assets/images/microphone.png',
                              width: 14, height: 14),
                        ),
                        SizedBox(width: 4),
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Image.asset('assets/images/send-chat.png',
                                color: Colors.white, width: 16, height: 16),
                            onPressed: () {
                              controller.sendMessage(
                                  controller.messageController.text);
                            },
                          ),
                        ),
                      ],
                    ),
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
