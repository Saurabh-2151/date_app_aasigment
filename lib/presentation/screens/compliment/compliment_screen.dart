import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ComplimentScreen extends StatefulWidget {
  const ComplimentScreen({super.key});

  @override
  State<ComplimentScreen> createState() => _ComplimentScreenState();
}

class _ComplimentScreenState extends State<ComplimentScreen> {
  int? _selectedIndex;
  final TextEditingController _controller = TextEditingController();

  static const List<Map<String, String>> _compliments = [
    {'emoji': '😍', 'text': 'You have an amazing smile'},
    {'emoji': '✨', 'text': 'Your vibe is incredible'},
    {'emoji': '🔥', 'text': 'You look absolutely stunning'},
    {'emoji': '💫', 'text': 'Your energy is magnetic'},
    {'emoji': '🌟', 'text': 'You seem really interesting'},
    {'emoji': '💖', 'text': 'I love your sense of style'},
    {'emoji': '🎯', 'text': 'Your profile caught my eye'},
    {'emoji': '🌹', 'text': 'You seem like a great person'},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Send a Compliment', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Choose a compliment', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('Pick one or write your own below', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.4,
                    ),
                    itemCount: _compliments.length,
                    itemBuilder: (_, i) => _ComplimentTile(
                      emoji: _compliments[i]['emoji']!,
                      text: _compliments[i]['text']!,
                      selected: _selectedIndex == i,
                      onTap: () => setState(() {
                        _selectedIndex = _selectedIndex == i ? null : i;
                        _controller.clear();
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Or write your own', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    maxLength: 150,
                    onChanged: (_) => setState(() => _selectedIndex = null),
                    decoration: InputDecoration(
                      hintText: 'Write something kind...',
                      hintStyle: const TextStyle(color: AppColors.textHint),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _SendButton(
            enabled: _selectedIndex != null || _controller.text.trim().isNotEmpty,
            onTap: () {
              if (_selectedIndex != null || _controller.text.trim().isNotEmpty) {
                _showSentDialog(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💌', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text('Compliment Sent!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text('They\'ll be notified of your kind words.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { Navigator.pop(context); Navigator.pop(context); },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComplimentTile extends StatelessWidget {
  final String emoji;
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _ComplimentTile({required this.emoji, required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider, width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Expanded(child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: selected ? AppColors.primary : AppColors.textPrimary), maxLines: 2)),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;
  const _SendButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      color: AppColors.surface,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: enabled ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.divider,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: enabled ? 4 : 0,
          ),
          child: const Text('Send Compliment 💌', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
