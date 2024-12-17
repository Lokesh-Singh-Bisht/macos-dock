import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(),
        ),
      ),
    );
  }
}

class Dock extends StatefulWidget {
  const Dock({super.key});

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  // Tracks the index of the item being hovered over.
  late int? hoveredIndex;

  // Base height for each dock item.
  late double baseItemHeight;

  // Padding between vertical items.
  late double verticlItemsPadding;

  // Base Y axis value of the elements.
  late double baseTranslationY;

  // List of icons to display in the dock.
  List<IconData> iconsData = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  // List of colors assigned to each icon.
  List<MaterialColor> itemsColor = [];

  // Tracks the index of the currently dragged item.
  int? draggingIndex;

  // Indicates if the left hover region is active.
  bool isHoveringLeftRegion = false;

  // Tracks if an item is currently being dragged.
  bool isDragging = false;

  @override
  void initState() {
    super.initState();

    // Initialize item colors with random primary colors.
    itemsColor = List.generate(
      5,
      (index) => Colors.primaries[index.hashCode % Colors.primaries.length],
    );

    // Set default values
    hoveredIndex = null;
    baseItemHeight = 40;
    verticlItemsPadding = 10;
    draggingIndex = null;
    baseTranslationY = 0.0;
  }

  /// Calculates the size of an item based on its hover state.
  double getScaledSize(int index) {
    return getPropertyValue(
      index: index,
      baseValue: baseItemHeight,
      maxValue: 50,
      nonHoveredMaxValue: 45,
    );
  }

  /// Calculates the elevation on T-axis of an item based on its hover state.
  double getTranslationY(int index) {
    return getPropertyValue(
      index: index,
      baseValue: baseTranslationY,
      maxValue: -10,
      nonHoveredMaxValue: -8,
    );
  }

