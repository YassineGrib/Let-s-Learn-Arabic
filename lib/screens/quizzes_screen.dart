import 'package:flutter/material.dart';

class QuizzesScreen extends StatelessWidget {
  const QuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arabic Quizzes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _quizzes.length,
        itemBuilder: (context, index) {
          final quiz = _quizzes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: _getQuizColor(quiz['level']),
                foregroundColor: Colors.white,
                child: Text('${index + 1}'),
              ),
              title: Text(
                quiz['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(quiz['description']),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLevelChip(quiz['level']),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('${quiz['questions']} questions'),
                        backgroundColor: Colors.grey[200],
                      ),
                    ],
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(quiz: quiz),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLevelChip(String level) {
    return Chip(
      label: Text(level),
      backgroundColor: _getQuizColor(level),
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  Color _getQuizColor(String level) {
    switch (level) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // Sample quiz data
  List<Map<String, dynamic>> get _quizzes => [
    {
      'title': 'Arabic Alphabet Quiz',
      'description': 'Test your knowledge of the Arabic alphabet.',
      'level': 'Beginner',
      'questions': 5,
      'questionsList': [
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
          'question': 'Which letter makes the "M" sound in Arabic?',
          'options': ['م', 'ن', 'ل', 'ك'],
          'correctAnswer': 0,
        },
        {
          'question': 'Which of these is NOT an Arabic letter?',
          'options': ['ش', 'ص', 'ط', 'پ'],
          'correctAnswer': 3,
        },
        {
          'question': 'Which letter comes after "ج" in the Arabic alphabet?',
          'options': ['ح', 'خ', 'د', 'ذ'],
          'correctAnswer': 0,
        },
      ],
    },
    {
      'title': 'Basic Greetings Quiz',
      'description': 'Test your knowledge of common Arabic greetings.',
      'level': 'Beginner',
      'questions': 5,
      'questionsList': [
        {
          'question': 'How do you say "Hello" in Arabic?',
          'options': ['شكرا', 'مرحبا', 'مع السلامة', 'طيب'],
          'correctAnswer': 1,
        },
        {
          'question': 'What does "السلام عليكم" mean?',
          'options': [
            'Good morning',
            'How are you?',
            'Peace be upon you',
            'Nice to meet you'
          ],
          'correctAnswer': 2,
        },
        {
          'question': 'How do you say "Thank you" in Arabic?',
          'options': ['شكرا', 'عفوا', 'من فضلك', 'مبروك'],
          'correctAnswer': 0,
        },
        {
          'question': 'What is the appropriate response to "كيف حالك؟" (How are you?)',
          'options': ['صباح الخير', 'أنا بخير، شكرا', 'مع السلامة', 'أهلا وسهلا'],
          'correctAnswer': 1,
        },
        {
          'question': 'How do you say "Goodbye" in Arabic?',
          'options': ['مرحبا', 'شكرا', 'مع السلامة', 'صباح الخير'],
          'correctAnswer': 2,
        },
      ],
    },
    {
      'title': 'Intermediate Vocabulary Quiz',
      'description': 'Test your knowledge of intermediate Arabic vocabulary.',
      'level': 'Intermediate',
      'questions': 5,
      'questionsList': [
        {
          'question': 'What is the Arabic word for "book"?',
          'options': ['قلم', 'كتاب', 'طاولة', 'باب'],
          'correctAnswer': 1,
        },
        {
          'question': 'What does "مطعم" mean?',
          'options': ['Hospital', 'School', 'Restaurant', 'Library'],
          'correctAnswer': 2,
        },
        {
          'question': 'What is the Arabic word for "car"?',
          'options': ['سيارة', 'حافلة', 'قطار', 'طائرة'],
          'correctAnswer': 0,
        },
        {
          'question': 'What does "مدرسة" mean?',
          'options': ['House', 'School', 'Office', 'Market'],
          'correctAnswer': 1,
        },
        {
          'question': 'What is the Arabic word for "water"?',
          'options': ['خبز', 'حليب', 'ماء', 'عصير'],
          'correctAnswer': 2,
        },
      ],
    },
  ];
}

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;

  // Selected answers for each question
  late List<int?> _selectedAnswers;

  @override
  void initState() {
    super.initState();
    final questionsList = widget.quiz['questionsList'] as List;
    _selectedAnswers = List.filled(questionsList.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz['title']),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _quizCompleted ? _buildResultScreen() : _buildQuestionScreen(),
      ),
    );
  }

  Widget _buildQuestionScreen() {
    final questionsList = widget.quiz['questionsList'] as List;
    final currentQuestion = questionsList[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / questionsList.length,
          backgroundColor: Colors.grey[300],
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Question ${_currentQuestionIndex + 1} of ${questionsList.length}',
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
                _currentQuestionIndex == questionsList.length - 1
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
    final questionsList = widget.quiz['questionsList'] as List;
    final percentage = (_score / questionsList.length) * 100;

    String feedback;
    IconData feedbackIcon;
    Color feedbackColor;

    if (percentage >= 80) {
      feedback = 'Excellent! You have a strong understanding of this topic.';
      feedbackIcon = Icons.emoji_events;
      feedbackColor = Colors.amber;
    } else if (percentage >= 60) {
      feedback = 'Good job! You\'re making good progress.';
      feedbackIcon = Icons.thumb_up;
      feedbackColor = Colors.green;
    } else {
      feedback = 'Keep practicing! Review this topic and try again.';
      feedbackIcon = Icons.refresh;
      feedbackColor = Colors.blue;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            feedbackIcon,
            color: feedbackColor,
            size: 80,
          ),
          const SizedBox(height: 24),
          const Text(
            'Quiz Completed!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Score: $_score/${questionsList.length} (${percentage.toInt()}%)',
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
            child: Text(
              feedback,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _restartQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                ),
                child: const Text('Try Again'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Back to Quizzes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    final questionsList = widget.quiz['questionsList'] as List;

    if (_currentQuestionIndex < questionsList.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _calculateScore();
      setState(() {
        _quizCompleted = true;
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
    final questionsList = widget.quiz['questionsList'] as List;
    _score = 0;

    for (int i = 0; i < questionsList.length; i++) {
      if (_selectedAnswers[i] == questionsList[i]['correctAnswer']) {
        _score++;
      }
    }
  }

  void _restartQuiz() {
    final questionsList = widget.quiz['questionsList'] as List;
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _selectedAnswers = List.filled(questionsList.length, null);
    });
  }
}
