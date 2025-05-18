import 'package:flutter/material.dart';

class WorkshopsScreen extends StatelessWidget {
  const WorkshopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Workshops'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Interactive Arabic Workshops',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enhance your Arabic skills with these interactive activities.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Workshop cards
          _buildWorkshopCard(
            context,
            'Match Arabic Letters',
            'Match Arabic letters with their correct pronunciation.',
            Icons.school,
            Colors.blue,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MatchLettersWorkshop(),
                ),
              );
            },
          ),

          _buildWorkshopCard(
            context,
            'Vocabulary Flashcards',
            'Practice common Arabic vocabulary with interactive flashcards.',
            Icons.flash_on,
            Colors.orange,
            () {
              // Navigate to flashcards workshop
            },
          ),

          _buildWorkshopCard(
            context,
            'Conversation Practice',
            'Practice common Arabic conversations with guided exercises.',
            Icons.chat_bubble,
            Colors.green,
            () {
              // Navigate to conversation workshop
            },
          ),

          _buildWorkshopCard(
            context,
            'Writing Practice',
            'Practice writing Arabic letters and words.',
            Icons.edit,
            Colors.purple,
            () {
              // Navigate to writing workshop
            },
          ),

          _buildWorkshopCard(
            context,
            'Pronunciation Drills',
            'Master Arabic pronunciation with audio-guided exercises.',
            Icons.record_voice_over,
            Colors.red,
            () {
              // Navigate to pronunciation workshop
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchLettersWorkshop extends StatefulWidget {
  const MatchLettersWorkshop({super.key});

  @override
  State<MatchLettersWorkshop> createState() => _MatchLettersWorkshopState();
}

class _MatchLettersWorkshopState extends State<MatchLettersWorkshop> {
  // Arabic letters and their transliterations
  final List<Map<String, String>> _letters = [
    {'letter': 'أ', 'transliteration': 'Alif'},
    {'letter': 'ب', 'transliteration': 'Ba'},
    {'letter': 'ت', 'transliteration': 'Ta'},
    {'letter': 'ث', 'transliteration': 'Tha'},
    {'letter': 'ج', 'transliteration': 'Jim'},
    {'letter': 'ح', 'transliteration': 'Ha'},
  ];

  // Shuffled transliterations for matching
  late List<String> _shuffledTransliterations;

  // Selected letter and transliteration
  String? _selectedLetter;
  String? _selectedTransliteration;

  // Matched pairs
  final Map<String, String> _matchedPairs = {};

  // Game completed
  bool _gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _shuffledTransliterations = _letters
        .map((item) => item['transliteration']!)
        .toList()
      ..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Arabic Letters'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _gameCompleted
          ? _buildCompletionScreen()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Match each Arabic letter with its correct transliteration',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Progress indicator
                  LinearProgressIndicator(
                    value: _matchedPairs.length / _letters.length,
                    backgroundColor: Colors.grey[300],
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Progress: ${_matchedPairs.length}/${_letters.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),

                  // Arabic letters
                  const Text(
                    'Arabic Letters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: _letters.map((item) {
                      final letter = item['letter']!;
                      final isMatched = _matchedPairs.containsKey(letter);
                      final isSelected = _selectedLetter == letter;

                      return GestureDetector(
                        onTap: isMatched ? null : () => _selectLetter(letter),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isMatched
                                ? Colors.green[100]
                                : isSelected
                                    ? Theme.of(context).colorScheme.primary.withAlpha(75)
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isMatched
                                  ? Colors.green
                                  : isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isMatched
                                    ? Colors.green
                                    : isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Transliterations
                  const Text(
                    'Transliterations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: _shuffledTransliterations.map((transliteration) {
                      final isMatched = _matchedPairs.containsValue(transliteration);
                      final isSelected = _selectedTransliteration == transliteration;

                      return GestureDetector(
                        onTap: isMatched ? null : () => _selectTransliteration(transliteration),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isMatched
                                ? Colors.green[100]
                                : isSelected
                                    ? Theme.of(context).colorScheme.primary.withAlpha(75)
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isMatched
                                  ? Colors.green
                                  : isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            transliteration,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isMatched
                                  ? Colors.green
                                  : isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: 80,
          ),
          const SizedBox(height: 24),
          const Text(
            'Great Job!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You\'ve successfully matched all the Arabic letters!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: const Text(
              'Play Again',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back to Workshops'),
          ),
        ],
      ),
    );
  }

  void _selectLetter(String letter) {
    setState(() {
      _selectedLetter = letter;
    });

    _checkMatch();
  }

  void _selectTransliteration(String transliteration) {
    setState(() {
      _selectedTransliteration = transliteration;
    });

    _checkMatch();
  }

  void _checkMatch() {
    if (_selectedLetter != null && _selectedTransliteration != null) {
      // Find the correct transliteration for the selected letter
      final correctTransliteration = _letters
          .firstWhere((item) => item['letter'] == _selectedLetter)['transliteration'];

      if (correctTransliteration == _selectedTransliteration) {
        // Correct match
        setState(() {
          _matchedPairs[_selectedLetter!] = _selectedTransliteration!;
          _selectedLetter = null;
          _selectedTransliteration = null;

          // Check if game is completed
          if (_matchedPairs.length == _letters.length) {
            _gameCompleted = true;
          }
        });
      } else {
        // Incorrect match - reset selections after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _selectedLetter = null;
            _selectedTransliteration = null;
          });
        });
      }
    }
  }

  void _resetGame() {
    setState(() {
      _matchedPairs.clear();
      _selectedLetter = null;
      _selectedTransliteration = null;
      _gameCompleted = false;
      _shuffledTransliterations = _letters
          .map((item) => item['transliteration']!)
          .toList()
        ..shuffle();
    });
  }
}
