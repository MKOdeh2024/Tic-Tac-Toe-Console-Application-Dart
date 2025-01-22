import 'dart:io';
import 'dart:math';

void main() {
  final game = TicTacToe();
  game.start();
}

enum GameMode { playerVsPlayer, playerVsAI }

enum AIDifficulty { easy, medium, hard }

class TicTacToe {
  late List<String> board;
  late String playerMarker;
  late String aiMarker;
  late String currentPlayer;
  late bool gameActive;
  late GameMode gameMode;
  late AIDifficulty aiDifficulty;
  final random = Random();

  TicTacToe() {
    initializeGame();
  }

  void initializeGame() {
    board = List.generate(9, (index) => (index + 1).toString());
    gameActive = true;
    setupGame();
  }

  void setupGame() {
    print('\nSelect game mode:');
    print('1. Player vs Player');
    print('2. Player vs AI');

    int mode = getValidInput(1, 2, 'Enter mode (1-2): ');
    gameMode = mode == 1 ? GameMode.playerVsPlayer : GameMode.playerVsAI;

    if (gameMode == GameMode.playerVsAI) {
      print('\nSelect AI difficulty:');
      print('1. Easy');
      print('2. Medium');
      print('3. Hard');

      int difficulty = getValidInput(1, 3, 'Enter difficulty (1-3): ');
      aiDifficulty = AIDifficulty.values[difficulty - 1];
    }

    print('\nPlayer 1, choose your marker:');
    print('1. X');
    print('2. O');

    int marker = getValidInput(1, 2, 'Enter choice (1-2): ');
    playerMarker = marker == 1 ? 'X' : 'O';
    aiMarker = playerMarker == 'X' ? 'O' : 'X';
    currentPlayer = 'X'; // X always goes first
  }

  int getValidInput(int min, int max, String prompt) {
    while (true) {
      print(prompt);
      try {
        String? input = stdin.readLineSync();
        int value = int.parse(input!);
        if (value >= min && value <= max) return value;
        print('Please enter a number between $min and $max.');
      } catch (e) {
        print('Please enter a valid number.');
      }
    }
  }

  void start() {
    print('\nWelcome to Tic-Tac-Toe!');

    do {
      playGame();
      print('\nWould you like to play again? (y/n)');
      String? response = stdin.readLineSync()?.toLowerCase();
      if (response != 'y') break;
      initializeGame();
    } while (true);

    print('Thanks for playing!');
  }

  void playGame() {
    while (gameActive) {
      displayBoard();

      if (gameMode == GameMode.playerVsAI && currentPlayer == aiMarker) {
        makeAIMove();
      } else {
        makePlayerMove();
      }

      if (checkWinner()) {
        displayBoard();
        String winner =
            (gameMode == GameMode.playerVsAI && currentPlayer == aiMarker)
                ? 'AI'
                : 'Player $currentPlayer';
        print('\n$winner wins!');
        gameActive = false;
      } else if (isBoardFull()) {
        displayBoard();
        print('\nGame is a draw!');
        gameActive = false;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    }
  }

  void makeAIMove() {
    print('\nAI is making a move...');
    sleep(Duration(seconds: 1)); // Add slight delay for better UX

    int position;
    switch (aiDifficulty) {
      case AIDifficulty.easy:
        position = makeEasyAIMove();
        break;
      case AIDifficulty.medium:
        position = random.nextInt(10) < 7 ? makeHardAIMove() : makeEasyAIMove();
        break;
      case AIDifficulty.hard:
        position = makeHardAIMove();
        break;
    }

    board[position] = aiMarker;
  }

  int makeEasyAIMove() {
    // Randomly select an available position
    List<int> availablePositions = [];
    for (int i = 0; i < 9; i++) {
      if (board[i] != 'X' && board[i] != 'O') {
        availablePositions.add(i);
      }
    }
    return availablePositions[random.nextInt(availablePositions.length)];
  }

  int makeHardAIMove() {
    // Check for winning move
    for (int i = 0; i < 9; i++) {
      if (board[i] != 'X' && board[i] != 'O') {
        board[i] = aiMarker;
        if (checkWinner()) {
          board[i] = (i + 1).toString();
          return i;
        }
        board[i] = (i + 1).toString();
      }
    }

    // Check for blocking move
    for (int i = 0; i < 9; i++) {
      if (board[i] != 'X' && board[i] != 'O') {
        board[i] = playerMarker;
        if (checkWinner()) {
          board[i] = (i + 1).toString();
          return i;
        }
        board[i] = (i + 1).toString();
      }
    }

    // Try to take center
    if (board[4] != 'X' && board[4] != 'O') return 4;

    // Try to take corners
    List<int> corners = [0, 2, 6, 8];
    corners.shuffle();
    for (int corner in corners) {
      if (board[corner] != 'X' && board[corner] != 'O') return corner;
    }

    // Take any available position
    return makeEasyAIMove();
  }

  void makePlayerMove() {
    int? position;
    bool validInput = false;

    while (!validInput) {
      String playerName = gameMode == GameMode.playerVsPlayer
          ? 'Player $currentPlayer'
          : 'Player';
      print('\n$playerName, enter a position (1-9): ');

      try {
        String? input = stdin.readLineSync();
        position = int.parse(input!);

        if (position < 1 || position > 9) {
          print('Please enter a number between 1 and 9.');
          continue;
        }

        if (!isValidMove(position)) {
          print('That position is already taken. Please choose another.');
          continue;
        }

        validInput = true;
      } catch (e) {
        print('Please enter a valid number.');
      }
    }

    board[position! - 1] = currentPlayer;
  }

  void displayBoard() {
    print('\n');
    print(' ${board[0]} | ${board[1]} | ${board[2]} ');
    print('---+---+---');
    print(' ${board[3]} | ${board[4]} | ${board[5]} ');
    print('---+---+---');
    print(' ${board[6]} | ${board[7]} | ${board[8]} ');
  }

  bool isValidMove(int position) {
    return board[position - 1] != 'X' && board[position - 1] != 'O';
  }

  bool checkWinner() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (board[i] == board[i + 1] && board[i + 1] == board[i + 2]) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[i] == board[i + 3] && board[i + 3] == board[i + 6]) {
        return true;
      }
    }

    // Check diagonals
    if (board[0] == board[4] && board[4] == board[8]) {
      return true;
    }
    if (board[2] == board[4] && board[4] == board[6]) {
      return true;
    }

    return false;
  }

  bool isBoardFull() {
    return !board.any((cell) => cell.contains(RegExp(r'[1-9]')));
  }
}
