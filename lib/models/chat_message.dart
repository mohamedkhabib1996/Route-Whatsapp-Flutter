enum MessageKind { text, picture }

class ChatMessage {
  const ChatMessage({
    required this.isIncoming,
    required this.kind,
    this.text,
    this.imagePath,
  });

  final bool isIncoming;
  final MessageKind kind;
  final String? text;
  final String? imagePath;

  const ChatMessage.incoming(this.text)
    : isIncoming = true,
      kind = MessageKind.text,
      imagePath = null;

  const ChatMessage.outgoing(this.text)
    : isIncoming = false,
      kind = MessageKind.text,
      imagePath = null;

  const ChatMessage.image(this.imagePath, {this.isIncoming = true})
    : kind = MessageKind.picture,
      text = null;
}
