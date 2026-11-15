import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../data/demo_chat.dart';
import '../models/chat_message.dart';
import '../theme/app_colors.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = List<ChatMessage>.of(initialChat);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToEnd(jump: true),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd({bool jump = false}) {
    if (!_scrollController.hasClients) return;
    final double target = _scrollController.position.maxScrollExtent;
    if (jump) {
      _scrollController.jumpTo(target);
    } else {
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _sendMessage(String text) {
    setState(() => _messages.add(ChatMessage.outgoing(text)));
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  void _notice(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is a visual placeholder in this assignment.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wallpaper,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.green,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        toolbarHeight: 64,
        elevation: 0,
        leadingWidth: 90,
        titleSpacing: 2,
        leading: Row(
          children: <Widget>[
            SizedBox(
              width: 42,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                onPressed: () => _notice('Back navigation'),
                tooltip: 'Back',
              ),
            ),
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF4DAB77),
              backgroundImage: AssetImage('assets/images/john_avatar.png'),
            ),
          ],
        ),
        title: const Text(
          'John Safwat',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            constraints: const BoxConstraints(minWidth: 40),
            padding: const EdgeInsets.all(6),
            onPressed: () => _notice('Voice calling'),
            icon: const Icon(Icons.call_outlined, size: 22),
            tooltip: 'Voice call',
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 40),
            padding: const EdgeInsets.all(6),
            onPressed: () => _notice('Video calling'),
            icon: const Icon(Icons.videocam_outlined, size: 24),
            tooltip: 'Video call',
          ),
          PopupMenuButton<String>(
            tooltip: 'More options',
            color: AppColors.outgoingBubble,
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) => _notice(value),
            itemBuilder: (BuildContext context) =>
                const <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'Contact info',
                    child: Text('Contact info'),
                  ),
                  PopupMenuItem<String>(value: 'Search', child: Text('Search')),
                  PopupMenuItem<String>(
                    value: 'Mute notifications',
                    child: Text('Mute notifications'),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.wallpaper,
                image: DecorationImage(
                  image: AssetImage('assets/images/chat_wallpaper.png'),
                  repeat: ImageRepeat.repeat,
                  scale: 2.0,
                  opacity: 0.85,
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) =>
                    ChatBubble(message: _messages[index]),
              ),
            ),
          ),
          ChatInputBar(onSend: _sendMessage),
        ],
      ),
    );
  }
}
