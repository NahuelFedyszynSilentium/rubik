import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:transparent_pointer/transparent_pointer.dart';

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
    buildSizes = true;
    isZoomedIn = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool? buildSizes;
  bool isZoomedIn = false;
  double? containerHeight;
  double? containerWidth;
  double? initialVerticalScrollOffset;
  double? initialHorizontalScrollOffset;
  double? upMovementDistance;
  double? downMovementDistance;
  double? rightMovementDistance;
  double? leftMovementDistance;
  //Para que se ejecute la accion de swipear una vez, se desabilita al ejecutarse y se rehabilita al terminar el gesto
  bool flag = true;
  IndexedScrollController horizontalController = IndexedScrollController();
  IndexedScrollController verticalController = IndexedScrollController();

  int verticalIndex = 0;
  int horizontalIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            if (buildSizes != null && buildSizes!) setSizes(constraints);
            return _content(constraints);
          })),
    );
  }

  _content(BoxConstraints constraints) {
    verticalController = IndexedScrollController(
        initialScrollOffset: initialVerticalScrollOffset!,
        initialIndex: verticalIndex);
    horizontalController = IndexedScrollController(
        initialScrollOffset: initialHorizontalScrollOffset!,
        initialIndex: horizontalIndex);

    // if (isZoomedIn!) {
    //   adjust(controller, 100);
    // }

    return Stack(
      children: [
        AnimatedScale(
          scale: isZoomedIn ? 1 : 2.75,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          child: GestureDetector(
            onPanUpdate: (details) {
              // Swiping in up direction.
              int sensitivity = 2;
              if (details.delta.dy > sensitivity) {
                verticalIndex = swipeAction(
                  SwipeDirection.up,
                  verticalIndex,
                  verticalController,
                  upMovementDistance!,
                  initialVerticalScrollOffset!,
                );
              }

              // Swiping in down direction.
              if (details.delta.dy < -sensitivity) {
                verticalIndex = swipeAction(
                  SwipeDirection.down,
                  verticalIndex,
                  verticalController,
                  downMovementDistance!,
                  initialVerticalScrollOffset!,
                );
              }

              // Swiping in right direction.
              if (details.delta.dx < -sensitivity) {
                horizontalIndex = swipeAction(
                  SwipeDirection.right,
                  horizontalIndex,
                  horizontalController,
                  rightMovementDistance!,
                  initialHorizontalScrollOffset!,
                );
              }

              // Swiping in left direction.
              if (details.delta.dx > sensitivity) {
                horizontalIndex = swipeAction(
                  SwipeDirection.left,
                  horizontalIndex,
                  horizontalController,
                  leftMovementDistance!,
                  initialHorizontalScrollOffset!,
                );
              }
            },
            child: IndexedListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              controller: horizontalController,
              itemBuilder: (context, i) => SizedBox(
                width: containerWidth,
                child: IndexedListView.builder(
                  controller: verticalController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, j) => _child(i, j, constraints),
                ),
              ),
            ),
          ),
        ),
        TransparentPointer(
          child: Visibility(
            visible: isZoomedIn,
            child: _zoomRegion(),
          ),
        ),
      ],
    );
  }

  _child(int i, int j, BoxConstraints constraints) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onZoom,
      child: SizedBox(
        height: containerHeight,
        child: Container(
          margin: const EdgeInsets.all(5),
          alignment: Alignment.center,
          color: Colors.grey.withOpacity(1.0),
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

  int swipeAction(
    SwipeDirection swipeDirection,
    int index,
    IndexedScrollController controller,
    double moovingOffset,
    double startOffset,
  ) {
    var duration = const Duration(milliseconds: 400);

    if (flag) {
      flag = false;
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
      // Muevo los renderizados con animación
      controller
          .animateToWithSameOriginIndex(moovingOffset, duration: duration)
          .then((value) => flag = true);

      //Después muevo el resto de listas, sin animación
      Future.delayed(duration).then((value) =>
          controller.jumpToIndexAndOffset(index: index, offset: startOffset));
    }
    return index;
  }

  setSizes(BoxConstraints constraints) {
    containerHeight = constraints.maxHeight * 0.25;
    containerWidth = constraints.maxWidth * 0.30;
    initialVerticalScrollOffset = -constraints.maxHeight * 0.355;
    initialHorizontalScrollOffset = -constraints.maxWidth * 0.35;
    if (isZoomedIn) {
      upMovementDistance = -constraints.maxHeight * 0.605;
      downMovementDistance = -constraints.maxHeight * 0.105;
      rightMovementDistance = -constraints.maxWidth * 0.05;
      leftMovementDistance = -constraints.maxWidth * 0.65;
    } else {
      // initialVerticalScrollOffset = -constraints.maxHeight * 0.105;
      // initialHorizontalScrollOffset = -constraints.maxWidth * 0.1;
      upMovementDistance = -constraints.maxHeight * 0.605;
      downMovementDistance = -constraints.maxHeight * 0.105;
      rightMovementDistance = -constraints.maxWidth * 0.05;
      leftMovementDistance = -constraints.maxWidth * 0.65;
    }
  }

  _onZoom() {
    setState(() {
      isZoomedIn = !isZoomedIn;
    });
  }

  // adjust(IndexedScrollController controller, double moovingOffset) {
  //   var duration = const Duration(milliseconds: 400);
  //   controller.animateToWithSameOriginIndex(moovingOffset, duration: duration);
  // }

  ///Row and columns goes from -2 to +2, being (0,0) the center
  Widget _mouseRegion({required int row, required int column}) {
    return GestureDetector(
      onTap: () {
        _onMouseRegionTap(row: row, column: column);
      },
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 1),
        ),
      ),
    );
  }

  Widget _zoomRegion() {
    return InteractiveViewer(
      constrained: false,
      panEnabled: false,
      scaleEnabled: false,
      child: Transform.translate(
        offset: Offset(
            -(initialHorizontalScrollOffset ?? 0) - (containerWidth ?? 0) * 2,
            -(initialVerticalScrollOffset ?? 0) - (containerHeight ?? 0) * 2),
        child: Column(
          children: [
            Row(
              children: [
                _mouseRegion(column: -2, row: -2),
                _mouseRegion(column: -1, row: -2),
                _mouseRegion(column: 0, row: -2),
                _mouseRegion(column: 1, row: -2),
                _mouseRegion(column: 2, row: -2),
              ],
            ),
            Row(
              children: [
                _mouseRegion(column: -2, row: -1),
                _mouseRegion(column: -1, row: -1),
                _mouseRegion(column: 0, row: -1),
                _mouseRegion(column: 1, row: -1),
                _mouseRegion(column: 2, row: -1),
              ],
            ),
            Row(
              children: [
                _mouseRegion(column: -2, row: 0),
                _mouseRegion(column: -1, row: 0),
                _mouseRegion(column: 0, row: 0),
                _mouseRegion(column: 1, row: 0),
                _mouseRegion(column: 2, row: 0),
              ],
            ),
            Row(
              children: [
                _mouseRegion(column: -2, row: 1),
                _mouseRegion(column: -1, row: 1),
                _mouseRegion(column: 0, row: 1),
                _mouseRegion(column: 1, row: 1),
                _mouseRegion(column: 2, row: 1),
              ],
            ),
            Row(
              children: [
                _mouseRegion(column: -2, row: 2),
                _mouseRegion(column: -1, row: 2),
                _mouseRegion(column: 0, row: 2),
                _mouseRegion(column: 1, row: 2),
                _mouseRegion(column: 2, row: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onMouseRegionTap({required int row, required int column}) async {
    _horizontalScroll(column);
    _verticalScroll(row);
    // setState(() {
    //   isZoomedIn = false;
    // });
  }

  void _horizontalScroll(int column) {
    switch (column) {
      case -2:
        //Izquierda X2
        _traslateLeft(isDoubled: true);
        break;
      case -1:
        _traslateLeft();
        //Izquierda X1
        break;
      case 0:
        return;
      case 1:
        //DERECHA X1
        _traslateRight(isDoubled: false);
        break;
      case 2:
        //DERECHA X2
        _traslateRight(isDoubled: true);
        break;
      default:
        return;
    }
  }

  _traslateRight({bool isDoubled = false}) async {
    horizontalController
        .animateToWithSameOriginIndex(
            rightMovementDistance! * (isDoubled ? -5 : 1),
            duration: const Duration(milliseconds: 1000))
        .then((value) => flag = true);
    Future.delayed(const Duration(milliseconds: 1000)).then((value) =>
        horizontalController.jumpToIndexAndOffset(
            index: horizontalIndex, offset: initialHorizontalScrollOffset!));
    horizontalIndex += isDoubled ? 2 : 1;
  }

  _traslateLeft({bool isDoubled = false}) async {
    horizontalController
        .animateToWithSameOriginIndex(
            leftMovementDistance! * (isDoubled ? 1.46 : 1),
            duration: const Duration(milliseconds: 1000))
        .then((value) => flag = true);
    Future.delayed(const Duration(milliseconds: 1000)).then((value) =>
        horizontalController.jumpToIndexAndOffset(
            index: horizontalIndex, offset: initialHorizontalScrollOffset!));
    horizontalIndex -= isDoubled ? 2 : 1;
  }

  void _verticalScroll(int row) async {
    switch (row) {
      case -2:
        //ARRIBA X2
        _traslateUp(isDoubled: true);
        break;
      case -1:
        //ARRIBA X1
        _traslateUp();
        break;
      case 0:
        return;
      //ABAJO X1
      case 1:
        _traslateDown();
        break;
      case 2:
        //ABAJO X2
        _traslateDown(isDoubled: true);
        break;
      default:
        return;
    }
  }

  _traslateDown({bool isDoubled = false}) async {
    verticalController
        .animateToWithSameOriginIndex(
            downMovementDistance! * (isDoubled ? -1.38 : 1),
            duration: const Duration(milliseconds: 1000))
        .then((value) => flag = true);
    Future.delayed(const Duration(milliseconds: 1000)).then((value) =>
        verticalController.jumpToIndexAndOffset(
            index: verticalIndex, offset: initialVerticalScrollOffset!));
    verticalIndex += isDoubled ? 2 : 1;
  }

  _traslateUp({bool isDoubled = false}) async {
    verticalController
        .animateToWithSameOriginIndex(
            upMovementDistance! * (isDoubled ? 1.412 : 1),
            duration: const Duration(milliseconds: 1000))
        .then((value) => flag = true);
    Future.delayed(const Duration(milliseconds: 1000)).then((value) =>
        verticalController.jumpToIndexAndOffset(
            index: verticalIndex, offset: initialVerticalScrollOffset!));
    verticalIndex -= isDoubled ? 2 : 1;
  }
}
