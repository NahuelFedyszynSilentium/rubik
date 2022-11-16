import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:video_player/video_player.dart';

enum SwipeDirection { up, down, left, right }

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  late List<VideoPlayerController> videoControllerList = [];
  List<String> itemList = [
    "https://i.pinimg.com/originals/ee/41/ef/ee41ef645eff8b6de1e173a252f855cd.jpg",
    "https://i.pinimg.com/originals/01/0f/6a/010f6a821b7335cf0b928235b6ebd212.jpg",
    "https://www.wallpapertip.com/wmimgs/4-43331_adidas-shoes-wallpaper-adidas-shoes.jpg",
    "https://i.pinimg.com/originals/f1/6e/26/f16e26c0a1e849bb3b9ba8143dcae27f.jpg",
    "https://i.pinimg.com/originals/00/e3/66/00e3665a1e04406410854083056d337c.png",
  ];

  List<String> videosList = [
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
  ];

  @override
  void initState() {
    super.initState();
    buildSizes = true;
    isZoomedIn = false;
    for (var i = 0; i < videosList.length; i++) {
      videoControllerList.add(VideoPlayerController.network(videosList[i])
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            //videoControllerList[i].play();
          });
        }));
    }
  }

  @override
  void dispose() {
    super.dispose();
    // videoControllerList.dispose();
  }

  bool? buildSizes;
  bool? isZoomedIn;
  double? containerHeight;
  double? containerWidth;
  double? initialVerticalScrollOffset;
  double? initialHorizontalScrollOffset;
  double? upMovementDistance;
  double? downMovementDistance;
  double? rightMovementDistance;
  double? leftMovementDistance;

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

  _child(int i, int j, BoxConstraints constraints) {
    // double colorValue = Random().nextDouble() * 0xFFFFFF.toInt();
    int thisIndex = getSpiralIndex(-j, i, 9);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            // videoControllerList[thisIndex].value.isPlaying
            //     ? videoControllerList[thisIndex].pause()
            //     :
            videoControllerList[thisIndex].play();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          height: containerHeight,
          color: Colors.grey.withOpacity(1.0),
          child: Center(
            // Cambiar el child para probar con imágenes
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "($i,$j)",
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 5),
                Text("${getSpiralIndex(-j, i, 10000)}"),
                const SizedBox(height: 5),
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxHeight: constraints.maxHeight / 7),
                  child: videoControllerList[thisIndex].value.isInitialized
                      ? AspectRatio(
                          aspectRatio:
                              videoControllerList[thisIndex].value.aspectRatio,
                          child: VideoPlayer(videoControllerList[thisIndex]),
                        )
                      : Container(),
                  // child: Image.network(itemList[getSpiralIndex(-j, i, 5)]),
                ),
              ],
            ),
            // child: Image.network(itemList[getSpiralIndex(-j, i, 5)]),
          ),
        ),
      ),
    );
  }

  //Para que se ejecute la accion de swipear una vez, se desabilita al ejecutarse y se rehabilita al terminar el gesto
  bool flag = true;

  var verticalIndex = 0;
  var horizontalIndex = 0;

  _content(BoxConstraints constraints) {
    var controller = IndexedScrollController(
        initialScrollOffset: initialVerticalScrollOffset!);
    var controller2 = IndexedScrollController(
        initialScrollOffset: initialHorizontalScrollOffset!);

    // if (isZoomedIn!) {
    //   adjust(controller, 100);
    // }

    return Stack(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            // Swiping in up direction.
            int sensitivity = 2;
            if (details.delta.dy > sensitivity) {
              verticalIndex = swipeAction(
                SwipeDirection.up,
                verticalIndex,
                controller,
                upMovementDistance!,
                initialVerticalScrollOffset!,
              );
            }

            // Swiping in down direction.
            if (details.delta.dy < -sensitivity) {
              verticalIndex = swipeAction(
                SwipeDirection.down,
                verticalIndex,
                controller,
                downMovementDistance!,
                initialVerticalScrollOffset!,
              );
            }

            // Swiping in right direction.
            if (details.delta.dx < -sensitivity) {
              horizontalIndex = swipeAction(
                SwipeDirection.right,
                horizontalIndex,
                controller2,
                rightMovementDistance!,
                initialHorizontalScrollOffset!,
              );
            }

            // Swiping in left direction.
            if (details.delta.dx > sensitivity) {
              horizontalIndex = swipeAction(
                SwipeDirection.left,
                horizontalIndex,
                controller2,
                leftMovementDistance!,
                initialHorizontalScrollOffset!,
              );
            }
          },
          child: IndexedListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            controller: controller2,
            itemBuilder: (context, i) => SizedBox(
              width: containerWidth,
              child: IndexedListView.builder(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, j) => _child(i, -j, constraints),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 25,
          right: 25,
          child: FloatingActionButton(
            onPressed: () {
              // videoControllerList.play();
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
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
    // if (!isZoomedIn!) {
    containerHeight = constraints.maxHeight * 0.25;
    containerWidth = constraints.maxWidth * 0.30;
    initialVerticalScrollOffset = -constraints.maxHeight * 0.355;
    initialHorizontalScrollOffset = -constraints.maxWidth * 0.35;
    upMovementDistance = -constraints.maxHeight * 0.635;
    downMovementDistance = -constraints.maxHeight * 0.075;
    rightMovementDistance = -constraints.maxWidth * 0.05;
    leftMovementDistance = -constraints.maxWidth * 0.65;
    // } else {
    //   containerHeight = constraints.maxHeight * 0.75;
    //   containerWidth = constraints.maxWidth * 0.80;
    //   initialVerticalScrollOffset = -constraints.maxHeight * 0.105;
    //   initialHorizontalScrollOffset = -constraints.maxWidth * 0.1;
    //   upMovementDistance = -constraints.maxHeight * 0.88;
    //   downMovementDistance = constraints.maxHeight * 0.68;
    //   rightMovementDistance = constraints.maxWidth * 0.7;
    //   leftMovementDistance = -constraints.maxWidth * 0.9;
    // }
    // isZoomedIn = !isZoomedIn!;
  }

  // adjust(IndexedScrollController controller, double moovingOffset) {
  //   var duration = const Duration(milliseconds: 400);
  //   controller.animateToWithSameOriginIndex(moovingOffset, duration: duration);
  // }

  getSpiralIndex(int X, int Y, int listMax) {
    // Algoritmo de https://superzhu.gitbooks.io/bigdata/content/algo/get_spiral_index_from_location.html
    int index = 0;

    if (X * X >= Y * Y) {
      index = 4 * X * X - X - Y;
      if (X < Y) {
        index = index - 2 * (X - Y);
      }
    } else {
      index = 4 * Y * Y - X - Y;
      if (X < Y) {
        index = index + 2 * (X - Y);
      }
    }
    return index % listMax;
  }
}
