// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:async' show Timer;

import 'package:flutter/src/gestures/arena.dart';
import 'package:flutter/src/gestures/constants.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:flutter/src/gestures/recognizer.dart';
import 'package:flutter/src/gestures/velocity_tracker.dart';
import './double_details.dart';

/// The possible states of a [ScaleGestureRecognizer].
enum _ScaleState {
  /// The recognizer is ready to start recognizing a gesture.
  ready,

  /// The sequence of pointer events seen thus far is consistent with a scale
  /// gesture but the gesture has not been accepted definitively.
  possible,

  /// The sequence of pointer events seen thus far has been accepted
  /// definitively as a scale gesture.
  accepted,

  /// The sequence of pointer events seen thus far has been accepted
  /// definitively as a scale gesture and the pointers established a focal point
  /// and initial scale.
  started,
}

/// Details for [GestureScaleStartCallback].
class ScaleStartDetails {
  /// Creates details for [GestureScaleStartCallback].
  ///
  /// The [focalPoint] argument must not be null.
  ScaleStartDetails({this.focalPoint = Offset.zero})
      : assert(focalPoint != null);

  /// The initial focal point of the pointers in contact with the screen.
  /// Reported in global coordinates.
  final Offset focalPoint;

  @override
  String toString() => 'ScaleStartDetails(focalPoint: $focalPoint)';
}

/// Details for [GestureScaleUpdateCallback].
class ScaleUpdateDetails {
  /// Creates details for [GestureScaleUpdateCallback].
  ///
  /// The [focalPoint], [scale], [rotation] arguments must not be null. The [scale]
  /// argument must be greater than or equal to zero.
  ScaleUpdateDetails({
    this.focalPoint = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.pointerEvent,
    this.pointCount = 1,
  })  : assert(scale != null && scale >= 0.0),
        assert(rotation != null);

  /// The focal point of the pointers in contact with the screen. Reported in
  /// global coordinates.
  final Offset focalPoint;

  /// The scale implied by the pointers in contact with the screen. A value
  /// greater than or equal to zero.
  final double scale;

  /// The angle implied by the first two pointers to enter in contact with
  /// the screen. Expressed in radians.
  final double rotation;

  final PointerEvent pointerEvent;
  final int pointCount;

  @override
  String toString() =>
      'ScaleUpdateDetails(focalPoint: $focalPoint, scale: $scale, rotation: $rotation, pointerEvent: $pointerEvent, pointCount: $pointCount)';
}

/// Details for [GestureScaleEndCallback].
class ScaleEndDetails {
  /// Creates details for [GestureScaleEndCallback].
  ///
  /// The [velocity] argument must not be null.
  ScaleEndDetails({this.velocity = Velocity.zero}) : assert(velocity != null);

  /// The velocity of the last pointer to be lifted off of the screen.
  final Velocity velocity;

  @override
  String toString() => 'ScaleEndDetails(velocity: $velocity)';
}

/// Signature for when the pointers in contact with the screen have established
/// a focal point and initial scale of 1.0.
typedef GestureScaleStartCallback = void Function(ScaleStartDetails details);

/// Signature for when the pointers in contact with the screen have indicated a
/// new focal point and/or scale.
typedef GestureScaleUpdateCallback = void Function(ScaleUpdateDetails details);

/// Signature for when the pointers are no longer in contact with the screen.
typedef GestureScaleEndCallback = void Function(ScaleEndDetails details);

bool _isFlingGesture(Velocity velocity) {
  assert(velocity != null);
  final double speedSquared = velocity.pixelsPerSecond.distanceSquared;
  return speedSquared > kMinFlingVelocity * kMinFlingVelocity;
}

/// Defines a line between two pointers on screen.
///
/// [_LineBetweenPointers] is an abstraction of a line between two pointers in
/// contact with the screen. Used to track the rotation of a scale gesture.
class _LineBetweenPointers {
  /// Creates a [_LineBetweenPointers]. None of the [pointerStartLocation], [pointerStartId]
  /// [pointerEndLocation] and [pointerEndId] must be null. [pointerStartId] and [pointerEndId]
  /// should be different.
  _LineBetweenPointers(
      {this.pointerStartLocation = Offset.zero,
      this.pointerStartId = 0,
      this.pointerEndLocation = Offset.zero,
      this.pointerEndId = 1})
      : assert(pointerStartLocation != null && pointerEndLocation != null),
        assert(pointerStartId != null && pointerEndId != null),
        assert(pointerStartId != pointerEndId);

