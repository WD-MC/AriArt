import 'package:flutter/material.dart';

// permet d'importer les classes notament timer
import 'dart:async';

class DelayedAnimation extends StatefulWidget {

  // cree une variable pour pouvoir l'appeler dans un autre fichier
  final Widget child;
  final int delay;

  //required pour préciser que le paramètre est obligatoire  
  const DelayedAnimation ({super.key, required this.delay, required this.child });

  @override
  State<DelayedAnimation> createState() => _DelayedAnimationState();
}

// SingleTickerProviderStateMixin pour controler plusieurs  animations de manière individuelles 
class _DelayedAnimationState extends State<DelayedAnimation> 
with SingleTickerProviderStateMixin{

  // initialiser la variable du controller 
  late AnimationController _controller;
  
  // la variable offset pour préciser le comportement de l'animation
  late Animation<Offset> _animOffset;

  @override
  //gère le coeur de l'animation
  void initState(){
    super.initState();

  // initialiser le controller et vsync synchronise les animations les uns les autres
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), 
    );

    // changer le comportement de l'animation
    final curve = CurvedAnimation(
      parent: _controller , 
      curve: Curves.decelerate,
    );

    // précise le début et la fin de l'animation
    _animOffset = Tween<Offset>(
      begin: const Offset(0.0,0.5),
      end: Offset.zero,
    ).animate(curve);

    // precise le délai pour l'exécution du code et la durée d'apparition du widget
    Timer(Duration(milliseconds: widget.delay),() {
      _controller.forward();
    });

  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child, 
      ),
    );
  }
}

class DelayedAnimation1 extends StatefulWidget {

  // cree une variable pour pouvoir l'appeler dans un autre fichier
  final Widget child;
  final int delay;

  //required pour préciser que le paramètre est obligatoire  
  const DelayedAnimation1 ({super.key, required this.delay, required this.child });

  @override
  State<DelayedAnimation1> createState() => _DelayedAnimation1State();
}

// SingleTickerProviderStateMixin pour controler plusieurs  animations de manière individuelles 
class _DelayedAnimation1State extends State<DelayedAnimation1> 
with SingleTickerProviderStateMixin{

  // initialiser la variable du controller 
  late AnimationController _controller;
  
  // la variable offset pour préciser le comportement de l'animation
  late Animation<Offset> _animOffset;

  @override
  //gère le coeur de l'animation
  void initState(){
    super.initState();

  // initialiser le controller et vsync synchronise les animations les uns les autres
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), 
    );

    // changer le comportement de l'animation
    final curve = CurvedAnimation(
      parent: _controller , 
      curve: Curves.decelerate,
    );

    // précise le début et la fin de l'animation
    _animOffset = Tween<Offset>(
      begin: const Offset(0.0,5.0),
      end: Offset.zero,
    ).animate(curve);

    // precise le délai pour l'exécution du code et la durée d'apparition du widget
    Timer(Duration(milliseconds: widget.delay),() {
      _controller.forward();
    });

  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child, 
      ),
    );
  }
}