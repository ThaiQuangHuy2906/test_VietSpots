import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietspots/models/chat_model.dart';
import 'package:vietspots/providers/chat_provider.dart';
import 'package:vietspots/widgets/place_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  bool _isTyping = false;

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _isTyping = true);
    Provider.of<ChatProvider>(
      context,
      listen: false,
    ).sendMessage(_controller.text);
    _controller.clear();

    // Simulate typing delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isTyping = false);
    });
  }

  void _startNewChat() {
    Provider.of<ChatProvider>(context, listen: false).clearMessages();
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('New chat started')));
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VietSpots',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.redAccent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Close Chat',
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('VietSpots AI'),
              accountEmail: const Text('Your Personal Travel Assistant'),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/200'),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('New Chat'),
              onTap: _startNewChat,
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'History',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Trip to Da Lat'),
                    subtitle: const Text('2 days ago'),
                    onTap: () {
                      Navigator.pop(context);
                      // Load history logic
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Food in District 1'),
                    subtitle: const Text('5 days ago'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Beaches in Vung Tau'),
                    subtitle: const Text('1 week ago'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: chatProvider.messages.isEmpty && !_isTyping
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(
                                alpha: 25 / 255,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.smart_toy,
                              size: 40,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Xin chào Glory H! 👋',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tôi là trợ lý ảo VietSpots.\nBạn cần tìm địa điểm nào?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount:
                        chatProvider.messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatProvider.messages.length && _isTyping) {
                        return _buildTypingIndicator();
                      }
                      final msg = chatProvider.messages[index];
                      return _buildMessageBubble(msg);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.1),
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[850]?.withValues(alpha: 128 / 255)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]!.withValues(alpha: 102 / 255)
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask VietSpots...',
                        hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color
                              ?.withValues(alpha: 128 / 255),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.pinkAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha: 77 / 255),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE8F5E8),
            child: Icon(Icons.smart_toy, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  'VietSpots is typing',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  height: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      3,
                      (i) => AnimatedContainer(
                        duration: Duration(milliseconds: 400 + i * 200),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              backgroundColor: Color(0xFFE8F5E8),
              child: Icon(Icons.smart_toy, color: Colors.green, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? Colors.redAccent : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isUser ? const Radius.circular(18) : Radius.zero,
                  bottomRight: isUser ? Radius.zero : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(msg.timestamp),
                    style: TextStyle(
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                  if (msg.relatedPlaces != null &&
                      msg.relatedPlaces!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: msg.relatedPlaces!.length,
                          itemBuilder: (context, index) {
                            return PlaceCard(place: msg.relatedPlaces![index]);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