  // The location and the id of the pointer that marks the start of the line.
  final Offset pointerStartLocation;
  final int pointerStartId;

  // The location and the id of the pointer that marks the end of the line.
  final Offset pointerEndLocation;
  final int pointerEndId;
}

/// Recognizes a scale gesture.
///
/// [ScaleGestureRecognizer] tracks the pointers in contact with the screen and
/// calculates their focal point, indicated scale, and rotation. When a focal
/// pointer is established, the recognizer calls [onStart]. As the focal point,
/// scale, rotation change, the recognizer calls [onUpdate]. When the pointers
/// are no longer in contact with the screen, the recognizer calls [onEnd].
class ScaleGestureRecognizer extends OneSequenceGestureRecognizer {
  /// Create a gesture recognizer for interactions intended for scaling content.
  ScaleGestureRecognizer({Object debugOwner}) : super(debugOwner: debugOwner);

  /// The pointers in contact with the screen have established a focal point and
  /// initial scale of 1.0.
  GestureScaleStartCallback onStart;

  /// The pointers in contact with the screen have indicated a new focal point
  /// and/or scale.
  GestureScaleUpdateCallback onUpdate;

  /// The pointers are no longer in contact with the screen.
  GestureScaleEndCallback onEnd;

  _ScaleState _state = _ScaleState.ready;

  Offset _initialFocalPoint;
  Offset _currentFocalPoint;
  double _initialSpan;
  double _currentSpan;
  _LineBetweenPointers _initialLine;
  _LineBetweenPointers _currentLine;
  Map<int, Offset> _pointerLocations;
  List<int> _pointerQueue;
  int pointCount = 0;
  bool isOnlyOnePoint = true; // 表示
  /// --------------------------DoubleTap-start--------------------------

  /// Called when the user has tapped the screen at the same location twice in
  /// quick succession.
  GestureDoubleTapCallback onDoubleTap;

  /// is track pointer
  /// 是否追踪手指
  bool _isTrackingPointer = false;

  bool isFirstTap = true;

  /// timer
  Timer _doubleTapTimer;

  /// start track pointer
  /// 开始追踪双击手指
  void startDoubleTracking() {
    if (!_isTrackingPointer) {
      _isTrackingPointer = true;
    }
  }

  /// stop track pointer
  /// 停止追踪双击手指
  void stopDoubleTracking() {
    if (_isTrackingPointer) {
      _isTrackingPointer = false;
    }
  }

  /// is two point within tolerance
  /// 双击 是否两个点在一个范围内
  bool isWithinTolerance(PointerEvent event, double tolerance) {
    final Offset offset = event.position - _initialFocalPoint;
    return offset.distance <= tolerance;
  }

  void _reset() {
    _stopDoubleTapTimer();
    if (!isFirstTap) {
      // Note, order is important below in order for the resolve -> reject logic
      // to work properly.
      isFirstTap = true;
    }
  }

  void _registerFirstTap() {
    _startDoubleTapTimer();
    // Note, order is important below in order for the clear -> reject logic to
    // work properly.
    isFirstTap = false;
  }

  void _registerSecondTap(PointerEvent event) {
    if (onDoubleTap != null)
      invokeCallback<void>(
          'onDoubleTap', () => onDoubleTap(DoubleDetails(pointerEvent: event)));
    _reset();
  }

  void _startDoubleTapTimer() {
    _doubleTapTimer ??= Timer(kDoubleTapTimeout, _reset);
  }

  void _stopDoubleTapTimer() {
    if (_doubleTapTimer != null) {
      _doubleTapTimer.cancel();
      _doubleTapTimer = null;
    }
  }

  void _reject() {
    if (!isFirstTap) _reset();
  }

  void _doubleTapAddPoniter(PointerEvent event) {
    _stopDoubleTapTimer();
    if (event is PointerUpEvent) {
      if (isFirstTap) {
        _registerFirstTap();
      } else {
        _registerSecondTap(event);
      }
    } else if (event is PointerMoveEvent) {
      if (!isWithinTolerance(event, kDoubleTapTouchSlop)) _reject();
    } else if (event is PointerCancelEvent) {
      _reject();
    }
  }

  /// --------------------------DoubleTap-end--------------------------

