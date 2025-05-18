import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late YoutubePlayerController _controller;

  // Arabic learning video
  final String videoId = 'yM_sz5yexpo'; // Arabic Learning Video

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introductory Video'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Arabic Learning!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Watch this introductory video to get started with the basics of Arabic language.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
            const SizedBox(height: 24),
            const Text(
              'Key Points:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BulletPoint(
                      'Arabic is written and read from right to left.'),
                    BulletPoint(
                      'The Arabic alphabet consists of 28 letters.'),
                    BulletPoint(
                      'Arabic has unique sounds that don\'t exist in English.'),
                    BulletPoint(
                      'Letters change form depending on their position in a word.'),
                    BulletPoint(
                      'Arabic has a rich cultural and historical significance.'),
                    BulletPoint(
                      'Learning Arabic opens doors to understanding a vibrant culture and connecting with over 400 million speakers worldwide.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
