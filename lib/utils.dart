//Utils Functions Lib
import 'package:flutter/material.dart';

//Mask Emails 
String maskEmail(String email) {
  List<String> parts = email.split('@');
  if (parts.length != 2) return email;

  String localPart = parts[0];
  String domainPart = parts[1];
  if (localPart.length <= 7) return email;

  String visiblePart = localPart.substring(0, 7);
  String obscuredPart = '*' * (localPart.length - 7);
  return '$visiblePart$obscuredPart@$domainPart';
}

//Return Relative Time
String formatRelativeTime(int unixTimestampInSeconds) {
  final DateTime pastTime = DateTime.fromMillisecondsSinceEpoch(unixTimestampInSeconds * 1000);
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(pastTime);

  if (difference.isNegative || difference.inSeconds < 5) {
    return "เมื่อสักครู่"; // Just now / moments ago
  }

  if (difference.inSeconds < 60) {
    return "เมื่อ ${difference.inSeconds} วินาทีที่แล้ว"; // Seconds ago
  } else if (difference.inMinutes < 60) {
    return "เมื่อ ${difference.inMinutes} นาทีที่แล้ว"; // Minutes ago
  } else if (difference.inHours < 24) {
    return "เมื่อ ${difference.inHours} ชั่วโมงที่แล้ว"; // Hours ago
  } else if (difference.inDays < 30) {
    return "เมื่อ ${difference.inDays} วันที่แล้ว"; // Days ago
  } else if (difference.inDays < 365) {
    final int months = (difference.inDays / 30).floor();
    return "เมื่อ $months เดือนที่แล้ว"; // Months ago
  } else {
    final int years = (difference.inDays / 365).floor();
    return "เมื่อ $years ปีที่แล้ว"; // Years ago
  }
}

//Format Time
String formatUnixTimestamp(int unixTimeInSeconds, bool alwaysShowTime) {
  // Convert Unix timestamp to DateTime (expects milliseconds)
  final date = DateTime.fromMillisecondsSinceEpoch(unixTimeInSeconds * 1000);
  final now = DateTime.now();

  // Create DateTime objects normalized to midnight (00:00:00) for accurate date comparison
  final todayMidnight = DateTime(now.year, now.month, now.day);
  final yesterdayMidnight = todayMidnight.subtract(const Duration(days: 1));
  final targetMidnight = DateTime(date.year, date.month, date.day);

  // Format hours and minutes to always be two digits (e.g., 05:09)
  final String hh = date.hour.toString().padLeft(2, '0');
  final String mm = date.minute.toString().padLeft(2, '0');

  final List<String> monthTH = ["ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."];

  if (targetMidnight == todayMidnight) {
    return 'วันนี้ $hh:$mm';
  } else if (targetMidnight == yesterdayMidnight) {
    return 'เมื่อวาน $hh:$mm';
  } else {
    // Format as dd/mm/yyyy
    final String day = date.day.toString().padLeft(2, '0');
    final int month = date.month;
    final String year = (date.year + 543).toString();
    if (alwaysShowTime) {
      return '$day ${monthTH[month - 1]} $year $hh:$mm';
    } else {
      return '$day ${monthTH[month - 1]} $year';
    }
  }
}

List<Color> colorList(int index) {
  List<List<Color>> list = [
    [Color(0xff22c55e), Color(0xff22c55e)],
    [Color(0xffeab308), Color(0xff713f12)],
    [const Color(0xfff97316), const Color.fromARGB(255, 165, 75, 11)],
    [const Color(0xffef4444), const Color(0xffb91c1c)],
  ];

  return list[index];
}

List<Color> barColor(double percentage, String mode) {
  int level;
  if (percentage > 0.75) {
    level = 3;
  } else if (percentage > 0.50) {
    level = 2;
  } else if (percentage > 0.25) {
    level = 1;
  } else {
    level = 0;
  }

  return mode == 'ai' ? colorList(level) : colorList(3 - level);
}

String dangerStatus(double percentage) {
  if (percentage > 0.85) {
    return "สูงมาก";
  } else if (percentage > 0.75) {
    return "สูง";
  } else if (percentage > 0.60) {
    return "ค่อนข้างสูง";
  } else if (percentage > 0.40) {
    return "ปานกลาง";
  } else if (percentage > 0.25) {
    return "ค่อนข้างต่ำ";
  } else if (percentage > 0.10) {
    return "ต่ำ";
  } else {
    return "ต่ำมาก";
  }
}