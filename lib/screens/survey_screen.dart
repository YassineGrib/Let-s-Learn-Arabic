import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Survey'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSubmitted ? _buildThankYouScreen() : _buildSurveyForm(),
      ),
    );
  }

  Widget _buildSurveyForm() {
    return FormBuilder(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about yourself',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This information helps us personalize your learning experience.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Name field
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            const SizedBox(height: 16),

            // Age field
            FormBuilderTextField(
              name: 'age',
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
                FormBuilderValidators.min(5),
                FormBuilderValidators.max(120),
              ]),
            ),
            const SizedBox(height: 16),

            // Native language field
            FormBuilderDropdown<String>(
              name: 'native_language',
              decoration: const InputDecoration(
                labelText: 'Native Language',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              items: [
                'English',
                'Spanish',
                'French',
                'German',
                'Chinese',
                'Japanese',
                'Korean',
                'Russian',
                'Portuguese',
                'Italian',
                'Other',
              ].map((language) => DropdownMenuItem(
                value: language,
                child: Text(language),
              )).toList(),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            const SizedBox(height: 16),

            // Reason for learning
            FormBuilderRadioGroup<String>(
              name: 'reason',
              decoration: const InputDecoration(
                labelText: 'Primary reason for learning Arabic',
                border: OutlineInputBorder(),
              ),
              options: const [
                FormBuilderFieldOption(value: 'Academic', child: Text('Academic')),
                FormBuilderFieldOption(value: 'Professional', child: Text('Professional')),
                FormBuilderFieldOption(value: 'Travel', child: Text('Travel')),
                FormBuilderFieldOption(value: 'Cultural Interest', child: Text('Cultural Interest')),
                FormBuilderFieldOption(value: 'Religious', child: Text('Religious')),
                FormBuilderFieldOption(value: 'Personal Growth', child: Text('Personal Growth')),
              ],
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            const SizedBox(height: 16),

            // Prior experience
            FormBuilderCheckboxGroup<String>(
              name: 'prior_experience',
              decoration: const InputDecoration(
                labelText: 'Prior experience with Arabic (select all that apply)',
                border: OutlineInputBorder(),
              ),
              options: const [
                FormBuilderFieldOption(value: 'None', child: Text('None')),
                FormBuilderFieldOption(value: 'Self-study', child: Text('Self-study')),
                FormBuilderFieldOption(value: 'Formal classes', child: Text('Formal classes')),
                FormBuilderFieldOption(value: 'Lived in Arabic-speaking country', child: Text('Lived in Arabic-speaking country')),
                FormBuilderFieldOption(value: 'Arabic-speaking friends/family', child: Text('Arabic-speaking friends/family')),
              ],
            ),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThankYouScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
          const SizedBox(height: 24),
          const Text(
            'Thank You!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your survey has been submitted successfully.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'ll use this information to personalize your learning experience.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
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

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // In a real app, you would send this data to a backend
      // For now, we'll just show the thank you screen
      setState(() {
        _isSubmitted = true;
      });
    }
  }
}
