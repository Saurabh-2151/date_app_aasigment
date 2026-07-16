import 'package:flutter/material.dart';

// ─── Notification type ─────────────────────────────────────────────────────

enum AppNotificationType {
  rose,
  compliment,
  match,
  message,
  dateApproved,
  gift,
  like,
  generic;

  static AppNotificationType fromKey(String? key) {
    switch (key) {
      case 'rose':
        return AppNotificationType.rose;
      case 'compliment':
        return AppNotificationType.compliment;
      case 'match':
        return AppNotificationType.match;
      case 'message':
        return AppNotificationType.message;
      case 'date_approved':
      case 'dateApproved':
        return AppNotificationType.dateApproved;
      case 'gift':
        return AppNotificationType.gift;
      case 'like':
        return AppNotificationType.like;
      default:
        return AppNotificationType.generic;
    }
  }

  /// Which top filter chip this type belongs to.
  String get filterGroup {
    switch (this) {
      case AppNotificationType.rose:
      case AppNotificationType.like:
        return 'Likes & roses';
      case AppNotificationType.match:
        return 'Matches';
      case AppNotificationType.gift:
        return 'Gifts';
      case AppNotificationType.dateApproved:
        return 'Dates';
      case AppNotificationType.compliment:
      case AppNotificationType.message:
      case AppNotificationType.generic:
        return 'Other';
    }
  }
}

// ─── Title segment (for bold/regular mixed titles) ─────────────────────────

class NotificationTitleSegment {
  final String text;
  final bool bold;
  const NotificationTitleSegment(this.text, {this.bold = false});

  factory NotificationTitleSegment.fromJson(Map<String, dynamic> json) {
    return NotificationTitleSegment(
      json['text'] as String? ?? '',
      bold: json['bold'] as bool? ?? false,
    );
  }
}

// ─── Action button attached to a notification card ─────────────────────────

class AppNotificationAction {
  final String label;
  const AppNotificationAction({required this.label});

  factory AppNotificationAction.fromJson(Map<String, dynamic> json) {
    return AppNotificationAction(label: json['label'] as String? ?? '');
  }
}

// ─── AppNotification ────────────────────────────────────────────────────────

class AppNotification {
  final String id;
  final AppNotificationType type;
  final String? avatarUrl;
  final List<NotificationTitleSegment> titleSegments;
  final String? quote;
  final String timeAgo;
  final bool isUnread;
  final AppNotificationAction? action;

  /// Extra info line, e.g. "Coffee at Blue Tokai · Today, 7:00 PM · Koregaon Park".
  final String? extraLine;

  const AppNotification({
    required this.id,
    required this.type,
    this.avatarUrl,
    required this.titleSegments,
    this.quote,
    required this.timeAgo,
    this.isUnread = false,
    this.action,
    this.extraLine,
  });

  String get plainTitle => titleSegments.map((s) => s.text).join();

  AppNotification copyWith({bool? isUnread}) {
    return AppNotification(
      id: id,
      type: type,
      avatarUrl: avatarUrl,
      titleSegments: titleSegments,
      quote: quote,
      timeAgo: timeAgo,
      isUnread: isUnread ?? this.isUnread,
      action: action,
      extraLine: extraLine,
    );
  }

  /// Parses a notification coming from a backend response. Adjust the field
  /// names below to match your actual API contract — everything else in the
  /// UI layer is decoupled from this and will keep working.
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final segmentsJson = json['title_segments'] as List<dynamic>?;
    final segments = segmentsJson != null
        ? segmentsJson
            .map((e) => NotificationTitleSegment.fromJson(e as Map<String, dynamic>))
            .toList()
        : <NotificationTitleSegment>[
            NotificationTitleSegment(json['title'] as String? ?? ''),
          ];

    final actionJson = json['action'] as Map<String, dynamic>?;

    return AppNotification(
      id: json['id']?.toString() ?? UniqueKey().toString(),
      type: AppNotificationType.fromKey(json['type'] as String?),
      avatarUrl: json['avatar_url'] as String?,
      titleSegments: segments,
      quote: json['quote'] as String?,
      timeAgo: json['time_ago'] as String? ?? '',
      isUnread: json['is_unread'] as bool? ?? false,
      action: actionJson != null ? AppNotificationAction.fromJson(actionJson) : null,
      extraLine: json['extra_line'] as String?,
    );
  }
}