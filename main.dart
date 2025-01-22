import 'dart:io';
import 'dart:math';

void main() {
  final game = TicTacToe();
  game.start();
}

class Player {
  final String name;
  String marker;
  int score = 0;
  final bool isAI;
  final AIDifficulty? difficulty;

  Player(this.name, this.marker, {this.isAI = false, this.difficulty});
}

enum GameMode { playerVsPlayer, playerVsAI }

enum AIDifficulty { easy, medium, hard }

class TicTacToe {
  late List<String> board;
  late Player player1;
  late Player player2;
  late Player currentPlayer;
  late bool gameActive;
  late GameMode gameMode;
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

    if (gameMode == GameMode.playerVsPlayer) {
      print('\nPlayer 1, enter your username:');
      String? name1 = stdin.readLineSync();
      print('\nPlayer 2, enter your username:');
      String? name2 = stdin.readLineSync();

      player1 = Player(name1 ?? 'Player 1', 'X');
      player2 = Player(name2 ?? 'Player 2', 'O');
    } else {
      print('\nPlayer 1, enter your username:');
      String? name1 = stdin.readLineSync();

      print('\nSelect AI difficulty:');
      print('1. Easy');
      print('2. Medium');
      print('3. Hard');

      int difficulty = getValidInput(1, 3, 'Enter difficulty (1-3): ');
      AIDifficulty aiDifficulty = AIDifficulty.values[difficulty - 1];

      player1 = Player(name1 ?? 'Player 1', 'X');
      player2 = Player('AI', 'O', isAI: true, difficulty: aiDifficulty);
    }

    currentPlayer = player1;
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

      if (gameMode == GameMode.playerVsAI && currentPlayer.isAI) {
        makeAIMove();
      } else {
        makePlayerMove();
      }

      if (checkWinner()) {
        displayBoard();
        print('\n${currentPlayer.name} wins!');
        gameActive = false;
      } else if (isBoardFull()) {
        displayBoard();
        print('\nGame is a draw!');
        gameActive = false;
      } else {
        currentPlayer = (currentPlayer == player1) ? player2 : player1;
      }
    }
  }

  void makeAIMove() {
    print('\nAI is making a move...');
    sleep(Duration(seconds: 1));

    int position = makeEasyAIMove(); // Placeholder for AI move logic
    board[position] = player2.marker;
  }

  int makeEasyAIMove() {
    List<int> availablePositions = [];
    for (int i = 0; i < 9; i++) {
      if (board[i] != 'X' && board[i] != 'O') {
        availablePositions.add(i);
      }
    }
    return availablePositions[random.nextInt(availablePositions.length)];
  }

  void makePlayerMove() {
    int? position;
    bool validInput = false;

    while (!validInput) {
      print('\n${currentPlayer.name}, enter a position (1-9): ');

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

    board[position! - 1] = currentPlayer.marker;
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
    for (int i = 0; i < 9; i += 3) {
      if (board[i] == board[i + 1] && board[i + 1] == board[i + 2]) {
        return true;
      }
    }
    for (int i = 0; i < 3; i++) {
      if (board[i] == board[i + 3] && board[i + 3] == board[i + 6]) {
        return true;
      }
    }
    if (board[0] == board[4] && board[4] == board[8]) return true;
    if (board[2] == board[4] && board[4] == board[6]) return true;

    return false;
  }

  bool isBoardFull() {
    return !board.any((cell) => cell.contains(RegExp(r'[1-9]')));
  }
}