  /// Computes property values based on hover proximity.
  double getPropertyValue({
    required int index,
    required double baseValue,
    required double maxValue,
    required double nonHoveredMaxValue,
  }) {
    late final double propertyValue;

    if (hoveredIndex == null) {
      return baseValue;
    }

    // Calculate the difference between the hovered and current index.
    final difference = (hoveredIndex! - index).abs();
    final itemsAffected = iconsData.length;

    // Assign size based on proximity to hovered index.
    if (difference == 0) {
      propertyValue = maxValue;
    } else if (difference <= itemsAffected) {
      final ratio = (itemsAffected - difference) / itemsAffected;
      propertyValue = lerpDouble(baseValue, nonHoveredMaxValue, ratio)!;
    } else {
      propertyValue = baseValue;
    }
    return propertyValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              height: (baseItemHeight * 2) - verticlItemsPadding,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: hoveredIndex != null
                    ? (baseItemHeight * 2)
                    : (baseItemHeight * 2) -
                        verticlItemsPadding, // Adjusts height based on hover.
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black12,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(verticlItemsPadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  iconsData.length,
                  (index) {
                    return DragTarget<int>(
                      onWillAcceptWithDetails: (data) => data.data != index,
                      builder: (context, candidateData, rejectedData) {
                        return LongPressDraggable<int>(
                          delay: Durations.short4,
                          data: index,
                          onDragStarted: () {
                            setState(() {
                              draggingIndex = index; // Set the dragging index.
                            });
                          },
                          onDragCompleted: () {
                            // Reorder the items in the list after drag is completed.
                            if (draggingIndex != null) {
                              final dragginIndexTemp = draggingIndex!;
                              setState(() {
                                draggingIndex = null;
                                isDragging = false;

                                if (hoveredIndex != null) {
                                  int insertIndex = hoveredIndex!;
                                  if (dragginIndexTemp < insertIndex) {
                                    if (isHoveringLeftRegion) {
                                      insertIndex--;
                                    }
                                  } else {
                                    if (!isHoveringLeftRegion) {
                                      insertIndex++;
                                    }
                                  }

                                  // Reorder icon list and color list.
                                  final draggedItem =
                                      iconsData.removeAt(dragginIndexTemp);
                                  iconsData.insert(insertIndex, draggedItem);

                                  final draggedItemColor =
                                      itemsColor.removeAt(dragginIndexTemp);
                                  itemsColor.insert(
                                      insertIndex, draggedItemColor);
                                }
                              });
                            }
                          },
                          onDraggableCanceled: (_, __) {
                            setState(() {
                              draggingIndex = null;
                            });
                          },
                          feedback: Material(
                            color: Colors.transparent,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: buildIconContainer(
                                  index, false, false, false),
                            ),
                          ),
                          childWhenDragging: MouseRegion(
                            hitTestBehavior: HitTestBehavior.deferToChild,
                            cursor: SystemMouseCursors.click,
                            onEnter: (events) {},
                            onExit: (events) {
                              setState(() {
                                isDragging = true;
                              });
                            },
                            child: AnimatedContainer(
                              color: Colors.transparent,
                              margin: EdgeInsets.symmetric(
                                  horizontal: isDragging ? 0 : 10),
                              duration: const Duration(milliseconds: 300),
                              height: isDragging ? 0 : getScaledSize(index),
                              width: isDragging ? 0 : getScaledSize(index),
                            ),
                          ),
                          child: buildIconContainer(
                              index,
                              draggingIndex != null,
                              isHoveringLeftRegion,
                              index == hoveredIndex),
                        );
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconContainer(
      int index, bool isDragging, bool isHoveredLeft, bool isHovered) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.deferToChild,
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          hoveredIndex = index;
        });
      },
      onExit: (event) {
        setState(() {
          hoveredIndex = null; // Reset hovered index on hover exit.
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Increase Left Hover Region to let Dragged Item Fit in
          AnimatedContainer(
            duration: Duration(
              milliseconds: draggingIndex != null ? 300 : 0,
            ),
            color: Colors.transparent,
            height: getScaledSize(index),
            width: isHovered && isDragging
                ? isHoveredLeft
                    ? getScaledSize(index) + 20
                    : 0
                : 0,
          ),
          Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Main icon container with dynamic size and hover effects.
                AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: getScaledSize(index),
                    width: getScaledSize(index),
                    alignment: AlignmentDirectional.bottomCenter,
                    decoration: BoxDecoration(
                      color: itemsColor[index],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    transform: Matrix4.identity()
                      ..translate(
                        0.0,
                        getTranslationY(index).roundToDouble(),
                        0.0,
                      ),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(
                        iconsData[index],
                        size: getScaledSize(index) - 20,
                        color: Colors.white,
                      ),
                    )),

                // Left hover region to detect dragging to the left.
                Positioned(
                    left: 0,
                    top: 0,
                    child: MouseRegion(
                      hitTestBehavior: HitTestBehavior.deferToChild,
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) {
                        setState(() {
                          hoveredIndex = index;
                        });
                        setState(() {
                          isHoveringLeftRegion =
                              true; // Activate left hover region.
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        color: Colors.transparent,
                        height: getScaledSize(index),
                        width: (getScaledSize(index) / 2) + 10,
                      ),
                    )),
                // Right hover region to detect dragging to the right.
                Positioned(
                    left: (getScaledSize(index) / 2) + 10,
                    top: 0,
                    child: MouseRegion(
                      hitTestBehavior: HitTestBehavior.deferToChild,
                      cursor: SystemMouseCursors.click,
                      onEnter: (event) {
                        setState(() {
                          hoveredIndex = index;
                        });
                        setState(() {
                          isHoveringLeftRegion =
                              false; // Deactivate left region.
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        color: Colors.transparent,
                        height: getScaledSize(index),
                        width: (getScaledSize(index) / 2) + 10,
                      ),
                    )),
              ]),
          // Increase Right Hover Region to let Dragged Item Fit in
          AnimatedContainer(
            duration: Duration(
              milliseconds: draggingIndex != null ? 300 : 0,
            ),
            color: Colors.transparent,
            height: getScaledSize(index),
            width: isHovered && isDragging
                ? isHoveredLeft
                    ? 0
                    : getScaledSize(index) + 20
                : 0,
          ),
        ],
      ),
    );
  }
}
