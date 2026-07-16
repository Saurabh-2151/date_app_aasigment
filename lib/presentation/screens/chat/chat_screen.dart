import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const List<Map<String, dynamic>> _chats = [
    {'name': 'Sophia', 'image': 'https://randomuser.me/api/portraits/women/44.jpg', 'lastMsg': 'That sounds like a great idea! 😊', 'time': '2m', 'unread': 2, 'online': true},
    {'name': 'Emma', 'image': 'https://randomuser.me/api/portraits/women/65.jpg', 'lastMsg': 'Haha yes exactly! When are you free?', 'time': '15m', 'unread': 0, 'online': true},
    {'name': 'Olivia', 'image': 'https://randomuser.me/api/portraits/women/32.jpg', 'lastMsg': 'I love that coffee place too!', 'time': '1h', 'unread': 1, 'online': false},
    {'name': 'Ava', 'image': 'https://randomuser.me/api/portraits/women/17.jpg', 'lastMsg': 'See you Saturday then 🎉', 'time': '3h', 'unread': 0, 'online': false},
    {'name': 'Isabella', 'image': 'https://randomuser.me/api/portraits/women/55.jpg', 'lastMsg': 'You have great taste in music!', 'time': '1d', 'unread': 0, 'online': false},
    {'name': 'Mia', 'image': 'https://randomuser.me/api/portraits/women/12.jpg', 'lastMsg': 'Thanks for the recommendation 🙏', 'time': '2d', 'unread': 0, 'online': false},
  ];

  static const List<Map<String, dynamic>> _matches = [
    {'name': 'Zoe', 'image': 'https://randomuser.me/api/portraits/women/23.jpg'},
    {'name': 'Lily', 'image': 'https://randomuser.me/api/portraits/women/34.jpg'},
    {'name': 'Chloe', 'image': 'https://randomuser.me/api/portraits/women/45.jpg'},
    {'name': 'Grace', 'image': 'https://randomuser.me/api/portraits/women/56.jpg'},
    {'name': 'Nora', 'image': 'https://randomuser.me/api/portraits/women/67.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            _buildNewMatches(),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Align(alignment: Alignment.centerLeft, child: Text('Messages', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
            ),
            Expanded(child: _buildChatList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Chat', style: Theme.of(context).textTheme.headlineMedium),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildNewMatches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text('New Matches', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ),
        SizedBox(
          height: 88,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _matches.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _MatchAvatar(profile: _matches[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildChatList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: _chats.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 76),
      itemBuilder: (_, i) => _ChatTile(chat: _chats[i], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _ChatDetailScreen(chat: _chats[i])))),
    );
  }
}

class _MatchAvatar extends StatelessWidget {
  final Map<String, dynamic> profile;
  const _MatchAvatar({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: ClipOval(
            child: Image.network(profile['image'], fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.textHint)),
          ),
        ),
        const SizedBox(height: 4),
        Text(profile['name'], style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _ChatTile extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;
  const _ChatTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      onTap: onTap,
      leading: Stack(
        children: [
          ClipOval(
            child: Image.network(chat['image'], width: 54, height: 54, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 54, height: 54, color: AppColors.textHint)),
          ),
          if (chat['online'])
            Positioned(
              bottom: 1, right: 1,
              child: Container(
                width: 13, height: 13,
                decoration: BoxDecoration(color: const Color(0xFF4CAF50), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              ),
            ),
        ],
      ),
      title: Text(chat['name'], style: TextStyle(fontSize: 15, fontWeight: chat['unread'] > 0 ? FontWeight.w700 : FontWeight.w500, color: AppColors.textPrimary)),
      subtitle: Text(chat['lastMsg'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: chat['unread'] > 0 ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: chat['unread'] > 0 ? FontWeight.w500 : FontWeight.w400)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(chat['time'], style: TextStyle(fontSize: 11, color: chat['unread'] > 0 ? AppColors.primary : AppColors.textHint)),
          const SizedBox(height: 4),
          if (chat['unread'] > 0)
            Container(
              width: 20, height: 20,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: Center(child: Text('${chat['unread']}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
            ),
        ],
      ),
    );
  }
}

class _ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;
  const _ChatDetailScreen({required this.chat});

  @override
  State<_ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<_ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hey! How are you? 😊', 'mine': false, 'time': '10:30 AM'},
    {'text': 'I\'m great! Just got back from a hike. You?', 'mine': true, 'time': '10:32 AM'},
    {'text': 'Oh nice! I love hiking. Which trail?', 'mine': false, 'time': '10:33 AM'},
    {'text': 'The Sunset Ridge trail. The views were incredible!', 'mine': true, 'time': '10:35 AM'},
    {'text': 'That sounds amazing! We should go together sometime 🏔️', 'mine': false, 'time': '10:36 AM'},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': _controller.text.trim(), 'mine': true, 'time': 'Now'});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            ClipOval(child: Image.network(widget.chat['image'], width: 36, height: 36, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 36, height: 36, color: AppColors.textHint))),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chat['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                if (widget.chat['online']) const Text('Online', style: TextStyle(fontSize: 11, color: Color(0xFF4CAF50))),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _MessageBubble(message: _messages[i]),
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      color: AppColors.surface,
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary), onPressed: () {}),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMine = message['mine'] as bool;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMine ? 18 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 18),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message['text'], style: TextStyle(color: isMine ? Colors.white : AppColors.textPrimary, fontSize: 14)),
            const SizedBox(height: 2),
            Text(message['time'], style: TextStyle(color: isMine ? Colors.white60 : AppColors.textHint, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
