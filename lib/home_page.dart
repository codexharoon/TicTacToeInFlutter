import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe_game/custom_dialog.dart';
import 'package:tictactoe_game/game_button.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<GameButton> buttonList;

  late List<int> player1;
  late List<int> player2;
  late int activePlayer;

  @override
  void initState() {
    super.initState();
    buttonList = doInit();
  }

  List<GameButton> doInit(){

    player1 = [];
    player2 = [];
    activePlayer = 1;


    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];

    return gameButtons;
  }


  void playGame(GameButton gb){

    setState(() {

      if(activePlayer == 1){
        gb.text = 'X';
        gb.bg = Colors.red;
        player1.add(gb.id);
        activePlayer = 2;
      }
      else{
        gb.text = '0';
        gb.bg = Colors.black;
        player2.add(gb.id);
        activePlayer = 1;
      }

      gb.enabled = false;

      int winner = checkWinner();

      if(winner == -1){
        if(buttonList.every( (p) => p.text != '' )){
          showDialog(
            context: context,
            builder: (_) => CustomDialog(title: 'Game Tied', content: 'Press the Reset button to start again.', callback: resetGame, actionText: 'Reset')
          );
        }
        else{
          activePlayer == 2 ? autoPlay() : null;
        }
      }

    });

  }


  void autoPlay(){

    var emptyCells = [];
    var list = List.generate(9, (i) => i+1);

    for(var cellId in list){
      if( !(player1.contains(cellId) || player2.contains(cellId)) ){
        emptyCells.add(cellId);
      }
    }

    var r = Random();
    var randNum = r.nextInt(emptyCells.length - 1);
    var cellId = emptyCells[randNum];
    var i = buttonList.indexWhere((element) => element.id == cellId);
    playGame(buttonList[i]);
  }


  int checkWinner(){
    var winner = -1;

    //for rows 

    if(player1.contains(1) && player1.contains(2) && player1.contains(3)){
      winner = 1;
    }
    if(player2.contains(1) && player2.contains(2) && player2.contains(3)){
      winner = 2;
    }


    if(player1.contains(4) && player1.contains(5) && player1.contains(6)){
      winner = 1;
    }
    if(player2.contains(4) && player2.contains(5) && player2.contains(6)){
      winner = 2;
    }


    if(player1.contains(7) && player1.contains(8) && player1.contains(9)){
      winner = 1;
    }
    if(player2.contains(7) && player2.contains(8) && player2.contains(9)){
      winner = 2;
    }


    // for columns

    if(player1.contains(1) && player1.contains(4) && player1.contains(7)){
      winner = 1;
    }
    if(player2.contains(1) && player2.contains(4) && player2.contains(7)){
      winner = 2;
    }


    if(player1.contains(2) && player1.contains(5) && player1.contains(8)){
      winner = 1;
    }
    if(player2.contains(2) && player2.contains(5) && player2.contains(8)){
      winner = 2;
    }


    if(player1.contains(3) && player1.contains(6) && player1.contains(9)){
      winner = 1;
    }
    if(player2.contains(3) && player2.contains(6) && player2.contains(9)){
      winner = 2;
    }


    //for diagonals

    if(player1.contains(1) && player1.contains(5) && player1.contains(9)){
      winner = 1;
    }
    if(player2.contains(1) && player2.contains(5) && player2.contains(9)){
      winner = 2;
    }


    if(player1.contains(3) && player1.contains(5) && player1.contains(7)){
      winner = 1;
    }
    if(player2.contains(3) && player2.contains(5) && player2.contains(7)){
      winner = 2;
    }


    // winner

    if(winner != -1){
      if(winner == 1){
        showDialog(
          context: context,
          builder: (_) => CustomDialog(title: "Player 'X' Won!", content: 'Press the reset button to start again', callback: resetGame),
        );
      }
      else{
        showDialog(
          context: context,
          builder: (_) => CustomDialog(title: "Player '0' Won!", content: 'Press the reset button to start again', callback: resetGame),
        );
      }
    }

    return winner;

  }



  void resetGame(){

    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }

    setState(() {
      buttonList = doInit();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF3904F), Color(0xFF3B4371)])
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 108),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(  
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 9.0, 
                  ),
                  itemCount: buttonList.length,
                  itemBuilder: (context,index) => SizedBox(
                    width: 100,
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(  
                        onPressed: buttonList[index].enabled ? () => playGame(buttonList[index]) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonList[index].bg,
                          disabledBackgroundColor: buttonList[index].bg,
                        ),
                        child: Text(  
                          buttonList[index].text,
                          style: const TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ) 
                ),
              ),
            ),
            TextButton(
              onPressed: resetGame,
              child: const Text(
                'Reset Game',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0),
              )
            ),
          ],
        ),
      )
    );
  }
}