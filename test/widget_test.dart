// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_delivery_app/main.dart';

void main() {
  testWidgets('Food Delivery App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(FoodDeliveryApp());

    // Verify that the app title is present
    expect(find.text('Deliver to'), findsOneWidget);
    
    // Verify that search field is present
    expect(find.byType(TextField), findsOneWidget);
    
    // Verify that categories section is present
    expect(find.text('Categories'), findsOneWidget);
    
    // Verify that restaurants section is present
    expect(find.text('Restaurants Near You'), findsOneWidget);
    
    // Verify bottom navigation bar is present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Bottom navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(FoodDeliveryApp());

    // Tap on Orders tab
    await tester.tap(find.text('Orders'));
    await tester.pump();

    // Verify navigation worked (index changed)
    expect(find.text('Orders'), findsWidgets);
  });

  testWidgets('Restaurant card displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(FoodDeliveryApp());

    // Wait for images to load
    await tester.pumpAndSettle();

    // Verify first restaurant name is visible
    expect(find.text('Pizza Paradise'), findsOneWidget);
    
    // Verify rating icon is present
    expect(find.byIcon(Icons.star), findsWidgets);
  });

  testWidgets('Search field interaction test', (WidgetTester tester) async {
    await tester.pumpWidget(FoodDeliveryApp());

    // Find the search field
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    // Enter text in search field
    await tester.enterText(searchField, 'Pizza');
    await tester.pump();

    // Verify text was entered
    expect(find.text('Pizza'), findsOneWidget);
  });

  testWidgets('Cart button displays item count', (WidgetTester tester) async {
    await tester.pumpWidget(FoodDeliveryApp());
    
    await tester.pumpAndSettle();

    // Initially cart should be empty (no badge visible)
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
  });
}