import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PodcastsScreen extends StatelessWidget {
  const PodcastsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arabic Learning Podcasts'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Arabic Learning Podcasts',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Listen to these podcasts to improve your Arabic listening and comprehension skills.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Podcast episodes
          ...podcastEpisodes.map((episode) => PodcastEpisodeCard(episode: episode)),
        ],
      ),
    );
  }

  // Sample podcast episodes
  List<Map<String, dynamic>> get podcastEpisodes => [
    {
      'title': 'Introduction to Arabic Pronunciation',
      'description': 'Learn the basics of Arabic pronunciation with native speakers.',
      'duration': '10:25',
      'date': 'May 15, 2023',
      'audioUrl': 'assets/audio/podcast1.mp3',
    },
    {
      'title': 'Common Arabic Phrases for Travelers',
      'description': 'Essential phrases to help you navigate Arabic-speaking countries.',
      'duration': '15:30',
      'date': 'May 22, 2023',
      'audioUrl': 'assets/audio/podcast2.mp3',
    },
    {
      'title': 'Arabic Culture and Traditions',
      'description': 'Explore the rich cultural heritage of the Arab world.',
      'duration': '20:15',
      'date': 'May 29, 2023',
      'audioUrl': 'assets/audio/podcast3.mp3',
    },
    {
      'title': 'Arabic Dialects Explained',
      'description': 'Understanding the differences between major Arabic dialects.',
      'duration': '18:45',
      'date': 'June 5, 2023',
      'audioUrl': 'assets/audio/podcast4.mp3',
    },
    {
      'title': 'Arabic Poetry and Literature',
      'description': 'An introduction to classical and modern Arabic literature.',
      'duration': '22:10',
      'date': 'June 12, 2023',
      'audioUrl': 'assets/audio/podcast5.mp3',
    },
    {
      'title': 'Arabic for Business',
      'description': 'Essential Arabic vocabulary and phrases for professional settings.',
      'duration': '16:30',
      'date': 'June 19, 2023',
      'audioUrl': 'assets/audio/podcast6.mp3',
    },
  ];
}

class PodcastEpisodeCard extends StatefulWidget {
  final Map<String, dynamic> episode;

  const PodcastEpisodeCard({super.key, required this.episode});

  @override
  State<PodcastEpisodeCard> createState() => _PodcastEpisodeCardState();
}

class _PodcastEpisodeCardState extends State<PodcastEpisodeCard> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    // In a real app, you would load the actual audio file
    // For this prototype, we'll simulate audio playback
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;

      // Simulate progress for the prototype
      if (_isPlaying) {
        _simulateProgress();
      }
    });

    // In a real app, you would actually play/pause the audio
    // For this prototype, we'll just toggle the button state
  }

  void _simulateProgress() {
    // This is just for the prototype to simulate audio progress
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isPlaying && mounted) {
        setState(() {
          _progress += 0.01;
          if (_progress >= 1.0) {
            _progress = 0.0;
            _isPlaying = false;
          } else {
            _simulateProgress();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.headphones,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.episode['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.episode['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.episode['date'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.episode['duration'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[300],
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_progress * _parseDuration(widget.episode['duration'])),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  widget.episode['duration'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  onPressed: () {
                    // Rewind 10 seconds
                    setState(() {
                      _progress = (_progress - 0.05).clamp(0.0, 1.0);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _togglePlayPause,
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10),
                  onPressed: () {
                    // Forward 10 seconds
                    setState(() {
                      _progress = (_progress + 0.05).clamp(0.0, 1.0);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _parseDuration(String durationString) {
    final parts = durationString.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  String _formatDuration(double seconds) {
    final int totalSeconds = seconds.toInt();
    final int minutes = totalSeconds ~/ 60;
    final int remainingSeconds = totalSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
