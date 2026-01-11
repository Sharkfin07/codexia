/*
 * Example case of Rive
 * Based on https://github.com/Shashank02051997/LoginUI-Flutter
 */

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class LoginAnimationController {
  StateMachineController? _controller;
  SMINumber? _look;
  SMIBool? _isHandsUp;
  SMIBool? _isChecking;
  SMITrigger? _trigSuccess;
  SMITrigger? _trigFail;

  bool get isReady => _controller != null;

  void bind(StateMachineController controller) {
    _controller = controller;
    _mapInputs(controller);
    _isChecking?.value = false;
    _isHandsUp?.value = false;
  }

  void _mapInputs(StateMachineController controller) {
    for (final input in controller.inputs) {
      final name = input.name.toLowerCase();
      if (input is SMINumber && _look == null && name.contains('look')) {
        _look = input;
      }
      if (input is SMIBool) {
        if (_isHandsUp == null &&
            (name.contains('hand') || name.contains('up'))) {
          _isHandsUp = input;
          continue;
        }
        if (_isChecking == null && name.contains('check')) {
          _isChecking = input;
          continue;
        }
      }
      if (input is SMITrigger) {
        if (_trigSuccess == null && name.contains('success')) {
          _trigSuccess = input;
          continue;
        }
        if (_trigFail == null &&
            (name.contains('fail') || name.contains('error'))) {
          _trigFail = input;
          continue;
        }
      }
    }
    _look ??= controller.findInput<SMINumber>('numLook') as SMINumber?;
    _isHandsUp ??= controller.findInput<SMIBool>('isHandsUp') as SMIBool?;
    _isChecking ??= controller.findInput<SMIBool>('isChecking') as SMIBool?;
    _trigSuccess ??=
        controller.findInput<SMITrigger>('trigSuccess') as SMITrigger?;
    _trigFail ??= controller.findInput<SMITrigger>('trigFail') as SMITrigger?;
  }

  void lookAt(double value) {
    _look?.value = value.clamp(0, 100);
  }

  void setHandsUp(bool up) {
    _isHandsUp?.value = up;
  }

  void setChecking(bool checking) {
    _isChecking?.value = checking;
  }

  void success() => _trigSuccess?.fire();

  void fail() => _trigFail?.fire();
}

class LoginAnimation extends StatefulWidget {
  const LoginAnimation({super.key, this.onControllerReady});

  final ValueChanged<LoginAnimationController>? onControllerReady;

  @override
  State<LoginAnimation> createState() => _LoginAnimationState();
}

class _LoginAnimationState extends State<LoginAnimation> {
  static const _asset = 'assets/animations/login.riv';
  static const _stateMachines = [
    'Login Machine',
    'State Machine 1',
    'State Machine',
  ];
  final _controller = LoginAnimationController();

  void _onRiveInit(Artboard artboard) {
    StateMachineController? smController;
    for (final name in _stateMachines) {
      smController = StateMachineController.fromArtboard(artboard, name);
      if (smController != null) break;
    }
    smController ??= (artboard.stateMachines.isNotEmpty
        ? StateMachineController.fromArtboard(
            artboard,
            artboard.stateMachines.first.name,
          )
        : null);
    if (smController == null) return;
    artboard.addController(smController);
    _controller.bind(smController);
    widget.onControllerReady?.call(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          alignment: Alignment.center,
          child: RiveAnimation.asset(
            _asset,
            fit: BoxFit.cover,
            onInit: _onRiveInit,
          ),
        ),
      ),
    );
  }
}
