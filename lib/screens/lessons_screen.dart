import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arabic Lessons'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Beginner (A1-A2)'),
                Tab(text: 'Intermediate (B1-B2)'),
                Tab(text: 'Advanced (C1-C2)'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildLessonList(context, _beginnerLessons),
                  _buildLessonList(context, _intermediateLessons),
                  _buildLessonList(context, _advancedLessons),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonList(BuildContext context, List<Map<String, dynamic>> lessons) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              child: Text('${index + 1}'),
            ),
            title: Text(
              lesson['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(lesson['description']),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonDetailScreen(lesson: lesson),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Sample lesson data
  List<Map<String, dynamic>> get _beginnerLessons => [
    {
      'title': 'Arabic Alphabet (الأبجدية العربية)',
      'description': 'Learn the basics of the Arabic alphabet and pronunciation.',
      'content': 'The Arabic alphabet consists of 28 letters. Unlike English, Arabic is written from right to left. Each letter can have up to 4 different forms depending on its position in a word.',
      'audioUrl': 'assets/audio/alphabet.mp3',
    },
    {
      'title': 'Greetings and Introductions (التحيات والمقدمات)',
      'description': 'Learn common Arabic greetings and how to introduce yourself.',
      'content': 'Arabic greetings are an important part of the culture. The most common greeting is "As-salamu alaykum" (السلام عليكم) which means "Peace be upon you".',
      'audioUrl': 'assets/audio/greetings.mp3',
    },
    {
      'title': 'Numbers 1-10 (الأرقام ١-١٠)',
      'description': 'Learn to count from 1 to 10 in Arabic.',
      'content': 'Arabic numbers are written from left to right, even though the language is written from right to left. The numbers 1-10 in Arabic are: واحد (1), اثنان (2), ثلاثة (3), أربعة (4), خمسة (5), ستة (6), سبعة (7), ثمانية (8), تسعة (9), عشرة (10).',
      'audioUrl': 'assets/audio/numbers.mp3',
    },
  ];

  List<Map<String, dynamic>> get _intermediateLessons => [
    {
      'title': 'Past Tense Verbs (الأفعال الماضية)',
      'description': 'Learn how to conjugate and use past tense verbs in Arabic.',
      'content': 'In Arabic, the past tense is formed by adding specific suffixes to the verb root. For example, the verb "to write" (كتب) becomes كتبت (I wrote), كتبت (you wrote), كتب (he wrote), etc.',
      'audioUrl': 'assets/audio/past_tense.mp3',
    },
    {
      'title': 'Describing Places (وصف الأماكن)',
      'description': 'Learn vocabulary and phrases for describing locations.',
      'content': 'When describing places in Arabic, adjectives follow the noun they modify and must agree in gender and number. For example, "a big house" would be "بيت كبير" (bayt kabir).',
      'audioUrl': 'assets/audio/places.mp3',
    },
    {
      'title': 'Food and Dining (الطعام والمطاعم)',
      'description': 'Learn vocabulary related to food and restaurant conversations.',
      'content': 'Arabic cuisine is diverse and rich in flavors. Some common food-related phrases include: "أنا جائع" (I am hungry), "هذا لذيذ" (This is delicious), "الفاتورة من فضلك" (The bill, please).',
      'audioUrl': 'assets/audio/food.mp3',
    },
  ];

  List<Map<String, dynamic>> get _advancedLessons => [
    {
      'title': 'Arabic Literature (الأدب العربي)',
      'description': 'Explore classical and modern Arabic literature.',
      'content': 'Arabic literature has a rich history dating back to the 6th century. Classical Arabic poetry, known as "qasida", follows strict meter and rhyme patterns. Modern Arabic literature includes novels, short stories, and free verse poetry.',
      'audioUrl': 'assets/audio/literature.mp3',
    },
    {
      'title': 'Dialectal Variations (اللهجات العربية)',
      'description': 'Learn about the different Arabic dialects across regions.',
      'content': 'While Modern Standard Arabic (فصحى) is used in formal contexts, there are many regional dialects such as Egyptian, Levantine, Gulf, and Maghrebi Arabic. These dialects can differ significantly in vocabulary, pronunciation, and grammar.',
      'audioUrl': 'assets/audio/dialects.mp3',
    },
    {
      'title': 'Business Arabic (العربية للأعمال)',
      'description': 'Learn vocabulary and phrases for professional settings.',
      'content': 'Business Arabic includes specialized vocabulary for fields like finance, marketing, and international relations. Formal titles and honorifics are important in professional communication.',
      'audioUrl': 'assets/audio/business.mp3',
    },
  ];
}

class LessonDetailScreen extends StatefulWidget {
  final Map<String, dynamic> lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

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
    });

    // In a real app, you would actually play/pause the audio
    // For this prototype, we'll just toggle the button state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson['title']),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lesson['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.lesson['description'],
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Lesson Content:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.lesson['content'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Text(
              'Audio Pronunciation:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pronunciation Guide',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isPlaying ? 'Playing...' : 'Press play to listen',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to quiz for this lesson
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/quizzes');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Take Quiz for This Lesson',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
