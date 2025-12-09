import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressSlider extends StatefulWidget {
  final int currentStep; // 0 = loaded, 1 = tahap1, 2 = tahap2
  
  const ProgressSlider({
    super.key,
    required this.currentStep,
  });

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _initializeAnimation();
  }

  void _initializeAnimation() {
    final newProgress = _getProgress(widget.currentStep);
    _progressAnimation = Tween<double>(
      begin: _previousProgress,
      end: newProgress,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic),
    );
    _previousProgress = newProgress;
    _animationController.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(ProgressSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _initializeAnimation();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _getProgress(int step) {
    switch (step) {
      case 0:
        return 0.33; // Step 1: 33%
      case 1:
        return 0.66; // Step 2: 66%
      case 2:
        return 1.0; // Step 3: 100%
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Background line
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                
                // Progress line dengan animasi
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Step indicators (bulatan) dengan animasi
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StepIndicator(
                        stepNumber: 1,
                        isActive: widget.currentStep >= 0,
                        isCompleted: widget.currentStep > 0,
                      ),
                      _StepIndicator(
                        stepNumber: 2,
                        isActive: widget.currentStep >= 1,
                        isCompleted: widget.currentStep > 1,
                      ),
                      _StepIndicator(
                        stepNumber: 3,
                        isActive: widget.currentStep >= 2,
                        isCompleted: widget.currentStep > 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Step labels dengan fade animation
        _AnimatedStepLabels(currentStep: widget.currentStep),
      ],
    );
  }
}

class _AnimatedStepLabels extends StatefulWidget {
  final int currentStep;

  const _AnimatedStepLabels({required this.currentStep});

  @override
  State<_AnimatedStepLabels> createState() => _AnimatedStepLabelsState();
}

class _AnimatedStepLabelsState extends State<_AnimatedStepLabels>
    with SingleTickerProviderStateMixin {
  late AnimationController _labelAnimController;
  late Animation<double> _labelAnimation;

  @override
  void initState() {
    super.initState();
    _labelAnimController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _labelAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _labelAnimController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_AnimatedStepLabels oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _labelAnimController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _labelAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _labelAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StepLabel(
              label: 'Tanggal & Waktu',
              isActive: widget.currentStep >= 0,
            ),
            _StepLabel(
              label: 'Paket & Form',
              isActive: widget.currentStep >= 1,
            ),
            _StepLabel(
              label: 'Pembayaran',
              isActive: widget.currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatefulWidget {
  final int stepNumber;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicator({
    required this.stepNumber,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  State<_StepIndicator> createState() => _StepIndicatorState();
}

class _StepIndicatorState extends State<_StepIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(_StepIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive ||
        oldWidget.isCompleted != widget.isCompleted) {
      _scaleController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.isCompleted
              ? Colors.green
              : widget.isActive
                  ? Colors.white
                  : Colors.white24,
          shape: BoxShape.circle,
          boxShadow: widget.isActive
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: widget.isCompleted
              ? Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 20,
                )
              : Text(
                  '${widget.stepNumber}',
                  style: GoogleFonts.robotoFlex(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: widget.isActive ? Colors.black : Colors.white54,
                  ),
                ),
        ),
      ),
    );
  }
}

class _StepLabel extends StatelessWidget {
  final String label;
  final bool isActive;

  const _StepLabel({
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 400),
        style: GoogleFonts.robotoFlex(
          fontSize: 11,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          color: isActive ? Colors.white : Colors.white54,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
