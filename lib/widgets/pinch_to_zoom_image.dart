import 'package:flutter/material.dart';

class PinchToZoomImage extends StatefulWidget {
  final Widget child;

  const PinchToZoomImage({super.key, required this.child});

  @override
  State<PinchToZoomImage> createState() => _PinchToZoomImageState();
}

class _PinchToZoomImageState extends State<PinchToZoomImage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Matrix4> _animation;
  OverlayEntry? _overlayEntry;
  Matrix4 _matrix = Matrix4.identity();
  bool _isZooming = false;

  // Track the focal point and scale for manual calculations
  Offset _lastFocalPoint = Offset.zero;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  Offset _translation = Offset.zero;
  Offset _baseTranslation = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Matrix4Tween(
      begin: Matrix4.identity(),
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.addListener(() {
      _overlayEntry?.markNeedsBuild();
    });
  }

  @override
  void dispose() {
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
        // Use the animated matrix if the animation is running
        final displayMatrix = _animationController.isAnimating ? _animation.value : _matrix;

        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Darken background slightly when zooming
              if (_isZooming)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.2 * (displayMatrix.getMaxScaleOnAxis() - 1.0).clamp(0.0, 1.0)),
                  ),
                ),
              Positioned(
                left: offset.dx,
                top: offset.dy,
                width: size.width,
                height: size.height,
                child: Transform(
                  transform: displayMatrix,
                  alignment: FractionalOffset.center,
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

  void _onScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.localFocalPoint;
    _baseScale = _currentScale;
    _baseTranslation = _translation;
    
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
    
    setState(() {
      _isZooming = true;
    });
    _showOverlay(context);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (!_isZooming) return;

    setState(() {
      // Scale logic: details.scale is cumulative since onScaleStart
      _currentScale = (_baseScale * details.scale).clamp(1.0, 4.0);
      
      // Translation logic: calculate delta from focal point
      final Offset focalPointDelta = details.localFocalPoint - _lastFocalPoint;
      _translation += focalPointDelta;
      _lastFocalPoint = details.localFocalPoint;

      // Update matrix: Translation * Scale
      _matrix = Matrix4.identity()
        ..translate(_translation.dx, _translation.dy)
        ..scale(_currentScale);
    });

    _overlayEntry?.markNeedsBuild();
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _animation = Matrix4Tween(
      begin: _matrix,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward(from: 0).then((_) {
      _removeOverlay();
      setState(() {
        _isZooming = false;
        _matrix = Matrix4.identity();
        _currentScale = 1.0;
        _translation = Offset.zero;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: Opacity(
        opacity: _isZooming ? 0 : 1,
        child: widget.child,
      ),
    );
  }
}
