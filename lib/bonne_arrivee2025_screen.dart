import 'dart:math';

import 'package:flutter/material.dart';
import 'package:happy_new_year_2025/explosion_effect.dart';

class BonneArrivee2025Screen extends StatefulWidget {
  const BonneArrivee2025Screen({super.key});

  @override
  _BonneArrivee2025ScreenState createState() => _BonneArrivee2025ScreenState();
}

class _BonneArrivee2025ScreenState extends State<BonneArrivee2025Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation4Move;
  late Animation<double> _animation5;
  late Animation<double> _textMoveAnimation;
  bool _showExplosion = false;
  bool _showOtherExplosion = false;
  List<Offset> _explosionPositions = [];
  late double screenWidth;
  late double screenHeight;
  bool _showMessage = false;
  late String _displayedText;
  late int _currentCharIndex;
  late int _textLength;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation4Move = Tween<double>(begin: 0, end: -100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _animation5 = Tween<double>(begin: 100, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _textMoveAnimation = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showExplosion = true;
          _explosionPositions = _generateExplosionPositions();
        });

        // Délai pour faire apparaître les explosions séquentiellement
        _triggerSequentialExplosions();

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showMessage = true;
              _displayedText = "";
              _currentCharIndex = 0;
              _textLength = "Bonne année 2025 !".length;
            });
            _animateText();
          }
        });
      }
    });
  }

  void _triggerSequentialExplosions() {
    for (int i = 0; i < _explosionPositions.length; i++) {
      Future.delayed(Duration(milliseconds: 300 * i), () {
        if (mounted) {
          setState(() {
            _showOtherExplosion = true;
          });
        }
      });
    }
  }

  void _animateText() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_currentCharIndex < _textLength) {
        setState(() {
          _displayedText += "Bonne année 2025 !"[_currentCharIndex];
          _currentCharIndex++;
        });
        _animateText();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_showOtherExplosion)
            ..._explosionPositions.map((position) => Positioned(
                  left: position.dx,
                  top: position.dy,
                  child: const ExplosionEffect(),
                )),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "202",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cursive',
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (!_showExplosion)
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _animation4Move.value),
                                  child: Text(
                                    "4",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cursive',
                                      letterSpacing: 2.0,
                                      shadows: [
                                        Shadow(
                                          offset: const Offset(2.0, 2.0),
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          if (_showExplosion)
                            const Positioned(
                              top: -50,
                              child: ExplosionEffect(),
                            ),
                          AnimatedBuilder(
                            animation: _animation5,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _animation5.value),
                                child: Text(
                                  "5",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cursive',
                                    letterSpacing: 2.0,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(2.0, 2.0),
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_showMessage)
                  Positioned(
                    bottom: 70,
                    left: screenWidth / 2 - 150,
                    child: Text(
                      _displayedText,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cursive',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Offset> _generateExplosionPositions() {
    return List.generate(50, (index) {
      final dx = Random().nextDouble() * screenWidth;
      final dy = Random().nextDouble() * screenHeight;
      return Offset(dx, dy);
    });
  }
}
