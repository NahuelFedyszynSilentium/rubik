import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../../values/k_colors.dart';
import '../../utils/page_args.dart';
import '../screen_controllers/home_page_controller.dart';

enum HorizontalDrag {
  left,
  rigth,
}

enum VerticalDrag {
  up,
  down,
}

class HomePage extends StatefulWidget {
  final PageArgs? args;
  const HomePage(this.args, {super.key});

  @override
  _HomePagePageState createState() => _HomePagePageState(args);
}

class _HomePagePageState extends StateMVC<HomePage> {
  late HomePageController _con;
  PageArgs? args;
  TransformationController _controller = TransformationController();

  _HomePagePageState(PageArgs? _args) : super(HomePageController(_args)) {
    _con = HomePageController.con;
    args = _args;
  }

  @override
  void initState() {
    _con.initPage(arguments: args);
    _controller.addListener(_onControllerUpdate);
    super.initState();
  }

  static const int _rowCount = 50;
  static const int _columnCount = 50;
  late double _cellWidth;
  late double _cellHeight;
  Quad? _cachedVieport;
  late int _firstVisibleColumn;
  late int _firstVisibleRow;
  late int _lastVisibleColumn;
  late int _lastVisibleRow;
  Offset _lastKnownPoint = Offset.zero;
  bool _stillPointing = false;
  Size? viewport;

  bool _isWidgetVisible(int row, int column, Quad viewport) {
    if (viewport != _cachedVieport) {
      final Rect aabb = axisAlignedBoundingBox(viewport);
      _cachedVieport = viewport;
      _firstVisibleRow = (aabb.top / _cellHeight).floor();
      _firstVisibleColumn = (aabb.left / _cellWidth).floor();
      _lastVisibleRow = (aabb.bottom / _cellHeight).floor();
      _lastVisibleColumn = (aabb.right / _cellWidth).floor();
    }
    return row >= _firstVisibleRow - 1 &&
        row <= _lastVisibleRow + 1 &&
        column >= _firstVisibleColumn - 2 &&
        column <= _lastVisibleColumn + 2;
  }

  @override
  Widget build(BuildContext context) {
    viewport ??= MediaQuery.of(context).size;
    _cellHeight = MediaQuery.of(context).size.height * 0.25;
    _cellWidth = MediaQuery.of(context).size.width * 0.25;
    return SafeArea(
      child: Scaffold(
        backgroundColor: KGrey,
        body: GestureDetector(
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          child: InteractiveViewer.builder(
            builder: (
              context,
              Quad viewport,
            ) {
              return _builder(viewport);
            },
            alignPanAxis: true,
            transformationController: _controller,
            scaleEnabled: false,
            onInteractionEnd: _onInteractionEnd,
            onInteractionStart: _onInteractionStart,
            onInteractionUpdate: _onInteractionUpdate,
            clipBehavior: Clip.hardEdge,
            panEnabled: false,
          ),
        ),
      ),
    );
  }

  _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _controller.value.translate(0.0, details.primaryDelta ?? 0 * 0.01);
    });
  }

  _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _controller.value.translate(details.primaryDelta ?? 0 * 0.01, 0.0);
    });
  }

  _onZoom(int region) {
    switch (region) {
      case 0:

      case 1:

      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      default:
        return;
    }
  }

  HorizontalDrag? _acceptHorizontalScroll(Offset offset) {
    return null;
  }

  VerticalDrag? _acceptVerticalScroll(Offset offset) {
    return null;
  }

  _onInteractionEnd(ScaleEndDetails details) {
    _stillPointing = false;
    log(_controller.toScene(_lastKnownPoint).toString());
  }

  _onInteractionUpdate(ScaleUpdateDetails details) {
    _lastKnownPoint = details.focalPoint;
  }

  _onInteractionStart(ScaleStartDetails details) {}

  void _onControllerUpdate() {}

  Widget _builder(Quad viewport) {
    return Column(
      children: <Widget>[
        for (int row = 0; row < _rowCount; row++)
          Row(
            children: <Widget>[
              for (int column = 0; column < _columnCount; column++)
                _element(
                  _isWidgetVisible(row, column, viewport),
                ),
            ],
          )
      ],
    );
  }

  Widget _element(bool isVisible) {
    return Container(
      margin: const EdgeInsets.all(3),
      height: _cellHeight,
      width: _cellWidth,
      child: isVisible
          ? CachedNetworkImage(
              imageUrl:
                  "https://keybiscaynear.vteximg.com.br/arquivos/ids/164545-427-636/zapatillas1.jpg?v=637901438044230000",
              fit: BoxFit.cover,
            )
          : null,
    );
  }

  // Returns the axis aligned bounding box for the given Quad, which might not
// be axis aligned.
  Rect axisAlignedBoundingBox(Quad quad) {
    double? xMin;
    double? xMax;
    double? yMin;
    double? yMax;
    for (final Vector3 point in <Vector3>[
      quad.point0,
      quad.point1,
      quad.point2,
      quad.point3
    ]) {
      if (xMin == null || point.x < xMin) {
        xMin = point.x;
      }
      if (xMax == null || point.x > xMax) {
        xMax = point.x;
      }
      if (yMin == null || point.y < yMin) {
        yMin = point.y;
      }
      if (yMax == null || point.y > yMax) {
        yMax = point.y;
      }
    }
    return Rect.fromLTRB(xMin!, yMin!, xMax!, yMax!);
  }
}
