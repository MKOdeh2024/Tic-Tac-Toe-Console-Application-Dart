# Dart Console Tic-Tac-Toe Game

A feature-rich implementation of the classic Tic-Tac-Toe game in Dart, featuring both player-vs-player and player-vs-AI modes with multiple difficulty levels.

## Features

- Two game modes:
  - Player vs Player
  - Player vs AI
- Three AI difficulty levels:
  - Easy: Makes random moves
  - Medium: Combines random and strategic moves
  - Hard: Uses strategic algorithm for optimal play
- Customizable player markers (X or O)
- Score tracking across multiple games
- Clear console interface
- Input validation and error handling
- Cross-platform compatibility

## Requirements

- Dart SDK (version 2.12.0 or higher)

## Installation

1. Install Dart SDK:
   - Windows: Download from [dart.dev](https://dart.dev/get-dart)
   - macOS: `brew install dart`
   - Linux: `sudo apt-get install dart`

2. Clone or download the source code
3. Navigate to the project directory

## Running the Game

Execute the following command in your terminal:
```bash
dart run main.dart
```

## How to Play

1. Select game mode:
   - Player vs Player
   - Player vs AI

2. If playing against AI, choose difficulty level:
   - Easy: Random moves
   - Medium: Mix of random and strategic moves
   - Hard: Strategic gameplay

3. Enter player names and choose markers (X or O)

4. Take turns placing markers on the board using numbers 1-9:
   ```
    1 | 2 | 3 
   ---+---+---
    4 | 5 | 6 
   ---+---+---
    7 | 8 | 9 
   ```

5. Win by getting three markers in a row (horizontally, vertically, or diagonally)

## AI Strategy

- Easy: Makes completely random moves
- Medium: 70% chance of making a strategic move, 30% chance of making a random move
- Hard: Uses the following strategy:
  1. Looks for winning moves
  2. Blocks opponent's winning moves
  3. Takes center position if available
  4. Takes corner positions
  5. Takes any available position

## Game Controls

- Enter numbers 1-9 to place markers
- Enter 'y' to play again after a game ends
- Enter 'n' to quit after a game ends

## Contributing

Feel free to fork this repository and submit pull requests with improvements or bug fixes.

## License

This project is open source and available under the MIT License.