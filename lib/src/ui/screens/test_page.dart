import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indexed_list_view/indexed_list_view.dart';

enum SwipeDirection { up, down, left, right }

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  final ScrollController _controller = ScrollController();
  List<String> itemList = [
    "https://i.pinimg.com/originals/ee/41/ef/ee41ef645eff8b6de1e173a252f855cd.jpg",
    "https://i.pinimg.com/originals/01/0f/6a/010f6a821b7335cf0b928235b6ebd212.jpg",
    "https://www.wallpapertip.com/wmimgs/4-43331_adidas-shoes-wallpaper-adidas-shoes.jpg",
    "https://i.pinimg.com/originals/f1/6e/26/f16e26c0a1e849bb3b9ba8143dcae27f.jpg",
    "https://i.pinimg.com/originals/01/0f/6a/010f6a821b7335cf0b928235b6ebd212.jpg",
    "https://i.pinimg.com/originals/00/e3/66/00e3665a1e04406410854083056d337c.png",
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _content(),
    ));
  }

  _child(int i, int j) {
    // double colorValue = Random().nextDouble() * 0xFFFFFF.toInt();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        color: Colors.grey.withOpacity(1.0),
        child: Center(
          // Cambiar el child para probar con imágenes
          child: Text(
            "($i,$j)",
            style: const TextStyle(color: Colors.black),
          ),
          // child: Image.network(itemList[Random().nextInt(5)])
        ),
      ),
    );
  }

  //Para que se ejecute la accion de swipear una vez, se desabilita al ejecutarse y se rehabilita al terminar el gesto
  bool flag = true;

  var verticalIndex = 0;
  var horizontalIndex = 0;

  _content() {
    var controller = IndexedScrollController(
        initialScrollOffset: -MediaQuery.of(context).size.height * 0.07);
    var controller2 = IndexedScrollController(
        initialScrollOffset: -MediaQuery.of(context).size.width * 0.1);

    return GestureDetector(
      onPanEnd: (details) => {flag = true},
      onPanUpdate: (details) {
        // Swiping in up direction.
        int sensitivity = 2;
        if (details.delta.dy > sensitivity) {
          verticalIndex = swipeAction(
            SwipeDirection.up,
            verticalIndex,
            controller,
            -MediaQuery.of(context).size.height * 0.90,
            -MediaQuery.of(context).size.height * 0.07,
          );
        }

        // Swiping in down direction.
        if (details.delta.dy < -sensitivity) {
          verticalIndex = swipeAction(
            SwipeDirection.down,
            verticalIndex,
            controller,
            MediaQuery.of(context).size.height * 0.75,
            -MediaQuery.of(context).size.height * 0.07,
          );
        }

        // Swiping in right direction.
        if (details.delta.dx < -sensitivity) {
          horizontalIndex = swipeAction(
            SwipeDirection.right,
            horizontalIndex,
            controller2,
            MediaQuery.of(context).size.width * 0.70,
            -MediaQuery.of(context).size.width * 0.1,
          );
        }

        // Swiping in left direction.
        if (details.delta.dx > sensitivity) {
          horizontalIndex = swipeAction(
            SwipeDirection.left,
            horizontalIndex,
            controller2,
            -MediaQuery.of(context).size.width * 0.90,
            -MediaQuery.of(context).size.width * 0.1,
          );
        }
      },
      child: IndexedListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        controller: controller2,
        itemBuilder: (context, i) => SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: IndexedListView.builder(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, j) => _child(i, j),
          ),
        ),
      ),
    );
  }

  int swipeAction(
    SwipeDirection swipeDirection,
    int index,
    IndexedScrollController controller,
    double moovingOffset,
    double startOffset,
  ) {
    var duration = const Duration(milliseconds: 400);

    if (flag) {
      switch (swipeDirection) {
        case SwipeDirection.up:
        case SwipeDirection.left:
          index--;
          break;
        case SwipeDirection.down:
        case SwipeDirection.right:
          index++;
          break;
        default:
          break;
      }
      flag = false;

      //Muevo los renderizados con animación
      controller.animateToWithSameOriginIndex(moovingOffset,
          duration: duration);
      //Después muevo el resto de listas, sin animación
      Future.delayed(duration).then(
        (value) => controller.animateToIndexAndOffset(
            index: index, offset: startOffset),
      );
    }
    return index;
  }
}
