import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app_assignment/data/models/notification.dart';
import 'package:dating_app_assignment/data/repositories/notification.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';


const _kCardRadius = 20.0;
const _kPeach = Color(0xFFFBE7D6);

// ─── NotificationsPage ──────────────────────────────────────────────────────

class NotificationsPage extends StatefulWidget {
  /// Pass pre-fetched notifications straight in (e.g. from a provider /
  /// bloc that already holds them). If null, the page fetches them itself
  /// via [repository].
  final List<AppNotification>? notifications;
  final NotificationsRepository? repository;

  const NotificationsPage({
    super.key,
    this.notifications,
    this.repository,
  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const _filters = ['All', 'Likes & roses', 'Matches', 'Gifts', 'Dates'];

  late final NotificationsRepository _repository =
      widget.repository ?? MockNotificationsRepository();

  List<AppNotification>? _notifications;
  bool _loading = true;
  String? _error;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    if (widget.notifications != null) {
      _notifications = widget.notifications;
      _loading = false;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _repository.fetchNotifications();
      if (!mounted) return;
      setState(() {
        _notifications = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Couldn\'t load notifications. Pull to try again.';
        _loading = false;
      });
    }
  }

  void _markAllRead() {
    final list = _notifications;
    if (list == null) return;
    setState(() {
      _notifications = list.map((n) => n.copyWith(isUnread: false)).toList();
    });
  }

  List<AppNotification> get _filtered {
    final list = _notifications ?? const [];
    if (_selectedFilter == 'All') return list;
    return list.where((n) => n.type.filterGroup == _selectedFilter).toList();
  }

  int get _unreadCount =>
      (_notifications ?? const []).where((n) => n.isUnread).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildFilterRow(),
            const SizedBox(height: 6),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CircleIconBtn(
            icon: Icons.chevron_left_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _unreadCount > 0 ? '$_unreadCount new updates' : 'You\'re all caught up',
                    style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: _markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Filter chips ──────────────────────────────────────────────────────

  Widget _buildFilterRow() {
    final total = (_notifications ?? const []).length;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final label = _filters[i];
          final selected = label == _selectedFilter;
          final showCount = label == 'All' && total > 0;
          return _FilterChip(
            label: showCount ? '$label  $total' : label,
            selected: selected,
            onTap: () => setState(() => _selectedFilter = label),
          );
        },
      ),
    );
  }

  // ─── Body ──────────────────────────────────────────────────────────────

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null) {
      return _buildErrorState();
    }
    final items = _filtered;
    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _load,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 12, left: 2),
              child: _SectionLabel('Today'),
            );
          }
          final notification = items[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _NotificationCard(
              notification: notification,
              onAction: () => _handleAction(notification),
              onTap: () => _handleTap(notification),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        const Icon(Icons.notifications_none_rounded, size: 56, color: AppColors.textHint),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Nothing here yet',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text(
            'New likes, roses and matches will show up here.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textHint),
        const SizedBox(height: 12),
        Center(
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: TextButton(
            onPressed: _load,
            child: const Text('Retry', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  void _handleAction(AppNotification n) {
    setState(() {
      _notifications = (_notifications ?? const [])
          .map((e) => e.id == n.id ? e.copyWith(isUnread: false) : e)
          .toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(n.action?.label ?? 'Opened'), duration: const Duration(seconds: 1)),
    );
  }

  void _handleTap(AppNotification n) {
    if (!n.isUnread) return;
    setState(() {
      _notifications = (_notifications ?? const [])
          .map((e) => e.id == n.id ? e.copyWith(isUnread: false) : e)
          .toList();
    });
  }
}

// ─── Header circle button ───────────────────────────────────────────────────

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleIconBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, offset: const Offset(0, 3)),
            ],
          ),
          child: Icon(icon, size: 24, color: AppColors.textPrimary),
        ),
      );
}

// ─── Filter chip ─────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.textPrimary : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Section label ("TODAY") ────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textHint,
          letterSpacing: 1.2,
        ),
      );
}

// ─── Notification card ───────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onAction;
  final VoidCallback onTap;
  const _NotificationCard({required this.notification, required this.onAction, required this.onTap});

  _BadgeStyle get _badge {
    switch (notification.type) {
      case AppNotificationType.rose:
        return const _BadgeStyle(icon: Icons.local_florist_rounded, color: AppColors.primary);
      case AppNotificationType.compliment:
        return const _BadgeStyle(icon: Icons.chat_bubble_rounded, color: AppColors.orange);
      case AppNotificationType.match:
        return const _BadgeStyle(icon: Icons.check_rounded, color: AppColors.green, filled: true);
      case AppNotificationType.message:
        return const _BadgeStyle(icon: Icons.chat_bubble_outline_rounded, color: AppColors.primary);
      case AppNotificationType.like:
        return const _BadgeStyle(icon: Icons.favorite_rounded, color: AppColors.primary);
      case AppNotificationType.gift:
        return const _BadgeStyle(icon: Icons.card_giftcard_rounded, color: AppColors.orange);
      case AppNotificationType.dateApproved:
      case AppNotificationType.generic:
        return const _BadgeStyle(icon: Icons.notifications_rounded, color: AppColors.textHint);
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = notification;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_kCardRadius),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeading(),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildTitle()),
                      if (n.isUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        ),
                      ],
                    ],
                  ),
                  if (n.quote != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      n.quote!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (n.extraLine != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      n.extraLine!,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    n.timeAgo,
                    style: const TextStyle(fontSize: 12, color: AppColors.textHint),
                  ),
                  if (n.action != null) ...[
                    const SizedBox(height: 12),
                    _ActionButton(label: n.action!.label, onTap: onAction),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
      text: TextSpan(
        children: notification.titleSegments
            .map((s) => TextSpan(
                  text: s.text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: s.bold ? FontWeight.w800 : FontWeight.w500,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLeading() {
    final n = notification;
    if (n.avatarUrl == null) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: _kPeach,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.calendar_today_rounded, color: AppColors.orange, size: 22),
      );
    }

    final badge = _badge;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: n.avatarUrl!,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(width: 52, height: 52, color: const Color(0xFFE8E0D8)),
            errorWidget: (_, __, ___) => Container(
              width: 52,
              height: 52,
              color: const Color(0xFFE8E0D8),
              child: const Icon(Icons.person, color: Colors.white, size: 26),
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: badge.filled ? badge.color : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 4)],
            ),
            child: Icon(badge.icon, size: 12, color: badge.filled ? Colors.white : badge.color),
          ),
        ),
      ],
    );
  }
}

class _BadgeStyle {
  final IconData icon;
  final Color color;
  final bool filled;
  const _BadgeStyle({required this.icon, required this.color, this.filled = false});
}

// ─── Pink filled action button ───────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withValues(alpha: 0.28), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}