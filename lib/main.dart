import 'package:flutter/material.dart';
import './puzzle_tile.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Slide Puzzle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _width = 4;
  final int _height = 4;
  late int _size;
  late int _lastNumIndex;
  late List<int> _list;
  late int _correct = 0;

  @override
  initState() {
    super.initState();
    _size = _width * _height;
    _lastNumIndex = _size - 1;
    _list = List.generate(_size, (index) => index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _width,
              ),
              itemCount: _size,
              itemBuilder: (context, index) {
                if (_list[index] == _size) {
                  return const PuzzleTile(number: '');
                } else {
                  return GestureDetector(
                    /** 
                       * example size 3 x 3 
                       * [0][1][2]
                       * [3][4][5]
                       * [6][7][8]
                       */
                    onVerticalDragUpdate: (details) => {
                      moveVertical(details, index),
                      tileCheck(),
                    },
                    onHorizontalDragUpdate: (details) => {
                      moveHorizontal(details, index),
                      tileCheck(),
                    },
                    child: PuzzleTile(number: _list[index].toString()),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton(
                child: const Text(
                  'Shuffle',
                  style: TextStyle(fontSize: 30),
                ),
                onPressed: () => {
                  setState(() {
                    _list.shuffle();
                    _lastNumIndex = _list.indexOf(_size);
                    tileCheck();
                  }),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Correct : $_correct / $_size',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void tileCheck() {
    setState(() {
      _correct = 0;
      for (int i = 0; i < _size; i++) {
        if (_list[i] == i + 1) {
          _correct++;
        }
      }
    });
  }

  void moveVertical(DragUpdateDetails details, int index) {
    setState(
      () {
        double dy = details.delta.dy;
        if (dy == 0 || !checkMoveVertial(index, dy)) return;
        if (dy > 0) {
          // swipe to down
          for (int i = _lastNumIndex; i > index; i -= _width) {
            _list[i] = _list[i - _width];
          }
        } else {
          // swipe to up
          for (int i = _lastNumIndex; i < index; i += _width) {
            _list[i] = _list[i + _width];
          }
        }
        _list[index] = _size;
        _lastNumIndex = index;
      },
    );
  }

  bool checkMoveVertial(int index, double dy) {
    // same column check
    if (_lastNumIndex % _width != index % _width) {
      return false;
    }
    // check row
    if (dy > 0) {
      if (_lastNumIndex > index) {
        return true;
      }
    } else {
      if (_lastNumIndex < index) {
        return true;
      }
    }
    return false;
  }

  void moveHorizontal(DragUpdateDetails details, int index) {
    setState(() {
      double dx = details.delta.dx;
      if (dx == 0 || !checkMoveHorizontal(index, dx)) return;
      if (dx > 0) {
        // swipe to right
        for (int i = _lastNumIndex; i > index; i--) {
          _list[i] = _list[i - 1];
        }
      } else {
        // swipe to left
        for (int i = _lastNumIndex; i < index; i++) {
          _list[i] = _list[i + 1];
        }
      }
      _list[index] = _size;
      _lastNumIndex = index;
    });
  }

  bool checkMoveHorizontal(int index, double dx) {
    // same row check
    if ((_lastNumIndex - (_lastNumIndex % _width)) !=
        index - (index % _width)) {
      return false;
    }
    // check column
    if (dx > 0) {
      if (_lastNumIndex > index) {
        return true;
      }
    } else {
      if (_lastNumIndex < index) {
        return true;
      }
    }
    return false;
  }
}
