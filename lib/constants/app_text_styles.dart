import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
 
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  
 
  static const TextStyle tabSelected = TextStyle(
    color: AppColors.textWhite,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle tabUnselected = TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.normal,
  );
  

  static const TextStyle userName = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
  
  static TextStyle userStatus = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
  );
  
 
  static const TextStyle chatHistoryName = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
  
  static TextStyle chatHistoryMessage = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );
  
  static TextStyle chatHistoryTime = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 12,
  );
  

  static const TextStyle messageTextSender = TextStyle(
    color: AppColors.textWhite,
    fontSize: 15,
  );
  
  static const TextStyle messageTextReceiver = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
  );
  
  static TextStyle messageTime = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 11,
  );
  

  static const TextStyle avatarText = TextStyle(
    color: AppColors.textWhite,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle avatarTextSmall = TextStyle(
    color: AppColors.textWhite,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle avatarTextMedium = TextStyle(
    color: AppColors.textWhite,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  
 
  static const TextStyle chatHeaderName = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle chatHeaderStatus = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
  );
  

  static TextStyle inputHint = TextStyle(
    color: AppColors.textTertiary,
  );
  

  static const TextStyle emptyState = TextStyle(
    color: AppColors.textSecondary,
  );
  

  static const TextStyle badgeText = TextStyle(
    color: AppColors.textWhite,
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );
}

