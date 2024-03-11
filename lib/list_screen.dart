import 'package:flash_quiz/form_screen.dart';
import 'package:flutter/material.dart';
import 'flashcard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FlashcardListScreen extends StatefulWidget {
  @override
  _FlashcardListScreenState createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends State<FlashcardListScreen> {
  List<Flashcard> flashcards = [];
  List<Flashcard> allFlashcards = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: const Text(
          'Flashcards',
          style: TextStyle(fontSize: 32),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            colors: [
                              Colors.primaries[index % Colors.primaries.length],
                              Colors.primaries[
                                  (index + 5) % Colors.primaries.length],
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flashcards[index].question,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _checkAnswer(index, true);
                                    },
                                    icon: const Icon(
                                      Icons.check_box,
                                      color: Color.fromARGB(255, 21, 233, 113),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _checkAnswer(index, false);
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Color.fromARGB(255, 242, 45, 10),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _deleteQuestion(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _resetQuestions();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Score: $score'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToFlashcardFormScreen();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _checkAnswer(int index, bool selectedAnswer) {
    setState(() {
      if (flashcards[index].isTrue == selectedAnswer) {
        score++;
      }
      flashcards.removeAt(index);
    });
  }

  void _resetQuestions() {
    setState(() {
      flashcards = List.from(allFlashcards);
      score = 0;
    });
  }

  void _deleteQuestion(int index) async {
    setState(() {
      flashcards.removeAt(index);

      if (index < allFlashcards.length) {
        allFlashcards.removeAt(index);
      }
    });

    final prefs = await SharedPreferences.getInstance();
    List<String> flashcardsJson = allFlashcards
        .map((flashcard) => jsonEncode(flashcard.toJson()))
        .toList();
    await prefs.setStringList('flashcards', flashcardsJson);
  }

  void _navigateToFlashcardFormScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlashcardFormScreen()),
    );

    if (result != null && result is Flashcard) {
      setState(() {
        allFlashcards.add(result);
        flashcards.add(result);
      });
    }
  }

  Future<void> _loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> flashcardsJson = prefs.getStringList('flashcards') ?? [];
    List<Flashcard> loadedFlashcards = flashcardsJson
        .map((flashcard) => Flashcard.fromJson(jsonDecode(flashcard)))
        .toList();
    setState(() {
      allFlashcards = loadedFlashcards;
      flashcards = List.from(loadedFlashcards);
    });
  }
}
