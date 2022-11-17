import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:transparent_pointer/transparent_pointer.dart';
import 'package:video_player/video_player.dart';

enum SwipeDirection { up, down, left, right }

class RubikComponent extends StatefulWidget {
  RubikComponent({
    Key? key,
    this.rubikController,
    // required this.itemList,
    //TODO: Quitar lista hardcodeada
    this.itemList = const [
      "https://i.pinimg.com/originals/ee/41/ef/ee41ef645eff8b6de1e173a252f855cd.jpg",
      "https://i.pinimg.com/originals/01/0f/6a/010f6a821b7335cf0b928235b6ebd212.jpg",
      "https://www.wallpapertip.com/wmimgs/4-43331_adidas-shoes-wallpaper-adidas-shoes.jpg",
      "https://i.pinimg.com/originals/f1/6e/26/f16e26c0a1e849bb3b9ba8143dcae27f.jpg",
      "https://i.pinimg.com/originals/00/e3/66/00e3665a1e04406410854083056d337c.png",
    ],
  }) : super(key: key);

  RubikController? rubikController;

  List<String> itemList;
  // List<String> videosList = [
  //   'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
  //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
  //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
  //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
  //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
  //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
  //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
  // ];

  @override
  RubikComponentState createState() => RubikComponentState();
}

class RubikComponentState extends State<RubikComponent>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _rubikController = widget.rubikController ?? RubikController();
    _rubikController._getIndexOfCenter = _getIndexOfCenter;
    buildSizes = true;
    // for (var i = 0; i < videosList.length; i++) {
    //   videoControllerList.add(VideoPlayerController.network(videosList[i])
    //     ..initialize().then((_) {
    //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //       setState(() {
    //         //videoControllerList[i].play();
    //       });
    //     }));
    // }
  }

  int _getIndexOfCenter() {
    return getSpiralIndex(
        verticalIndex, horizontalIndex, widget.itemList.length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );
  late final Animation<double> _animation = Tween(
    begin: 1.0,
    end: 2.75,
  ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  // late List<VideoPlayerController> videoControllerList = [];

  late RubikController _rubikController;
  bool? buildSizes;
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
  bool isZoomingIn = false;

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

    return Stack(
      children: [
        _zoomRegion(),
        TransparentPointer(
          child: ScaleTransition(
            scale: _animation,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: _zoomOut,
              onPanUpdate: (details) {
                // Swiping in up direction.
                int sensitivity = 0;
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
                    itemBuilder: (context, j) => _child(i, -j, constraints),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _child(int i, int j, BoxConstraints constraints) {
    return Container(
      height: containerHeight,
      width: containerWidth,
      // margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      color: Colors.grey.withOpacity(1.0),
      // Cambiar el child para probar con imágenes
      child: CachedNetworkImage(
        imageUrl:
            widget.itemList[getSpiralIndex(-j, i, widget.itemList.length)],
        fit: BoxFit.fill,
      ),
      // child: Image.network(itemList[Random().nextInt(5)])
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

    if (flag && !isZoomingIn) {
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
    containerHeight = constraints.maxHeight * 0.30;
    containerWidth = constraints.maxWidth * 0.30;
    initialVerticalScrollOffset = -constraints.maxHeight * 0.355;
    initialHorizontalScrollOffset = -constraints.maxWidth * 0.35;
    upMovementDistance = -constraints.maxHeight * 0.655;
    downMovementDistance = -constraints.maxHeight * 0.055;
    rightMovementDistance = -constraints.maxWidth * 0.05;
    leftMovementDistance = -constraints.maxWidth * 0.65;
  }

  ///Row and columns goes from -2 to +2, being (0,0) the center
  Widget _mouseRegion({required int row, required int column}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _rubikController.isZoomedIn
            ? () {}
            : _onMouseRegionTap(row: row, column: column);
      },
      child: SizedBox(
        height: containerHeight,
        width: containerWidth,
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
    if (!flag) {
      return;
    }
    isZoomingIn = true;
    _horizontalScroll(column);
    _verticalScroll(row);
    await _animationController.forward();
    isZoomingIn = false;
    _rubikController._isZoomedIn = true;
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
            duration: const Duration(milliseconds: 600))
        .then((value) => flag = true);
    Future.delayed(const Duration(milliseconds: 600)).then((value) =>
        horizontalController.jumpToIndexAndOffset(
            index: horizontalIndex, offset: initialHorizontalScrollOffset!));
    horizontalIndex += isDoubled ? 2 : 1;
  }

  _traslateLeft({bool isDoubled = false}) async {
    horizontalController
        .animateToWithSameOriginIndex(
            leftMovementDistance! * (isDoubled ? 1.46 : 1),
            duration: const Duration(milliseconds: 600))
        .then((value) => flag = true);
    Future.delayed(const Duration(milliseconds: 600)).then((value) =>
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
            downMovementDistance! * (isDoubled ? -4.45 : 1),
            duration: const Duration(milliseconds: 600))
        .then((value) => flag = true);
    Future.delayed(const Duration(milliseconds: 600)).then((value) =>
        verticalController.jumpToIndexAndOffset(
            index: verticalIndex, offset: initialVerticalScrollOffset!));
    verticalIndex += isDoubled ? 2 : 1;
  }

  _traslateUp({bool isDoubled = false}) async {
    verticalController
        .animateToWithSameOriginIndex(
            upMovementDistance! * (isDoubled ? 1.46 : 1),
            duration: const Duration(milliseconds: 600))
        .then((value) => flag = true);
    Future.delayed(const Duration(milliseconds: 600)).then((value) =>
        verticalController.jumpToIndexAndOffset(
            index: verticalIndex, offset: initialVerticalScrollOffset!));
    verticalIndex -= isDoubled ? 2 : 1;
  }

  void _zoomOut() {
    _animationController.reverse();
    _rubikController._isZoomedIn = false;
  }

  int getSpiralIndex(int x, int y, int listMax) {
    // Algoritmo de https://superzhu.gitbooks.io/bigdata/content/algo/get_spiral_index_from_location.html
    int index = 0;

    if (x * x >= y * y) {
      index = 4 * x * x - x - y;
      if (x < y) {
        index = index - 2 * (x - y);
      }
    } else {
      index = 4 * y * y - x - y;
      if (x < y) {
        index = index + 2 * (x - y);
      }
    }
    return index % listMax;
  }
}

class RubikController {
  RubikController();
  bool _isZoomedIn = false;
  bool get isZoomedIn => _isZoomedIn;

  int Function()? _getIndexOfCenter;
  int get indexOfCenter => _getIndexOfCenter!();
}
