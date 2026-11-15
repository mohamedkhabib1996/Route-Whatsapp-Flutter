import 'package:material_ui/material_ui.dart';

import '../models/chat_message.dart';
import '../theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final bool incoming = message.isIncoming;
    final bool picture = message.kind == MessageKind.picture;
    final double maxBubbleWidth = MediaQuery.sizeOf(context).width * 0.78;

    return Align(
      alignment: incoming ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(picture ? 6 : 12),
        decoration: BoxDecoration(
          color: incoming ? AppColors.green : AppColors.outgoingBubble,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(incoming ? 0 : 16),
            topRight: Radius.circular(incoming ? 16 : 0),
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
          ),
        ),
        child: picture
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  message.imagePath!,
                  height: 168,
                  width: 230,
                  fit: BoxFit.cover,
                  semanticLabel: 'Route diploma logo image in chat',
                ),
              )
            : Text(
                message.text ?? '',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  height: 1.28,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
