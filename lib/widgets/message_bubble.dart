import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final String userName;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            CircleAvatar(
              backgroundColor: AppColors.primaryPurple,
              radius: AppConstants.avatarRadius,
              child: Text(
                userName[0].toUpperCase(),
                style: AppTextStyles.avatarTextSmall,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: message.isSender
                        ? AppColors.messageBubbleSender
                        : AppColors.messageBubbleReceiver,
                    borderRadius: BorderRadius.circular(AppConstants.messageBorderRadius),
                  ),
                  child: Text(
                    message.text,
                    style: message.isSender
                        ? AppTextStyles.messageTextSender
                        : AppTextStyles.messageTextReceiver,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm a').format(message.timestamp),
                  style: AppTextStyles.messageTime,
                ),
              ],
            ),
          ),
          if (message.isSender) ...[
            const SizedBox(width: AppConstants.paddingSmall),
            CircleAvatar(
              backgroundColor: AppColors.primaryPurple,
              radius: AppConstants.avatarRadius,
              child: Text(
                'Y', 
                style: AppTextStyles.avatarTextSmall,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

