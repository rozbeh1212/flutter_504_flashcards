import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';
import 'package:flip_card/flip_card.dart';

import 'User.dart';
import 'LearnLaterScreen.dart';
import 'Word.dart';

class FlashcardScreen extends StatefulWidget {
  final Word word;
  final User user;

  FlashcardScreen({required this.word, required this.user});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  bool _showDefinition = false;
  bool _isBookmarked = false;
  GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  void _addToLearnLater() {
    setState(() {
      widget.user.words.add(widget.word);
      _isBookmarked = true;
    });
  }

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the scale animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    // Define the scale animation properties
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    // Start the scale animation when the card is tapped down
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    // Reverse the scale animation when the card is released
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word.word),
        actions: [
          BookmarkButton(
            isBookmarked: _isBookmarked,
            onPressed: _addToLearnLater,
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTapDown: _onTapDown, // Start scale animation on tap down
          onTapUp: _onTapUp, // Reverse scale animation on tap up
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FlipCard(
              key: _cardKey,
              direction: FlipDirection.HORIZONTAL, // Flip horizontally
              flipOnTouch: false, // Disable auto-flip on touch
              front: Card(
                child: Container(
                  width: 300,
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(widget.word.word),
                ),
              ),
              back: Card(
                child: Container(
                  width: 300,
                  height: 200,
                  alignment: Alignment.center,
                  child: Text(widget.word.definition),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookmarkButton extends StatefulWidget {
  final bool isBookmarked;
  final VoidCallback onPressed;

  BookmarkButton({required this.isBookmarked, required this.onPressed});

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and color animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() => setState(() {}));

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.indigoAccent,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBookmarked) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return IconButton(
      icon: Icon(Icons.bookmark),
      color: _colorAnimation.value,
      onPressed: widget.onPressed,
    );
  }
}
