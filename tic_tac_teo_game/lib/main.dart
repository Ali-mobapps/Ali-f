import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const TicTacToeApp());
}

// Global App Manager with Audioplayers Support
class AppManager extends ChangeNotifier {
  bool isDarkMode = true;
  bool isSoundEnabled = true;
  bool isBgmEnabled = false;

  late final AudioPlayer _sfxPlayer = AudioPlayer();
  late final AudioPlayer _bgmPlayer = AudioPlayer();

  AppManager() {
    _bgmPlayer.setReleaseMode(ReleaseMode.loop); // Background music loop
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void toggleSound() {
    isSoundEnabled = !isSoundEnabled;
    notifyListeners();
  }

  void toggleBgm() async {
    isBgmEnabled = !isBgmEnabled;
    if (isBgmEnabled) {
      try {
        await _bgmPlayer.play(AssetSource('audio/bgm.mp3'));
      } catch (e) {
        // Agar bgm.mp3 file nahi mili toh ignore karega taake app crash na ho
      }
    } else {
      await _bgmPlayer.stop();
    }
    notifyListeners();
  }

  void playSfx() {
    if (!isSoundEnabled) return;
    HapticFeedback.lightImpact();
  }
}

final appManager = AppManager();

class TicTacToeApp extends StatefulWidget {
  const TicTacToeApp({super.key});

  @override
  State<TicTacToeApp> createState() => _TicTacToeAppState();
}

class _TicTacToeAppState extends State<TicTacToeApp> {
  @override
  void initState() {
    super.initState();
    appManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    bool dark = appManager.isDarkMode;
    return MaterialApp(
      title: 'Tic Tac Toe Master Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        primaryColor: const Color(0xFF6366F1),
      ),
      home: const GameModeScreen(),
    );
  }
}

// ==================== 1. GAME MODE & SETUP SCREEN ====================
class GameModeScreen extends StatefulWidget {
  const GameModeScreen({super.key});

  @override
  State<GameModeScreen> createState() => _GameModeScreenState();
}

class _GameModeScreenState extends State<GameModeScreen> {
  final TextEditingController p1Controller = TextEditingController(text: 'Player X');
  final TextEditingController p2Controller = TextEditingController(text: 'Player O');
  int selectedLevel = 1;

