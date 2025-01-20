import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:curiosityclash/theme.dart';
import 'package:curiosityclash/widgets/playerCard.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:curiosityclash/services/api.dart';
import 'package:curiosityclash/models/UserModel.dart';
import 'package:curiosityclash/models/QuestionModel.dart';
import 'package:flutter_math_fork/ast.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:latext/latext.dart';

class TrainPage extends StatefulWidget {
  final String? sessionId;

  const TrainPage({super.key, this.sessionId});

  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  bool isQuestionVisible = true;
  String? selectedAnswer;
  final TextEditingController textFieldController = TextEditingController();
  Future<UserModel>? _userFuture;
  Future<List<QuestionModel>>? _questionsFuture;
  int currentQuestionIndex = 0;
  List<QuestionModel> questions = [];

  @override
  void initState() {
    super.initState();
    if (widget.sessionId != null) {
      _userFuture = ApiService().fetchUserById(widget.sessionId!);
      _questionsFuture = ApiService().fetchQuestions();
      _questionsFuture!.then((fetchedQuestions) {
        setState(() {
          questions = fetchedQuestions;
        });
      });
    } else {
      _userFuture = Future.error('No session ID provided');
    }
  }

  void handleSubmit() async {
    if (selectedAnswer == null) {
      // Show a popup if no answer is selected
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.darkTheme.primaryColor,
          title: Text(
            'You haven\'t answered the question',
            style: TextStyle(
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          content: Text(
            'Please choose an answer before submitting.',
            style: TextStyle(
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: AppTheme.lightTheme.primaryColor),
              ),
            ),
          ],
        ),
      );
    } else {
      // Clear the TextField without changing the layout
      textFieldController.clear();

      // Update user coins and attributes
      try {
        var user = await _userFuture;
        if (user != null) {
          if (selectedAnswer == questions[currentQuestionIndex].correctAnswer) {
            user.coins += 50; // Add coins for correct answer

            // Show "Question Answered" Popup
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppTheme.darkTheme.primaryColor,
                title: Text(
                  'Question Answered',
                  style: TextStyle(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                content: Text(
                  'You have a correct answer!',
                  style: TextStyle(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Show explanation if the answer is incorrect

            showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.darkTheme.primaryColor,
      title: Text(
        'Incorrect Answer',
        style: TextStyle(
          color: AppTheme.lightTheme.primaryColor,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Static LaTeX block
            LaTexT(
              laTeXCode: Text(
                questions[currentQuestionIndex].explanation, // Ganti dengan ekspresi LaTeX
                style: TextStyle(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: TextStyle(
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
          }
          await ApiService().updateUserCoins(user.id!, user.coins);
        }
      } catch (e) {
        print('Error updating user: $e');
      }

      // Move to the next question
      setState(() {
        currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
        selectedAnswer = null;
      });
    }
  }

  void handleSkipQuestion() async {
    // Show confirmation dialog
    bool confirmSkip = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Skip Question',
          style: TextStyle(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        content: Text(
          'Are you sure you want to skip this question? You will lose some coins and attributes.',
          style: TextStyle(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        backgroundColor: AppTheme.darkTheme.primaryColor,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Skip',
              style: TextStyle(
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmSkip) {
      // Simply clear the TextField and keep the UI unchanged
      textFieldController.clear();

      // Update user coins and attributes
      try {
        var user = await _userFuture;
        if (user != null) {
          user.coins = (user.coins - 10).clamp(0,
              user.coins); // Subtract coins for skipping question, but not below 0
          user.armor = (user.armor - 5).clamp(0,
              user.armor); // Subtract armor for skipping question, but not below 0
          user.strike = (user.strike - 5).clamp(0,
              user.strike); // Subtract strike for skipping question, but not below 0
          user.damage = (user.damage - 5).clamp(0,
              user.damage); // Subtract damage for skipping question, but not below 0
          await ApiService().updateUserAttributes(
              user.id!, user.coins, user.armor, user.strike, user.damage);
        }
      } catch (e) {
        print('Error updating user: $e');
      }

      // Show "You skipped the question" Popup
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'You skipped the question',
            style: TextStyle(
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          content: Text(
            'You have skipped the question.',
            style: TextStyle(
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          backgroundColor: AppTheme.darkTheme.primaryColor,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );

      // Move to the next question
      setState(() {
        currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
        selectedAnswer = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var user = snapshot.data!;
            return _buildTrainPage(context, user);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildTrainPage(BuildContext context, UserModel user) {
    // Get user stats and provide default values if null
    int armor = user.armor ?? 0;
    int strike = user.strike ?? 0;
    int damage = user.damage ?? 0;

    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/img/bg-trainPage.png',
            fit: BoxFit.cover,
          ),
        ),

        // Konten utama
        Column(
          children: [
            // Komponen PlayerCard di bagian atas
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: PlayerCard(sessionId: widget.sessionId),
            ),

            // Karakter di bagian tengah atas
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Character Image
                  Image.asset(
                    'assets/img/char1.png',
                    width: 200,
                    height: 200,
                  ),

                  // Stat buttons with background and rounded corners
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Damage button with shadow
                      Container(
                        width: 90,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.darkTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: StatButton(
                          label: "Damage",
                          value: "$damage",
                          icon: MdiIcons.sword,
                          iconColor: Colors.red,
                        ),
                      ),

                      // Strike button with shadow
                      Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.darkTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: StatButton(
                          label: "Strike",
                          value: "$strike%",
                          icon: Icons.flash_on,
                          iconColor: Colors.yellow,
                        ),
                      ),

                      // Armor button with shadow
                      Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.darkTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: StatButton(
                          label: "Armor",
                          value: "$armor",
                          icon: Icons.shield,
                          iconColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Pertanyaan
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppTheme.darkTheme.colorScheme.primary,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: _buildQuestionContent(),
              ),
            ),
          ],
        ),

        // Bar Koin di pojok kanan atas
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 100,
            height: 45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/koin-bar.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Center(
                child: Text(
                  user.coins.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionContent() {
    if (questions.isEmpty) {
      return Center(child: Text('No questions available'));
    }

    var question = questions[currentQuestionIndex];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              "Question",
              style: GoogleFonts.metamorphous(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decorationThickness: 2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    question.text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButton<String>(
                    value: selectedAnswer,
                    hint: Text(
                      'Select answer',
                      style: TextStyle(
                        color: AppTheme.darkTheme.primaryColor,
                      ),
                    ),
                    items: question.options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: AppTheme.darkTheme.primaryColor,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAnswer = newValue;
                      });
                    },
                    dropdownColor: AppTheme.lightTheme.primaryColor,
                    style: TextStyle(
                      color: AppTheme.darkTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.surface,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Submit"),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                        width: 8,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: handleSkipQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.surface,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Skip Question"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
