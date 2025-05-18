import 'package:flutter/material.dart';

class PlacementTestScreen extends StatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  State<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends State<PlacementTestScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _testCompleted = false;

  // Selected answers for each question
  final List<int?> _selectedAnswers = List.filled(5, null);

  // Sample placement test questions
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the first letter of the Arabic alphabet?',
      'options': ['ب (Ba)', 'أ (Alif)', 'ت (Ta)', 'ث (Tha)'],
      'correctAnswer': 1,
    },
    {
      'question': 'How many letters are in the Arabic alphabet?',
      'options': ['26', '28', '29', '31'],
      'correctAnswer': 1,
    },
    {
      'question': 'Which direction is Arabic written?',
      'options': [
        'Left to right',
        'Right to left',
        'Top to bottom',
        'Bottom to top'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'What does "مرحبا" mean?',
      'options': ['Goodbye', 'Thank you', 'Hello', 'Sorry'],
      'correctAnswer': 2,
    },
    {
      'question': 'Which of these is NOT an Arabic number?',
      'options': ['٣', '٥', '٨', '٪'],
      'correctAnswer': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Placement Test'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _testCompleted ? _buildResultScreen() : _buildQuestionScreen(),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: Colors.grey[300],
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          currentQuestion['question'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(
          currentQuestion['options'].length,
          (index) => RadioListTile<int>(
            title: Text(currentQuestion['options'][index]),
            value: index,
            groupValue: _selectedAnswers[_currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                _selectedAnswers[_currentQuestionIndex] = value;
              });
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentQuestionIndex > 0)
              ElevatedButton(
                onPressed: _previousQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                ),
                child: const Text('Previous'),
              )
            else
              const SizedBox(),
            ElevatedButton(
              onPressed: _selectedAnswers[_currentQuestionIndex] != null
                  ? _nextQuestion
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                _currentQuestionIndex == _questions.length - 1
                    ? 'Finish'
                    : 'Next',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    String level;
    String description;

    if (_score <= 1) {
      level = 'Beginner (A1)';
      description = 'You\'re just starting your Arabic journey. We\'ll begin with the basics.';
    } else if (_score <= 3) {
      level = 'Intermediate (B1)';
      description = 'You have some knowledge of Arabic. We\'ll help you build on that foundation.';
    } else {
      level = 'Advanced (C1)';
      description = 'You have a strong understanding of Arabic. We\'ll help you refine your skills.';
    }

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
            'Test Completed!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Score: $_score/${_questions.length}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Your Level: $level',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Return to Home'),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _calculateScore();
      setState(() {
        _testCompleted = true;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _calculateScore() {
    _score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i]['correctAnswer']) {
        _score++;
      }
    }
  }
}
