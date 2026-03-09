import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../data/chat_dummy_data.dart';
import '../../data/models/chat_message_model.dart';
import '../constants/chat_texts.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = List.from(initialMessages);

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: true, time: DateTime.now()),
      );
      _messageController.clear();
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: ChatTexts.autoReply,
              isUser: false,
              time: DateTime.now(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: AppColors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? AppStringsAr.supportAgent
                      : AppStringsEn.supportAgent,
                  style: AppTextStyles.label(
                    isArabic: isArabic,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  isArabic ? AppStringsAr.online : AppStringsEn.online,
                  style: AppTextStyles.caption(
                    isArabic: isArabic,
                    color: AppColors.secondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  message: _messages[index],
                  isArabic: isArabic,
                );
              },
            ),
          ),
          ChatInputBar(
            controller: _messageController,
            isArabic: isArabic,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
