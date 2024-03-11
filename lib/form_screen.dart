import 'package:flash_quiz/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FlashcardFormScreen extends StatefulWidget {
  @override
  _FlashcardFormScreenState createState() => _FlashcardFormScreenState();
}

class _FlashcardFormScreenState extends State<FlashcardFormScreen> {
  final TextEditingController _questionController = TextEditingController();
  bool _isTrue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: const Text('Add Flashcard'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Row(
                  children: [
                    const Center(child: Text('Is True:')),
                    Center(
                      child: Switch(
                        value: _isTrue,
                        onChanged: (value) {
                          setState(() {
                            _isTrue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveFlashcard();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveFlashcard() async {
    final question = _questionController.text;
    if (question.isNotEmpty) {
      final flashcard = Flashcard(question: question, isTrue: _isTrue);
      final prefs = await SharedPreferences.getInstance();
      List<String> flashcards = prefs.getStringList('flashcards') ?? [];
      flashcards.add(jsonEncode(flashcard.toJson()));
      await prefs.setStringList('flashcards', flashcards);
      Navigator.pop(context, flashcard);
    }
  }
}
