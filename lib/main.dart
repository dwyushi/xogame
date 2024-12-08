import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'dart:math';
import 'package:just_audio/just_audio.dart';

void main() => runApp(MainApp());
final AudioPlayer _audioPlayer = AudioPlayer();

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeBackgroundMusic();
  }

  Future<void> _initializeBackgroundMusic() async {
    await _audioPlayer.setAsset('/assets/sounds/background_music.mp3');
    _audioPlayer.setLoopMode(LoopMode.one); // Repeat
    _audioPlayer.play(); // Start playing
  }

//minimized
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _audioPlayer.pause(); // Pause music
    } else if (state == AppLifecycleState.resumed) {
      _audioPlayer.play(); // Resume music
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    _audioPlayer.dispose(); // Dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => _HomeScreen(),
        '/about': (context) => _AboutScreen(),
        '/play': (context) => _PlayGameScreen(),
      },
    );
  }
}

//settings dia
void _showSettingsDialog(BuildContext context, AudioPlayer audioPlayer) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(45),
        backgroundColor: Colors.transparent,
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: const Color(0xFFD7B3F0), // background color
            border: Border.all(color: Colors.black, width: 1), // stroke
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                bool isMusicEnabled = audioPlayer.playing;
                bool isSFXEnabled = true;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Settings title
                    const Center(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'KleeOne',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Music toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Music',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'KleeOne',
                              color: Colors.black),
                        ),
                        Switch(
                          value: isMusicEnabled,
                          activeColor: const Color(0xFF7A3AB2), // active
                          inactiveTrackColor:
                              const Color(0xFFFFFFFF), // inactive
                          activeTrackColor:
                              const Color(0xFFB07BE4), // active track color
                          onChanged: (value) {
                            setState(() {
                              isMusicEnabled = value;
                              if (isMusicEnabled) {
                                audioPlayer.play(); // Resume music
                              } else {
                                audioPlayer.pause(); // Mute music
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    // SFX toggle
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SFX',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'KleeOne',
                              color: Colors.black),
                        ),
                        Switch(
                          value: isSFXEnabled,
                          activeColor: const Color(0xFF7A3AB2), // active
                          inactiveTrackColor: const Color.fromARGB(
                              255, 255, 255, 255), // inactive
                          activeTrackColor:
                              const Color(0xFFB07BE4), // active track color
                          onChanged: (value) {
                            setState(() {
                              isSFXEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

// home screen
class _HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CBFF),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // About Icon
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: IconButton(
                        icon: Image.asset('assets/imgs/about.png'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/about');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),

          // Logo
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/imgs/XOGame_logo.png',
                width: 320,
                height: 320,
              ),
            ),
          ),

          // Play Button
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Center(
                child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/play');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF9474E0),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  child: Stack(
                    children: [
                      // Stroke
                      Text(
                        'PLAY',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'CooperBlack',
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.black,
                        ),
                      ),
                      // Filled
                      const Text(
                        'PLAY',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'CooperBlack',
                          color: Color(0xFFF2B1FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ),

          // Settings Button
          Positioned(
            bottom: 130,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _showSettingsDialog(context, _audioPlayer);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF694DBA),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 13),
                    child: Stack(
                      children: [
                        // Stroke
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'CooperBlack',
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.black,
                          ),
                        ),
                        // Filled
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'CooperBlack',
                            color: Color(0xFFF2B1FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// about the game
class _AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFD8CBFF),
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: [
            //strole
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width * 0.5 - 100,
              child: Text(
                'ABOUT',
                style: TextStyle(
                  fontFamily: 'CooperBlack',
                  fontSize: 40,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = const Color(0xFF25044E),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //filled
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width * 0.5 - 100,
              child: const Text(
                'ABOUT',
                style: TextStyle(
                  fontFamily: 'CooperBlack',
                  fontSize: 40,
                  color: Color.fromARGB(255, 105, 76, 162),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 120),
                  const DottedLine(
                    dashColor: Color(0xFF25044E),
                    lineThickness: 1,
                    dashLength: 5,
                    dashGapLength: 3,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'XOGAME ',
                          style: TextStyle(
                            fontFamily: 'KleeOne',
                            fontSize: 18,
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              'is a game in which two players alternately put Xs and Os in compartments of a figure formed by two vertical lines crossing two horizontal lines and each tries to get a row of three Xs or three Os before the opponent does.\n\n'
                              'The twist is there are only three Xs or Os that can be placed. A random X or O will disappear once a new one is placed. When the first player(X) is the first one to scores, the second player(O) will go first next turn. But if the second player(O) scores first, the first player(X) will still go first next turn.',
                          style: TextStyle(
                            fontFamily: 'KleeOne',
                            fontSize: 18,
                            color: Color(0xFF3F0F79),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 42, 14, 77),
                          backgroundColor: Colors.pink[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.purple[900]!),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 12),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontFamily: 'KleeOne',
                            fontSize: 18,
                            color: Color(0xFF35086D),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// game screen
class _PlayGameScreen extends StatefulWidget {
  @override
  State<_PlayGameScreen> createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<_PlayGameScreen>
    with SingleTickerProviderStateMixin {
  // Game state

  late final AudioPlayer _audioPlayer;
  List<String> board = List.filled(9, '');
  bool xTurn = true;
  int xScore = 0;
  int oScore = 0;
  List<int> winningCells = []; // Tracks the winning cells

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Reset the board
  void _resetBoard() {
    setState(() {
      board = List.filled(9, '');
      winningCells = [];
    });
  }

// Show winning dialog
  void _showWinningDialog(String winner) async {
    String nextTurn = xTurn ? 'X' : 'O';
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 52, 25, 128).withOpacity(0.5),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 200),
                      // Won text
                      Text(
                        'Player $winner won!',
                        style: const TextStyle(
                          fontSize: 40.0,
                          fontFamily: 'KleeOne',
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Next turn text
                      Text(
                        'Next turn: Player $nextTurn',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'KleeOne',
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 240),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(233, 174, 244, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 40.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _resetBoard();
                          setState(() {
                            xScore = 0;
                            oScore = 0;
                          });
                        },
                        child: Stack(
                          children: [
                            Text(
                              'Play Again',
                              style: TextStyle(
                                fontFamily: 'CooperBlack',
                                fontSize: 18,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = Colors.black,
                              ),
                            ),
                            const Text(
                              'Play Again',
                              style: TextStyle(
                                fontFamily: 'CooperBlack',
                                fontSize: 18,
                                color: Color(0xFFFFEE56),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _maintainSymbolLimit(String symbol) {
    int count = board.where((e) => e == symbol).length;

    if (count >= 3) {
      List<int> symbolIndexes = List<int>.generate(9, (index) => index)
          .where((i) => board[i] == symbol)
          .toList();

      if (symbolIndexes.isNotEmpty) {
        // Randomly select one
        int randomIndex = symbolIndexes[Random().nextInt(symbolIndexes.length)];
        setState(() {
          board[randomIndex] = ''; // Clear from the selected cell
        });
      }
    }
  }

  // Check for a winner
  void _checkWinner() async {
    const winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var condition in winConditions) {
      String a = board[condition[0]];
      String b = board[condition[1]];
      String c = board[condition[2]];

      if (a == b && b == c && a.isNotEmpty) {
        // animation
        setState(() {
          winningCells = condition;
        });

        // animation and play audio
        _controller.forward();
        try {
          await _audioPlayer.setAsset('assets/sounds/roundWin.wav');
          _audioPlayer.play();
        } catch (e) {
          print('Error playing sound: $e');
        }

        await Future.delayed(const Duration(seconds: 1));
        _controller.reset();

        // Update score
        if (a == 'X') {
          xScore++;
          if (xScore == 3) {
            _showWinningDialog('X');
          }
        } else {
          oScore++;
          if (oScore == 3) {
            _showWinningDialog('O');
          }
        }

        _resetBoard();
        return;
      }
    }

    // Checks draw
    if (!board.contains('')) _resetBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CBFF),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            // Settings button
            Positioned(
              top: 33,
              left: 0,
              child: SizedBox(
                width: 35,
                height: 35,
                child: GestureDetector(
                  onTap: () {
                    _showSettingsDialog(context, _audioPlayer);
                  },
                  child: Image.asset('assets/imgs/settings.png'),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/imgs/XOGame.png',
                      width: 150,
                    ),
                    const SizedBox(width: 20),
                    // Scoreboard
                    Container(
                      width: 150,
                      height: 120,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Wins Count',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'KleeOne',
                              color: Color.fromARGB(255, 16, 2, 107),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/imgs/X.png',
                                    width: 20,
                                  ),
                                  const Text(
                                    ':',
                                    style: TextStyle(
                                      fontFamily: 'KleeOne',
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '$xScore',
                                    style: const TextStyle(
                                      fontFamily: 'KleeOne',
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/imgs/O.png',
                                    width: 20,
                                  ),
                                  const Text(
                                    ':',
                                    style: TextStyle(
                                      fontFamily: 'KleeOne',
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '$oScore',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'KleeOne',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (board[index] == '') {
                            setState(() {
                              String symbol = xTurn ? 'X' : 'O';
                              _maintainSymbolLimit(symbol);

                              board[index] = symbol;
                              xTurn = !xTurn;
                              _checkWinner();
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: const Color.fromARGB(255, 209, 178, 255),
                          ),
                          child: Center(
                            child: board[index] == ''
                                ? const SizedBox.shrink()
                                : winningCells.contains(index)
                                    ? ScaleTransition(
                                        scale: _scaleAnimation,
                                        child: Image.asset(
                                          board[index] == 'X'
                                              ? 'assets/imgs/X.png'
                                              : 'assets/imgs/O.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                      )
                                    : Image.asset(
                                        board[index] == 'X'
                                            ? 'assets/imgs/X.png'
                                            : 'assets/imgs/O.png',
                                        width: 50,
                                        height: 50,
                                      ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
