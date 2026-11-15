import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key, required this.onSend});

  final ValueChanged<String> onSend;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  void _showPreviewNotice(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is not available in this UI-only assignment.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 52),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textFieldOutline),
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.wallpaper,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => _showPreviewNotice('Camera'),
                      icon: const Icon(Icons.camera_alt_outlined),
                      color: AppColors.white,
                      tooltip: 'Camera',
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        cursorColor: AppColors.green,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Type a Message ...',
                          hintStyle: TextStyle(
                            color: AppColors.hint,
                            fontSize: 12,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 17),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _send,
                      icon: const Icon(Icons.send_outlined),
                      color: AppColors.white,
                      tooltip: 'Send message',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Material(
                color: AppColors.green,
                elevation: 2,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => _showPreviewNotice('Microphone'),
                  icon: const Icon(Icons.mic_none_rounded, size: 27),
                  color: AppColors.white,
                  iconSize: 25,
                  tooltip: 'Voice message',
                  constraints: const BoxConstraints(
                    minWidth: 52,
                    minHeight: 52,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
