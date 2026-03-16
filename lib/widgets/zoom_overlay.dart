import 'package:flutter/material.dart';

class ZoomOverlay extends StatefulWidget {
  final Widget child;

  const ZoomOverlay({super.key, required this.child});

  @override
  State<ZoomOverlay> createState() => _ZoomOverlayState();
}

class _ZoomOverlayState extends State<ZoomOverlay> with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  OverlayEntry? _overlayEntry;
  bool _isZooming = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        if (_animation != null) {
          _transformationController.value = _animation!.value;
        }
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Transparent background to capture all interactions while zooming
              if (_isZooming)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              Positioned(
                left: offset.dx,
                top: offset.dy,
                width: size.width,
                height: size.height,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  minScale: 1.0,
                  maxScale: 4.0,
                  panEnabled: true,
                  scaleEnabled: true,
                  onInteractionStart: (_) {
                    if (mounted) setState(() => _isZooming = true);
                  },
                  onInteractionEnd: (_) {
                    _resetAnimation();
                  },
                  child: widget.child,
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _resetAnimation() {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward(from: 0).then((value) {
      _removeOverlay();
      if (mounted) {
        setState(() {
          _isZooming = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // We use onLongPress or a specific trigger if scale doesn't catch
      // But InteractiveViewer inside Overlay is usually triggered by its own internal logic 
      // if we pass initial scale. However, ScaleGestureRecognizer is needed to START the overlay.
      onScaleStart: (_) {
        _showOverlay(context);
      },
      child: Opacity(
        opacity: _isZooming ? 0 : 1,
        child: widget.child,
      ),
    );
  }
}
