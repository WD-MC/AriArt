
import 'package:ariart/pages/Jeux/Questions.dart';
import 'package:ariart/pages/Jeux/questionController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';



class Quizz extends StatelessWidget {
  const Quizz({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.put(QuestionController()); 
    QuestionController controller = Get.put(QuestionController());
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: 
          
           IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color:Color.fromARGB(255, 0, 0, 0),
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),

      ),
      body: Stack(
        children: [
          
          // Image.asset('assets/images/quiz-background-1024x576.png'),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child:ProgressBar() ,
                  ),

                  const SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:Obx(() => 
                    Text.rich(
                      TextSpan(
                        text:"Question ${questionController.questionNumber.value}",
                        style: Theme.of(context)
                          .textTheme.headline5
                          ?.copyWith(color: Colors.black
                        ),
                        children: [
                          TextSpan(
                          text:"/${questionController.questions.length}",
                          style: Theme.of(context)
                            .textTheme.headline6
                            ?.copyWith(color: Colors.black),
                          )
                        ]
                      )
                    )) 
                  ),

                  const Divider(color:Color.fromARGB(179, 114, 109, 109)),
                  Expanded(
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: questionController.pageController,
                      onPageChanged: questionController.updateTheQnNum,
                      itemCount: questionController.questions.length,
                      itemBuilder: (context, index) => QuestionCard(question: questionController.questions[index],),
                    )
                  )
                  
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}


class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(50)
      ),
      child: GetBuilder<QuestionController>(
        init: QuestionController(),
        builder: (controller) {
          double sec = (controller.animation.value*60).roundToDouble();
          return Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) =>Container(
                  width: constraints.maxWidth*controller.animation.value,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade800, Colors.amber.shade600],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(50), 
                  ),
                )
                
              ),
              Positioned.fill(
                child:Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$sec secondes'),
                      const Icon(Icons.timer_outlined),   
                    ],
                  ),
                ) 
              )
            ],
          );
        }
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {

  final Question question;
  const QuestionCard({Key? key, required this.question,}):super(key:key);

  
  @override
  Widget build(BuildContext context) {
    QuestionController controller = Get.put(QuestionController());
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        
      ),
      child: Column(
        children: [
          Text(
            question.question,
            style: Theme.of(context)
            .textTheme.headline6
            ?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 30,),
          ...List.generate(
            question.options.length, 
            (index) => Option(
               
              index: index,
              text: question.options[index], 
              press: () => controller.checkAns(question, index),
            )), 
          
        ],    
      )
    );
  }
}


class Option extends StatelessWidget {
  const Option({super.key, required this.text, required this.index, required this.press});


  final String text;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      init: QuestionController(),
      builder: (qnController) {

        Color getTheRightColor(){
          if (qnController.isAnswered) {
            if (index == qnController.correctAns) {
              return Colors.green;
            }else if(index == qnController.selectedAns && qnController.selectedAns != qnController.correctAns){
              return Colors.red;
            }
          }
          return Colors.grey;
        }

        IconData getTheRigthIcon(){
          return getTheRightColor() == Colors.red
          ?Icons.close
          :Icons.done;
        }

        return InkWell(
          onTap: press,
          child:Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            //color: getTheRightColor(),
            border: Border.all(color: getTheRightColor()),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${index +1}. $text",
                style: TextStyle(
                  color:getTheRightColor(),
                  fontSize: 16
                ),
              ),
              Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                  color: getTheRightColor() == Colors.grey
                  ?Colors.transparent
                  :getTheRightColor(),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: getTheRightColor())
                ),
                child:getTheRightColor() == Colors.grey
                ? null
                : Icon(getTheRigthIcon(), size: 16,) ,
              )
            ],
          ),
        ));
      }
    );
  }
}



class Score extends StatelessWidget {
  const Score({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionController qnController = Get.put(QuestionController());
    return Scaffold(
      body:Column(
        
        children: [
          const Spacer(flex: 3,),
          Text("Score",
            style: Theme.of(context)
            .textTheme
            .headline3
            ?.copyWith(color:Colors.amber),
          ),
          const Spacer(),
          Text("${qnController.correctAns*10}/${qnController.questions.length*10}",
            style: Theme.of(context)
            .textTheme
            .headline4
            ?.copyWith(color:Colors.amber),
          ),
          const Spacer(flex: 3,)
        ],
      )
    );
  }
}