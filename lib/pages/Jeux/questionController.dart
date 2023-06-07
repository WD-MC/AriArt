
//class qui gère le mécanime des questions;

import 'package:ariart/pages/Jeux/Questions.dart';
import 'package:ariart/pages/Jeux/quizz.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class QuestionController extends GetxController 
// ignore: deprecated_member_use
with SingleGetTickerProviderMixin{

  late AnimationController _animationController;
  late Animation<double> _animation;

  Animation <double> get animation => _animation;

  late PageController _pageController;
  PageController get pageController =>  _pageController;

  final List<Question> _questions = sample_data
    .map(
      (question) => Question(
        id:question['id'],
        question: question['question'],
        options: question ['options'],
        answer: question['answer_index'],
         
      )
    ).toList(); 

  List<Question> get questions => this._questions;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  late int _correctAns;
  int get correctAns => _correctAns;

  late int _selectedAns;
  int get selectedAns =>_selectedAns;

  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  late int _numCorrectAns = 0;
  int get numCorrectAns =>_numCorrectAns;


  @override
  void onInit(){
    _animationController =
      AnimationController(duration: const Duration(seconds:60), vsync: this);
      
    _animation= Tween<double>(begin: 0, end: 1).animate(_animationController)
    ..addListener(() {
      update();
    });

    _animationController.forward().whenComplete(nextQestion); 

    _pageController =PageController();
    super.onInit(); 
  } 


  @override
  void onClose(){
    super.onClose();
    _animationController.dispose();
    _pageController.dispose();
  } 

  void checkAns(Question question, int selectedIndex){
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns =selectedIndex;

    if (_correctAns == _selectedAns) _numCorrectAns++;

    _animationController.stop();
    update();

    Future.delayed(Duration(seconds: 3), (){
      _isAnswered = false;
      _pageController.nextPage(duration: Duration(milliseconds:250), curve: Curves.ease);
      
      _animationController.reset();

      _animationController.forward();
    });
  }

  void nextQestion(){
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
        duration: Duration(milliseconds: 250), curve: Curves.ease);
      
      _animationController.reset();

      _animationController.forward().whenComplete(nextQestion);
    }

    Get.to(Score());
  }

  void updateTheQnNum(int index){
    _questionNumber.value = index+1;
  }
}