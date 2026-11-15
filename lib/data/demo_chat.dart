import '../models/chat_message.dart';

/// Local dummy content reproducing the five items in the shared screenshot.
/// No user data, network request, or messaging backend is involved.
const List<ChatMessage> initialChat = <ChatMessage>[
  ChatMessage.incoming('Hello!'),
  ChatMessage.outgoing('Hello!'),
  ChatMessage.incoming(
    'Hey! Have you ever thought about how random moments can sometimes '
    'turn into the best memories? It’s like the universe loves to '
    'surprise us when we least expect it!',
  ),
  ChatMessage.image('assets/images/route_logo.png'),
  ChatMessage.outgoing('What a Great Course! To learn Flutter'),
];
