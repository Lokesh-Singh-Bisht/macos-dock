# Dock with Draggable Buttons

This project implements a draggable dock with animated buttons, inspired by the dock in macOS. The dock is fully interactive, allowing users to hover over items to scale their size dynamically and drag-and-drop items to reorder them. 

## Features

- **Animated Hover Effects**: Icons dynamically scale in size when hovered over, with adjacent icons scaling slightly for a smooth effect.
- **Drag-and-Drop Reordering**: Users can drag icons to reorder them within the dock.
- **Customizable Appearance**: Icons and colors can be easily modified in the code.
- **Smooth Animations**: All interactions are accompanied by smooth, visually appealing animations.

## Technical Details

- The dock uses `MouseRegion` for hover detection and `LongPressDraggable` for drag-and-drop functionality.
- Dynamic sizing and positioning of icons are achieved using Flutter's `AnimatedContainer` and `lerpDouble` for smooth interpolation.
- Hover and drag effects are managed with state variables such as `hoveredIndex`, `draggingIndex`, and `isHoveringLeftRegion`.

## How It Works

1. **Hover Effects**:
   - When the user hovers over an icon, its size increases to a maximum value (`maxValue`).
   - Adjacent icons also scale slightly based on their proximity to the hovered icon.

2. **Drag-and-Drop**:
   - Users can drag icons to reorder them within the dock.
   - Drag-and-drop logic ensures the dragged icon is repositioned correctly when dropped near another icon.

3. **Animations**:
   - Smooth animations are applied during hover and drag interactions using `AnimatedContainer`.

## How to Run

1. Clone this repository or copy the code into a new Flutter project.
2. Run the application using `flutter run`.
3. Interact with the dock to experience hover effects and drag-and-drop functionality.

## Task Reference

This project is based on the following task:

> Using the template provided in DartPad ([DartPad Link](https://dartpad.dev/?id=45fa197194bbdfbc4eb65ca5e70733f6)), develop a dock with draggable buttons, similar to the dock in macOS, completely animated.

A detailed video demonstration of the expected outcome is available [here](https://drive.google.com/file/d/1VJYh_0_9B1LGFqQOWlumSgjirrrRSdzJ/view?usp=sharing).

## Customization

- **Icons**: Modify the `iconsData` list to change the icons in the dock.
- **Colors**: Change the `itemsColor` list to assign different colors to the icons.
- **Animation Durations**: Adjust animation speeds by modifying the `duration` values in `AnimatedContainer`.

---

Developed as a technical task for showcasing Flutter's animation and interaction capabilities.
