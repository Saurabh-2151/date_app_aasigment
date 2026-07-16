import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/user_model.dart';

// Public entry point — called from home_page.dart
void showComplimentBottomSheet(
  BuildContext context,
  UserModel user, {
  String title = 'Prompt',
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ComplimentSheet(
      user: user,
      title: title,
    ),
  );
}

// Keep old name as alias so nothing else breaks
void showRoseBottomSheet(
  BuildContext context,
  UserModel user,
) =>
    showComplimentBottomSheet(
      context,
      user,
      title: 'About',
    );

// ─── Sheet ────────────────────────────────────────────────────────────────────

class _ComplimentSheet extends StatefulWidget {
  final UserModel user;
  final String title;
  const _ComplimentSheet({required this.user,  required this.title,
});

  @override
  State<_ComplimentSheet> createState() => _ComplimentSheetState();
}

class _ComplimentSheetState extends State<_ComplimentSheet> {
  final TextEditingController _textCtrl = TextEditingController();
  bool _roseSelected = false;
  bool _giftSelected = false;
  bool _sending = false;

  static const int _maxChars = 140;

  static const _suggestions = [
    "You're fun to talk to.",
    "I'd love to know you better.",
    'You seem genuine.',
    'Your smile made my day.',
    'You have great energy.',
    "If you're as fun in person as your profile, I'm in.",
  ];

  bool get _canSend => _roseSelected;

  @override
  void initState() {
    super.initState();
    _textCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _tryCompliment() {
    final s = _suggestions[DateTime.now().millisecond % _suggestions.length];
    _textCtrl.text = s;
    _textCtrl.selection =
        TextSelection.fromPosition(TextPosition(offset: s.length));
  }

  Future<void> _send() async {
    if (!_canSend) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    // capture before async gap
    final nav = Navigator.of(context);
    final overlay = Overlay.of(context);
    nav.pop();
    _showToastOn(overlay);
  }

  void _showToastOn(OverlayState overlay) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 90,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Flexible(
                  child: Text(
                    '🌹 Rose + 💬 Comment sent! ✨ Opening chat...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), entry.remove);
  }

  // ── Builds the Send button's inner content ──────────────────────────────
  // Empty / not-ready state -> plain "Send Compliment" text (SS1)
  // Ready state (text typed + Rose or Gift selected) -> "Send <icon> + <icon>" (SS2/SS3)
  Widget _buildSendContent() {
  if (_sending) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }

  if (!_roseSelected) {
    return const Text(
      'Send Compliment',
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Text(
        'Send 🌹+',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(width: 8),
      Icon(
        Icons.chat_bubble_rounded,
        color: Colors.white,
        size: 16,
      ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: EdgeInsets.only(bottom: bottom),
      decoration: const BoxDecoration(
        color: Color(0xffFFFDF8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Title
              const Text(
                'COMPLIMENTING',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 2),
               Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: -.3,
                ),
              ),
              const SizedBox(height: 14),
              // Stats chips — Flexible + FittedBox so text never overflows
              Row(
                children: const [
                  Flexible(
                    child: _StatPill(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: '3 comments',
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: _StatPill(
                      icon: Icons.local_florist_rounded,
                      label: '2 roses',
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: _StatPill(
                      icon: Icons.monetization_on_outlined,
                      label: '5,258 balance',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Text field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _textCtrl,
                      maxLines: 1,
                      maxLength: _maxChars,
                      buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                          null,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Write a sweet compliment...',
                        hintStyle: const TextStyle(
                            color: AppColors.textHint, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: _tryCompliment,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('💡', style: TextStyle(fontSize: 11)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Try',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_textCtrl.text.length}/$_maxChars',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textHint),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Rose / Gift toggle
              Row(
                children: [
                  Expanded(
                    child: _ToggleBtn(
                      label: '🌹Rose',
                      selected: _roseSelected,
                      ready: _canSend,
                      onTap: () => setState(() {
                        _roseSelected = !_roseSelected;
                        if (_roseSelected) _giftSelected = false;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ToggleBtn(
                      label: 'Select Gift',
                      selected: _giftSelected,
                      ready: _giftSelected && _textCtrl.text.trim().isNotEmpty,
                      onTap: () => setState(() {
                        _giftSelected = !_giftSelected;
                        if (_giftSelected) _roseSelected = false;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Like + Send buttons
              Row(
                children: [
                  // Like button
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.favorite,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Like',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Send Compliment button
                  Expanded(
                    child: GestureDetector(
                      onTap: _canSend ? _send : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 50,
                        decoration: BoxDecoration(
                          color: _canSend ? AppColors.primary : AppColors.disabled,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: _canSend
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: _buildSendContent(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stat Pill ────────────────────────────────────────────────────────────────
// Fixed: text is wrapped in FittedBox so it scales down instead of
// overflowing on narrower screens (this was the "OVERFLOWED BY N PIXELS" bug).

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.chipBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.primary),
            const SizedBox(width: 4),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary),
                ),
              ),
            ),
          ],
        ),
      );
}

// ─── Toggle Button ────────────────────────────────────────────────────────────

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool selected;
  // "ready" = selected AND there is compliment text typed in -> matches
  // the solid filled pink checkmark seen in SS2/SS3. When selected but
  // not ready yet (empty text field, SS1), the checkmark stays muted/grey.
  final bool ready;
  final VoidCallback onTap;
  const _ToggleBtn(
      {
      required this.label,
      required this.selected,
      required this.ready,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 46,
          decoration: BoxDecoration(
            color: selected ? AppColors.selected : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 6),
                // Filled pink circle + white check once ready to send (SS2/SS3).
                // Muted grey outline check while waiting for compliment text (SS1).
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ready ? AppColors.primary : Colors.transparent,
                    border: ready
                        ? null
                        : Border.all(color: AppColors.textHint, width: 1.5),
                  ),
                  child: ready
                      ? const Icon(Icons.check, size: 10, color: Colors.white)
                      : null,
                ),
              ]
            ],
          ),
        ),
      );
}