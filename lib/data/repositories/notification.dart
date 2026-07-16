
import 'package:dating_app_assignment/data/models/notification.dart';

/// Abstraction so the UI never cares whether notifications come from mock
/// data or a real backend.
abstract class NotificationsRepository {
  Future<List<AppNotification>> fetchNotifications();
}

/// Drop-in mock used until the real endpoint is wired up. Swap the
/// `NotificationsRepository` instance passed into [NotificationsPage] with
/// your own implementation (e.g. `ApiNotificationsRepository`) that calls
/// your backend and maps the JSON response through `AppNotification.fromJson`
/// — nothing else in the UI needs to change.
///
/// Example real implementation:
/// ```dart
/// class ApiNotificationsRepository implements NotificationsRepository {
///   final Dio dio;
///   ApiNotificationsRepository(this.dio);
///
///   @override
///   Future<List<AppNotification>> fetchNotifications() async {
///     final res = await dio.get('/notifications');
///     final list = res.data['results'] as List;
///     return list.map((e) => AppNotification.fromJson(e)).toList();
///   }
/// }
/// ```
class MockNotificationsRepository implements NotificationsRepository {
  @override
  Future<List<AppNotification>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockNotifications;
  }
}

final List<AppNotification> _mockNotifications = [
  AppNotification(
    id: 'n1',
    type: AppNotificationType.rose,
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    titleSegments: const [
      NotificationTitleSegment('Dev, 27', bold: true),
      NotificationTitleSegment(' sent you a Rose'),
    ],
    quote: 'Your trekking photos sold me — let\'s swap trail stories.',
    timeAgo: '12 min ago',
    isUnread: true,
    action: const AppNotificationAction(label: 'View profile'),
  ),
  AppNotification(
    id: 'n2',
    type: AppNotificationType.compliment,
    avatarUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
    titleSegments: const [
      NotificationTitleSegment('Arjun, 28', bold: true),
      NotificationTitleSegment(' complimented your '),
      NotificationTitleSegment('About', bold: true),
    ],
    quote: 'Equally driven and equally curious — that line got me.',
    timeAgo: '3 h ago',
  ),
  AppNotification(
    id: 'n3',
    type: AppNotificationType.match,
    avatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
    titleSegments: const [
      NotificationTitleSegment('It\'s a match with '),
      NotificationTitleSegment('Aanya, 25', bold: true),
    ],
    quote: 'You both liked each other. Say hello before the spark fades.',
    timeAgo: '40 min ago',
    isUnread: true,
    action: const AppNotificationAction(label: 'Send a message'),
  ),
  AppNotification(
    id: 'n4',
    type: AppNotificationType.message,
    avatarUrl: 'https://randomuser.me/api/portraits/women/21.jpg',
    titleSegments: const [
      NotificationTitleSegment('Elena, 23', bold: true),
      NotificationTitleSegment(' sent you a message'),
    ],
    quote: 'Haha okay that café pick was elite. When are you free?',
    timeAgo: '1 h ago',
    isUnread: true,
  ),
  AppNotification(
    id: 'n5',
    type: AppNotificationType.dateApproved,
    titleSegments: const [
      NotificationTitleSegment('Kabir', bold: true),
      NotificationTitleSegment(' approved your date request'),
    ],
    extraLine: 'Coffee at Blue Tokai · Today, 7:00 PM · Koregaon Park',
    timeAgo: '2 h ago',
    isUnread: true,
    action: const AppNotificationAction(label: 'Open chat'),
  ),
];