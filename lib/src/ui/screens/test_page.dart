import 'dart:developer' as dev;
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
  late IndexedScrollController verticalController;
  late IndexedScrollController horizontalController;
  late double _cardHeight;
  late double _cardWidth;
  late BoxConstraints _viewportConstraints;
  //Para que se ejecute la accion de swipear una vez, se desabilita al ejecutarse y se rehabilita al terminar el gesto
  bool _flag = true;
  int _verticalIndex = 0;
  int _horizontalIndex = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            _calculateValues(constraints);
            return _content();
          },
        ),
      ),
    );
  }

  void _calculateValues(BoxConstraints constraints) {
    _cardHeight = constraints.maxHeight * 0.25;
    _cardWidth = constraints.maxWidth * 0.25;
    _viewportConstraints = constraints;
    horizontalController = IndexedScrollController(
        keepScrollOffset: true, initialScrollOffset: _cardWidth / 2);
    verticalController = IndexedScrollController(
        keepScrollOffset: true, initialScrollOffset: _cardHeight / 2);
  }

  _content() {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      // onHorizontalDragUpdate: _onHorizontalDragUpdate,
      // onHorizontalDragDown: (details) => {_flag = true},
      // onVerticalDragUpdate: _onVerticalDragUpdate,
      // onVerticalDragEnd: (details) => {_flag = true},
      child: IndexedListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        controller: horizontalController,
        itemBuilder: (context, i) => SizedBox(
          width: _cardWidth,
          child: IndexedListView.builder(
            controller: verticalController,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, j) => _card(i, j),
          ),
        ),
      ),
    );
  }

  _card(int i, int j) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      height: _cardHeight,
      child: Container(
        margin: const EdgeInsets.all(3),
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey.withOpacity(1.0),
        alignment: Alignment.center,
        child: Text(
          "($i,$j)",
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  // void _onHorizontalDragUpdate(DragUpdateDetails details) {
  //   if (details.primaryDelta != null && details.primaryDelta! > 0) {
  //     //Arrastre hacia la izquierda
  //     _horizontalIndex = swipeAction(
  //       SwipeDirection.left,
  //       _horizontalIndex,
  //       horizontalController,
  //       -(_cardWidth / 2),
  //       -(_cardWidth / 2),
  //     );
  //   } else if (details.primaryDelta != null && details.primaryDelta! < 0) {
  //     //Arrastre hacia la derecha
  //     _horizontalIndex = swipeAction(
  //       SwipeDirection.right,
  //       _horizontalIndex,
  //       horizontalController,
  //       (_cardWidth / 2),
  //       -(_cardWidth / 2),
  //     );
  //   } else {
  //     return;
  //   }
  // }

  // void _onVerticalDragUpdate(DragUpdateDetails details) {
  //   if (details.primaryDelta != null && details.primaryDelta! > 0) {
  //     //Arrastre hacia arriba
  //     _verticalIndex = swipeAction(
  //       SwipeDirection.up,
  //       _verticalIndex,
  //       verticalController,
  //       -(_cardHeight / 2),
  //       -(_cardHeight / 2),
  //     );
  //   } else if (details.primaryDelta != null && details.primaryDelta! < 0) {
  //     //Arrastre hacia abajo
  //     _verticalIndex = swipeAction(
  //       SwipeDirection.down,
  //       _verticalIndex,
  //       verticalController,
  //       (_cardHeight / 2),
  //       -(_cardHeight / 2),
  //     );
  //   } else {
  //     return;
  //   }
  // }

  int swipeAction(
    SwipeDirection swipeDirection,
    int index,
    IndexedScrollController controller,
    double moovingOffset,
    double startOffset,
  ) {
    Duration duration = const Duration(milliseconds: 400);

    if (_flag) {
      switch (swipeDirection) {
        case SwipeDirection.up:
        case SwipeDirection.left:
          index--;
          break;
        case SwipeDirection.down:
          break;
        case SwipeDirection.right:
          index++;
          break;
        default:
          break;
      }

      _flag = false;
      //Muevo los renderizados con animación
      controller
          .animateToWithSameOriginIndex(moovingOffset, duration: duration)
          .then((value) => _flag = true);

      //Después muevo el resto de listas, sin animación
      Future.delayed(duration).then((value) =>
          controller.jumpToIndexAndOffset(index: index, offset: startOffset));
    }
    return index;
  }

  _onPanUpdate(DragUpdateDetails details) {
    // Swiping in up direction.
    int sensitivity = 2;
    if (details.delta.dy > sensitivity) {
      _verticalIndex = swipeAction(
        SwipeDirection.up,
        _verticalIndex,
        verticalController,
        -(_cardHeight / 2),
        _cardHeight / 2,
      );
    }

    // Swiping in down direction.
    if (details.delta.dy < -sensitivity) {
      _verticalIndex = swipeAction(
        SwipeDirection.down,
        _verticalIndex,
        verticalController,
        _cardHeight / 2,
        -_cardHeight / 2,
      );
    }

    // Swiping in right direction.
    if (details.delta.dx < -sensitivity) {
      _horizontalIndex = swipeAction(
        SwipeDirection.right,
        _horizontalIndex,
        horizontalController,
        _cardWidth / 2,
        -_cardWidth / 2,
      );
    }

    // Swiping in left direction.
    if (details.delta.dx > sensitivity) {
      _horizontalIndex = swipeAction(
        SwipeDirection.left,
        _horizontalIndex,
        horizontalController,
        -_cardWidth / 2,
        _cardWidth / 2,
      );
    }
  }
}
