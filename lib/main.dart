import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> _board =
      List.generate(3, (_) => List.generate(3, (_) => ""));
  String _currentPlayer = "X";
  String? _winner;

  @override
  void initState() {
    super.initState();
  }

  void _togglePlayer() {
    _currentPlayer = (_currentPlayer == "X") ? "O" : "X";
  }

  void _markCell(int row, int col) {
    if (_board[row][col] == "" && _winner == null) {
      setState(() {
        _board[row][col] = _currentPlayer;
        _checkWinner();
        _togglePlayer();
      });
    }
  }

  void _checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _board[i][1] &&
          _board[i][0] == _board[i][2] &&
          _board[i][0] != "") {
        _winner = _board[i][0];
        return;
      }
      if (_board[0][i] == _board[1][i] &&
          _board[0][i] == _board[2][i] &&
          _board[0][i] != "") {
        _winner = _board[0][i];
        return;
      }
    }
    if (_board[0][0] == _board[1][1] &&
        _board[0][0] == _board[2][2] &&
        _board[0][0] != "") {
      _winner = _board[0][0];
      return;
    }
    if (_board[0][2] == _board[1][1] &&
        _board[0][2] == _board[2][0] &&
        _board[0][2] != "") {
      _winner = _board[0][2];
      return;
    }
    bool hasEmptyCell = false;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == "") {
          hasEmptyCell = true;
          break;
        }
      }
    }
    if (!hasEmptyCell) {
      _winner = "Draw";
    }
  }

  void _showRestartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content:
              Text(_winner == "Draw" ? "It's a draw!" : "Winner: $_winner"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Play Again"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ""));
      _currentPlayer = "X";
      _winner = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ 3;
                int col = index % 3;
                return GestureDetector(
                  onTap: () => _markCell(row, col),
                  child: Container(

                    color: Colors.yellow[200],
                    child: Center(
                      child: Text(
                        _board[row][col],
                        style: const TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (_winner != null) const SizedBox(height: 20),
            if (_winner != null)
              ElevatedButton(
                child: const Text("Restart"),
                onPressed: () => _showRestartDialog(context),
              ),
          ],
        ),
      ),
    );
  }
}