  void _startGame(bool isAI) {
    if (appManager.isSoundEnabled) HapticFeedback.mediumImpact();
    appManager.playSfx();
    String p1 = p1Controller.text.trim().isEmpty ? 'Player X' : p1Controller.text.trim();
    String levelName = selectedLevel == 1 ? 'Easy (Level 1)' : (selectedLevel == 2 ? 'Medium (Level 2)' : 'Hard (Level 3)');
    String p2 = isAI ? 'AI Bot ($levelName)' : (p2Controller.text.trim().isEmpty ? 'Player O' : p2Controller.text.trim());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicTacToeGame(
          isAI: isAI,
          player1Name: p1,
          player2Name: p2,
          aiLevel: selectedLevel,
        ),
      ),
    );
  }

  void _showSetupDialog(bool isAI) {
    bool dark = appManager.isDarkMode;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: dark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            isAI ? 'Setup vs AI Bot' : 'Setup PvP Match',
            style: GoogleFonts.poppins(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: p1Controller,
                  style: GoogleFonts.poppins(color: dark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Player X Name',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6366F1))),
                  ),
                ),
                const SizedBox(height: 15),
                if (!isAI)
                  TextField(
                    controller: p2Controller,
                    style: GoogleFonts.poppins(color: dark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Player O Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6366F1))),
                    ),
                  ),
                if (isAI) ...[
                  const SizedBox(height: 15),
                  Text('Select Difficulty Level:', style: GoogleFonts.poppins(color: dark ? Colors.white70 : Colors.black87, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _LevelButton(
                        title: 'Level 1\n(Easy)',
                        isSelected: selectedLevel == 1,
                        dark: dark,
                        onTap: () => setDialogState(() => selectedLevel = 1),
                      ),
                      _LevelButton(
                        title: 'Level 2\n(Medium)',
                        isSelected: selectedLevel == 2,
                        dark: dark,
                        onTap: () => setDialogState(() => selectedLevel = 2),
                      ),
                      _LevelButton(
                        title: 'Level 3\n(Hard)',
                        isSelected: selectedLevel == 3,
                        dark: dark,
                        onTap: () => setDialogState(() => selectedLevel = 3),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
              onPressed: () {
                Navigator.pop(context);
                _startGame(isAI);
              },
              child: const Text('Start Battle', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool dark = appManager.isDarkMode;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => appManager.toggleBgm(),
                      icon: Icon(
                        appManager.isBgmEnabled ? Icons.music_note_rounded : Icons.music_off_rounded,
                        color: appManager.isBgmEnabled ? const Color(0xFF6366F1) : Colors.grey,
                      ),
                      tooltip: 'Toggle Background Music',
                    ),
                    IconButton(
                      onPressed: () => appManager.toggleSound(),
                      icon: Icon(
                        appManager.isSoundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                        color: appManager.isSoundEnabled ? const Color(0xFF6366F1) : Colors.grey,
                      ),
                      tooltip: 'Toggle Sound Effects',
                    ),
                    IconButton(
                      onPressed: () => appManager.toggleTheme(),
                      icon: Icon(
                        dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: dark ? Colors.amber : const Color(0xFF1E293B),
                      ),
                      tooltip: 'Toggle Theme',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sports_esports_rounded, size: 70, color: Color(0xFF6366F1)),
                ),
                const SizedBox(height: 20),
                Text(
                  'TIC TAC TOE',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: dark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Master Edition',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: const Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 35),
                _MenuButton(
                  title: 'Player vs Player',
                  subtitle: 'Pass & play with customizable names',
                  icon: Icons.people_alt_rounded,
                  dark: dark,
                  onTap: () => _showSetupDialog(false),
                ),
                const SizedBox(height: 20),
                _MenuButton(
                  title: 'Player vs AI Bot',
                  subtitle: 'Choose from 3 difficulty levels',
                  icon: Icons.smart_toy_rounded,
                  dark: dark,
                  onTap: () => _showSetupDialog(true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool dark;
  final VoidCallback onTap;

  const _LevelButton({required this.title, required this.isSelected, required this.dark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1) : (dark ? const Color(0xFF334155) : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? const Color(0xFF818CF8) : Colors.transparent, width: 2),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : (dark ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool dark;
  final VoidCallback onTap;

  const _MenuButton({required this.title, required this.subtitle, required this.icon, required this.dark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: dark ? const Color(0xFF334155) : Colors.grey.shade300, width: 1.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: dark ? 0.3 : 0.05), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF6366F1).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(15)),
                child: Icon(icon, color: const Color(0xFF6366F1), size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: dark ? Colors.white : const Color(0xFF0F172A))),
                    const SizedBox(height: 4),
                    Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: dark ? Colors.grey : Colors.grey.shade400, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 2. GAME PLAY SCREEN ====================
class TicTacToeGame extends StatefulWidget {
  final bool isAI;
  final String player1Name;
  final String player2Name;
  final int aiLevel;

  const TicTacToeGame({
    super.key,
    required this.isAI,
    required this.player1Name,
    required this.player2Name,
    required this.aiLevel,
  });

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  bool isGameOver = false;
  String winner = '';
  List<int> winningIndices = [];

  int scoreX = 0;
  int scoreO = 0;
  int scoreDraws = 0;

  late ConfettiController _confettiController;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (board[index] != '' || isGameOver) return;

    appManager.playSfx();

    setState(() {
      board[index] = currentPlayer;
      _checkWinner();

      if (!isGameOver) {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        if (widget.isAI && currentPlayer == 'O' && !isGameOver) {
          _aiMove();
        }
      }
    });
  }

  void _aiMove() {
    int bestMove = 0;

    if (widget.aiLevel == 1) {
      List<int> emptySpots = [];
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') emptySpots.add(i);
      }
      if (emptySpots.isNotEmpty) bestMove = emptySpots[_random.nextInt(emptySpots.length)];
    } else if (widget.aiLevel == 2) {
      if (_random.nextDouble() < 0.5) {
        bestMove = _getBestMinimaxMove();
      } else {
        List<int> emptySpots = [];
        for (int i = 0; i < 9; i++) {
          if (board[i] == '') emptySpots.add(i);
        }
        bestMove = emptySpots[_random.nextInt(emptySpots.length)];
      }
    } else {
      bestMove = _getBestMinimaxMove();
    }

    appManager.playSfx();
    setState(() {
      board[bestMove] = 'O';
      _checkWinner();
      if (!isGameOver) currentPlayer = 'X';
    });
  }

  int _getBestMinimaxMove() {
    int bestScore = -1000;
    int bestMove = 0;
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        int score = _minimax(board, 0, false);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    return bestMove;
  }

  int _minimax(List<String> newBoard, int depth, bool isMaximizing) {
    String result = _evaluateBoard(newBoard);
    if (result == 'O') return 10 - depth;
    if (result == 'X') return depth - 10;
    if (!newBoard.contains('')) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (newBoard[i] == '') {
          newBoard[i] = 'O';
          int score = _minimax(newBoard, depth + 1, false);
          newBoard[i] = '';
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (newBoard[i] == '') {
          newBoard[i] = 'X';
          int score = _minimax(newBoard, depth + 1, true);
          newBoard[i] = '';
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  String _evaluateBoard(List<String> b) {
    const wins = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var c in wins) {
      if (b[c[0]] != '' && b[c[0]] == b[c[1]] && b[c[0]] == b[c[2]]) return b[c[0]];
    }
    return '';
  }

  void _checkWinner() {
    const wins = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];

    for (var condition in wins) {
      String a = board[condition[0]];
      String b = board[condition[1]];
      String c = board[condition[2]];

      if (a != '' && a == b && a == c) {
        if (appManager.isSoundEnabled) HapticFeedback.heavyImpact();
        setState(() {
          isGameOver = true;
          winner = a;
          winningIndices = condition;
          if (winner == 'X') scoreX++; else scoreO++;
        });
        _confettiController.play();
        _showResultDialog();
        return;
      }
    }

    if (!board.contains('')) {
      if (appManager.isSoundEnabled) HapticFeedback.mediumImpact();
      setState(() {
        isGameOver = true;
        winner = 'Draw';
        scoreDraws++;
      });
      _showResultDialog();
    }
  }

  void _resetGame() {
    appManager.playSfx();
    setState(() {
      board = List.filled(9, '');
      isGameOver = false;
      winner = '';
      winningIndices = [];
      currentPlayer = 'X';
    });
  }

  void _resetScores() {
    if (appManager.isSoundEnabled) HapticFeedback.mediumImpact();
    appManager.playSfx();
    setState(() {
      scoreX = 0;
      scoreO = 0;
      scoreDraws = 0;
    });
    _resetGame();
  }

  void _showResultDialog() {
    bool dark = appManager.isDarkMode;
    String winnerName = winner == 'X' ? widget.player1Name : (winner == 'O' ? widget.player2Name : 'Nobody');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: dark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          winner == 'Draw' ? 'Match Drawn!' : '$winnerName Won!',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: dark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Text(
          winner == 'Draw' ? 'Splendid game by both!' : 'Brilliant strategic win!',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: Text('Play Again', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool dark = appManager.isDarkMode;
    String currentTurnName = currentPlayer == 'X' ? widget.player1Name : widget.player2Name;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(color: dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    appManager.playSfx();
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: dark ? Colors.white : const Color(0xFF0F172A)),
                                ),
                                Text(
                                  widget.isAI ? 'Vs Bot (Lvl ${widget.aiLevel})' : 'PvP Match',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: dark ? Colors.white : const Color(0xFF0F172A)),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: _resetScores,
                                      icon: const Icon(Icons.restart_alt_rounded, color: Colors.orangeAccent),
                                      tooltip: 'Reset Stats',
                                    ),
                                    IconButton(
                                      onPressed: _resetGame,
                                      icon: Icon(Icons.refresh_rounded, color: dark ? Colors.white : const Color(0xFF0F172A)),
                                      tooltip: 'New Round',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _ScoreCard(title: widget.player1Name, score: scoreX, color: const Color(0xFF38BDF8), dark: dark),
                                _ScoreCard(title: 'Draws', score: scoreDraws, color: Colors.grey, dark: dark),
                                _ScoreCard(title: widget.player2Name, score: scoreO, color: const Color(0xFFF43F5E), dark: dark),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: dark ? const Color(0xFF1E293B) : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: dark ? const Color(0xFF334155) : Colors.grey.shade300),
                              ),
                              child: Text(
                                'Turn: $currentTurnName ($currentPlayer)',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: currentPlayer == 'X' ? const Color(0xFF38BDF8) : const Color(0xFFF43F5E),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: MediaQuery.of(context).size.width * 0.85,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: dark ? const Color(0xFF1E293B) : Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: dark ? const Color(0xFF334155) : Colors.grey.shade300, width: 2),
                                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: dark ? 0.3 : 0.05), blurRadius: 10)],
                                    ),
                                    child: GridView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 9,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      itemBuilder: (context, index) {
                                        bool isWinningCell = winningIndices.contains(index);
                                        return GestureDetector(
                                          onTap: () => _handleTap(index),
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            decoration: BoxDecoration(
                                              color: isWinningCell
                                                  ? const Color(0xFF6366F1).withValues(alpha: 0.4)
                                                  : (dark ? const Color(0xFF334155) : Colors.grey.shade100),
                                              borderRadius: BorderRadius.circular(16),
                                              border: isWinningCell ? Border.all(color: const Color(0xFF818CF8), width: 2) : null,
                                            ),
                                            child: Center(
                                              child: Text(
                                                board[index],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 42,
                                                  fontWeight: FontWeight.bold,
                                                  color: board[index] == 'X' ? const Color(0xFF38BDF8) : const Color(0xFFF43F5E),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (isGameOver && winningIndices.length == 3)
                                    Positioned.fill(
                                      child: CustomPaint(
                                        painter: WinningLinePainter(winningIndices: winningIndices),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            gravity: 0.1,
          ),
        ],
      ),
    );
  }
}

class WinningLinePainter extends CustomPainter {
  final List<int> winningIndices;
  WinningLinePainter({required this.winningIndices});

  @override
  void paint(Canvas canvas, Size size) {
    if (winningIndices.length < 3) return;

    final paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    double cellWidth = size.width / 3;
    double cellHeight = size.height / 3;

    Offset getCenter(int index) {
      int row = index ~/ 3;
      int col = index % 3;
      return Offset(col * cellWidth + cellWidth / 2, row * cellHeight + cellHeight / 2);
    }

    Offset start = getCenter(winningIndices.first);
    Offset end = getCenter(winningIndices.last);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final int score;
  final Color color;
  final bool dark;

  const _ScoreCard({required this.title, required this.score, required this.color, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dark ? const Color(0xFF334155) : Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}