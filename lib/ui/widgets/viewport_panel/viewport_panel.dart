import 'package:flutter/material.dart';
import 'package:gimelstudio/models/canvas_item.dart' as i;
import 'package:gimelstudio/ui/widgets/viewport_panel/viewport_panel_model.dart';
import 'package:stacked/stacked.dart';

class ViewportCanvasPainter extends CustomPainter {
  const ViewportCanvasPainter({
    required this.items,
  });

  final List<i.CanvasItem> items;

  @override
  void paint(Canvas canvas, Size size) {
    for (int index = 0; index < items.length; index++) {
      i.CanvasItem item = items[index];

      if (item.type == 'rect') {
        item = item as i.Rectangle;

        final paint = Paint()
          ..color = item.fill.solidColor.withAlpha(item.opacity)
          ..style = PaintingStyle.fill
          ..blendMode = item.blendMode;

        final rect = Rect.fromLTWH(
          item.x,
          item.y,
          item.width,
          item.height,
        );

        canvas.drawRect(rect, paint);
      } else if (item.type == 'text') {
        item = item as i.Text;

        final paint = Paint()
          ..color = item.fill.solidColor.withAlpha(item.opacity)
          ..blendMode = item.blendMode;

        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: item.text,
            style: TextStyle(
              color: item.fill.solidColor.withAlpha(item.opacity),
              fontSize: item.size,
              letterSpacing: item.letterSpacing,
            ),
          ),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: size.width - 12.0 - 12.0);

        final boxRect = RRect.fromRectAndCorners(Rect.fromLTRB(0, 0, 1920, 1080));
        canvas.saveLayer(boxRect.outerRect, paint);
        textPainter.paint(canvas, Offset(item.x, item.y));
        canvas.restore();
      }
    }

    if (items.isNotEmpty && false == true) {
      var item = items[0];
      item = item as i.Rectangle;

      // Selection overlay
      var paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      var rect = Rect.fromLTWH(
        item.x,
        item.y,
        item.width,
        item.height,
      );

      canvas.drawRect(rect, paint);

      const handleSize = 8.0;

      // Top-left
      rect = Rect.fromLTWH(
        item.x - (handleSize / 2.0),
        item.y - (handleSize / 2.0),
        handleSize,
        handleSize,
      );

      paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);

      paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);

      // Bottom-left
      rect = Rect.fromLTWH(
        item.x - (handleSize / 2.0),
        item.y + (item.height - (handleSize / 2.0)),
        handleSize,
        handleSize,
      );

      paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);

      paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);

      // Top-right
      rect = Rect.fromLTWH(
        item.x + (item.width - (handleSize / 2.0)),
        item.y - (handleSize / 2.0),
        handleSize,
        handleSize,
      );

      paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);

      paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);

      // Bottom-right
      rect = Rect.fromLTWH(
        item.x + (item.width - (handleSize / 2.0)),
        item.y + (item.height - (handleSize / 2.0)),
        handleSize,
        handleSize,
      );

      paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);

      paint = Paint()
        ..color = Colors.blueAccent
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(ViewportCanvasPainter oldDelegate) => true; // TODO
}

class CanvasWidget extends StatelessWidget {
  const CanvasWidget({
    super.key,
    required this.items,
  });

  final List<i.CanvasItem> items;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ViewportCanvasPainter(
        items: items,
      ),
    );
  }
}

class ViewportPanel extends StackedView<ViewportPanelModel> {
  const ViewportPanel({super.key});

  @override
  Widget builder(
    BuildContext context,
    ViewportPanelModel viewModel,
    Widget? child,
  ) {
    return Row(
      children: [
        InkWell(
            onTap: viewModel.handleSavePressed,
            child: Text(
              'render',
              style: TextStyle(color: Colors.white),
            )),
        Expanded(
          child: InteractiveViewer(
            minScale: 0.01,
            maxScale: 5.0,
            onInteractionStart: (ScaleStartDetails details) {
              print('Interaction started: $details');
            },
            onInteractionEnd: (ScaleEndDetails details) {
              print('Interaction ended: $details');
            },
            child: RepaintBoundary(
              child: GestureDetector(
                onPanDown: (event) => viewModel.onPanDown(event),
                onPanUpdate: (event) => viewModel.onPanUpdate(event),
                onPanCancel: () => viewModel.onPanCancel(),
                onPanEnd: (event) => viewModel.onPanEnd(event),
                child: Container(
                  width: 1920,
                  height: 1080,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all()),
                  child: CanvasWidget(items: viewModel.items),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  ViewportPanelModel viewModelBuilder(
    BuildContext context,
  ) =>
      ViewportPanelModel();
}