  /// A queue to sort pointers in order of entrance
  final Map<int, VelocityTracker> _velocityTrackers = <int, VelocityTracker>{};

  double get _scaleFactor =>
      _initialSpan > 0.0 ? _currentSpan / _initialSpan : 1.0;

  double _computeRotationFactor() {
    if (_initialLine == null || _currentLine == null) {
      return 0.0;
    }
    final double fx = _initialLine.pointerStartLocation.dx;
    final double fy = _initialLine.pointerStartLocation.dy;
    final double sx = _initialLine.pointerEndLocation.dx;
    final double sy = _initialLine.pointerEndLocation.dy;

    final double nfx = _currentLine.pointerStartLocation.dx;
    final double nfy = _currentLine.pointerStartLocation.dy;
    final double nsx = _currentLine.pointerEndLocation.dx;
    final double nsy = _currentLine.pointerEndLocation.dy;

    final double angle1 = math.atan2(fy - sy, fx - sx);
    final double angle2 = math.atan2(nfy - nsy, nfx - nsx);

    return angle2 - angle1;
  }

  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
    _velocityTrackers[event.pointer] = VelocityTracker();
    if (_state == _ScaleState.ready) {
      _state = _ScaleState.possible;
      _initialSpan = 0.0;
      _currentSpan = 0.0;
      _pointerLocations = <int, Offset>{};
      _pointerQueue = <int>[];
    }
    _doubleTapAddPoniter(event);
    // else if (_state == _ScaleState.accepted && _pointerQueue.length == 0) {
    //   resolve(GestureDisposition.accepted);
    // }
  }

  @override
  void handleEvent(PointerEvent event) {
    assert(_state != _ScaleState.ready);
    bool didChangeConfiguration = false;
    bool shouldStartIfAccepted = false;
    if (event is PointerMoveEvent) {
      final VelocityTracker tracker = _velocityTrackers[event.pointer];
      assert(tracker != null);
      if (!event.synthesized)
        tracker.addPosition(event.timeStamp, event.position);
      _pointerLocations[event.pointer] = event.position;
      shouldStartIfAccepted = true;

      pointCount = _pointerLocations.keys.length;
      if (pointCount <= 1 && onUpdate != null && isOnlyOnePoint && !isFirstTap)
        invokeCallback<void>(
            'onUpdate',
            () => onUpdate(ScaleUpdateDetails(
                scale: _scaleFactor,
                focalPoint: _currentFocalPoint,
                rotation: _computeRotationFactor(),
                pointerEvent: event,
                pointCount: pointCount)));
    } else if (event is PointerDownEvent) {
      isOnlyOnePoint = _pointerQueue.length == 0;

      _pointerLocations[event.pointer] = event.position;
      _pointerQueue.add(event.pointer);
      didChangeConfiguration = true;
      shouldStartIfAccepted = true;
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _pointerLocations.remove(event.pointer);
      _pointerQueue.remove(event.pointer);
      didChangeConfiguration = true;
    }
    _updateLines();
    _update();

    if (!didChangeConfiguration || _reconfigure(event.pointer)) {
      _advanceStateMachine(shouldStartIfAccepted, event);
    }
    stopTrackingIfPointerNoLongerDown(event);
  }

  void _update() {
    final int count = _pointerLocations.keys.length;

    // Compute the focal point
    Offset focalPoint = Offset.zero;
    for (int pointer in _pointerLocations.keys)
      focalPoint += _pointerLocations[pointer];
    _currentFocalPoint =
        count > 0 ? focalPoint / count.toDouble() : Offset.zero;

    // Span is the average deviation from focal point
    double totalDeviation = 0.0;
    for (int pointer in _pointerLocations.keys)
      totalDeviation +=
          (_currentFocalPoint - _pointerLocations[pointer]).distance;
    _currentSpan = count > 0 ? totalDeviation / count : 0.0;
  }

  /// Updates [_initialLine] and [_currentLine] accordingly to the situation of
  /// the registered pointers
  void _updateLines() {
    final int count = _pointerLocations.keys.length;
    assert(_pointerQueue.length >= count);

    /// In case of just one pointer registered, reconfigure [_initialLine]
    if (count < 2) {
      _initialLine = _currentLine;
    } else if (_initialLine != null &&
        _initialLine.pointerStartId == _pointerQueue[0] &&
        _initialLine.pointerEndId == _pointerQueue[1]) {
      /// Rotation updated, set the [_currentLine]
      _currentLine = _LineBetweenPointers(
          pointerStartId: _pointerQueue[0],
          pointerStartLocation: _pointerLocations[_pointerQueue[0]],
          pointerEndId: _pointerQueue[1],
          pointerEndLocation: _pointerLocations[_pointerQueue[1]]);
    } else {
      /// A new rotation process is on the way, set the [_initialLine]
      _initialLine = _LineBetweenPointers(
          pointerStartId: _pointerQueue[0],
          pointerStartLocation: _pointerLocations[_pointerQueue[0]],
          pointerEndId: _pointerQueue[1],
          pointerEndLocation: _pointerLocations[_pointerQueue[1]]);
      _currentLine = null;
    }
  }

  bool _reconfigure(int pointer) {
    _initialFocalPoint = _currentFocalPoint;
    _initialSpan = _currentSpan;
    _initialLine = _currentLine;
    if (_state == _ScaleState.started) {
      if (onEnd != null) {
        final VelocityTracker tracker = _velocityTrackers[pointer];
        assert(tracker != null);

        Velocity velocity = tracker.getVelocity();
        if (_isFlingGesture(velocity)) {
          final Offset pixelsPerSecond = velocity.pixelsPerSecond;
          if (pixelsPerSecond.distanceSquared >
              kMaxFlingVelocity * kMaxFlingVelocity)
            velocity = Velocity(
                pixelsPerSecond: (pixelsPerSecond / pixelsPerSecond.distance) *
                    kMaxFlingVelocity);
          invokeCallback<void>(
              'onEnd', () => onEnd(ScaleEndDetails(velocity: velocity)));
        } else {
          invokeCallback<void>(
              'onEnd', () => onEnd(ScaleEndDetails(velocity: Velocity.zero)));
        }
      }
      _state = _ScaleState.accepted;
      return false;
    }
    return true;
  }

  void _advanceStateMachine(
      bool shouldStartIfAccepted, PointerEvent pointerEvent) {
    if (_state == _ScaleState.ready) _state = _ScaleState.possible;

    if (_state == _ScaleState.possible) {
      final double spanDelta = (_currentSpan - _initialSpan).abs();
      final double focalPointDelta =
          (_currentFocalPoint - _initialFocalPoint).distance;
      if (spanDelta > kScaleSlop || focalPointDelta > kPanSlop)
        resolve(GestureDisposition.accepted);
    } else if (_state.index >= _ScaleState.accepted.index) {
      resolve(GestureDisposition.accepted);
    }

    if (_state == _ScaleState.accepted && shouldStartIfAccepted) {
      _state = _ScaleState.started;
      _dispatchOnStartCallbackIfNeeded();
    }

    // if (_state == _ScaleState.started && onUpdate != null)
    if (_state == _ScaleState.started && onUpdate != null)
      invokeCallback<void>(
          'onUpdate',
          () => onUpdate(ScaleUpdateDetails(
              scale: _scaleFactor,
              focalPoint: _currentFocalPoint,
              rotation: _computeRotationFactor(),
              pointerEvent: pointerEvent,
              pointCount: pointCount)));
  }

  void _dispatchOnStartCallbackIfNeeded() {
    assert(_state == _ScaleState.started);
    if (onStart != null)
      invokeCallback<void>('onStart',
          () => onStart(ScaleStartDetails(focalPoint: _currentFocalPoint)));
  }

  @override
  void acceptGesture(int pointer) {
    resolve(GestureDisposition.accepted);
    if (_state == _ScaleState.possible) {
      _state = _ScaleState.started;
      _dispatchOnStartCallbackIfNeeded();
    }
  }

  @override
  void rejectGesture(int pointer) {
    stopTrackingPointer(pointer);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    switch (_state) {
      case _ScaleState.possible:
        resolve(GestureDisposition.rejected);
        break;
      case _ScaleState.ready:
        assert(false); // We should have not seen a pointer yet
        break;
      case _ScaleState.accepted:
        break;
      case _ScaleState.started:
        assert(false); // We should be in the accepted state when user is done
        break;
    }
    _state = _ScaleState.ready;
  }

  @override
  void dispose() {
    _velocityTrackers.clear();
    _reset();

    super.dispose();
  }

  @override
  String get debugDescription => 'scale';
}
