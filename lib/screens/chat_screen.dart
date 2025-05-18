import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  // Sample bot responses
  final List<String> _botResponses = [
    'مرحبا! كيف يمكنني مساعدتك في تعلم اللغة العربية؟ (Hello! How can I help you learn Arabic?)',
    'هذا سؤال جيد! (That\'s a good question!)',
    'يمكنك ممارسة النطق عن طريق الاستماع إلى الصوتيات وتكرارها. (You can practice pronunciation by listening to audio and repeating it.)',
    'أحسنت! استمر في الممارسة. (Well done! Keep practicing.)',
    'اللغة العربية لها قواعد نحوية مختلفة عن اللغة الإنجليزية. (Arabic has different grammatical rules than English.)',
    'هل تريد أن تتعلم المزيد من المفردات؟ (Would you like to learn more vocabulary?)',
  ];

  // Sample user prompts
  final List<String> _userPrompts = [
    'Hello! I\'m new to Arabic.',
    'How do I say "thank you" in Arabic?',
    'What\'s the best way to practice pronunciation?',
    'Can you explain Arabic grammar?',
    'How many letters are in the Arabic alphabet?',
    'What are some common Arabic phrases for travelers?',
  ];

  @override
  void initState() {
    super.initState();

    // Add initial bot message
    _addBotMessage(_botResponses[0]);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _handleSubmitted(String text) {
    _messageController.clear();

    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();

    // Simulate bot response after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      _addBotMessage(_botResponses[_messages.length % _botResponses.length]);
    });
  }

  void _scrollToBottom() {
    // Scroll to bottom of chat after a short delay to ensure the list has updated
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arabic Chat Space'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyChatPlaceholder()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _messages[index];
                    },
                  ),
          ),
          _buildSuggestionChips(),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildEmptyChatPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Start chatting to practice your Arabic',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _userPrompts.map((prompt) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(
                  prompt.length > 25 ? '${prompt.substring(0, 25)}...' : prompt,
                ),
                onPressed: () {
                  _handleSubmitted(prompt);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              // Voice input functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice input is not available in the prototype'),
                ),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => _handleSubmitted(_messageController.text),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(context),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      backgroundColor: isUser
          ? Theme.of(context).colorScheme.primary
          : Colors.grey[300],
      child: Icon(
        isUser ? Icons.person : Icons.android,
        color: Colors.white,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
