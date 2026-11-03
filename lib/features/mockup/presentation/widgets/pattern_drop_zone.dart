import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Area drop pattern batik (menerima DragTarget).
class PatternDropZone extends StatelessWidget {
  const PatternDropZone({
    super.key,
    required this.child,
    required this.onPatternDropped,
  });

  final Widget child;
  final void Function(Uint8List bytes) onPatternDropped;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Uint8List>(
      onAcceptWithDetails: (details) => onPatternDropped(details.data),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovering ? Colors.teal : Colors.grey.shade300,
              width: isHovering ? 3 : 1.5,
            ),
            color: isHovering ? Colors.teal.withValues(alpha: 0.05) : Colors.white,
          ),
          child: Stack(
            children: [
              Positioned.fill(child: child),
              if (isHovering)
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        'Lepas di sini untuk menerapkan motif',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}