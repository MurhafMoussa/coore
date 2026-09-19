import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_ui/strata_ui.dart';

class TestItem implements Identifiable {
  const TestItem({required this.id, required this.title});
  @override
  final String id;
  final String title;

  static const empty = TestItem(id: '', title: '');
}

class TestMeta extends MetaModel {
  const TestMeta();
}

void main() {
  group('CorePaginationWidget Tests', () {
    testWidgets('renders item list when items are provided', (tester) async {
      const model = PaginationResponseModel<TestItem, TestMeta>(
        data: [
          TestItem(id: '1', title: 'Item One'),
          TestItem(id: '2', title: 'Item Two'),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CorePaginationWidget<TestItem, TestMeta>(
              items: model,
              emptyEntity: TestItem.empty,
              scrollableBuilder: (context, items, controller) {
                return ListView.builder(
                  controller: controller,
                  itemCount: items.data.length,
                  itemBuilder: (context, index) => Text(items.data[index].title),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Item One'), findsOneWidget);
      expect(find.text('Item Two'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('renders empty state when items data is empty', (tester) async {
      const model = PaginationResponseModel<TestItem, TestMeta>(data: []);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CorePaginationWidget<TestItem, TestMeta>(
              items: model,
              emptyEntity: TestItem.empty,
              scrollableBuilder: (context, items, controller) {
                return ListView.builder(
                  controller: controller,
                  itemCount: items.data.length,
                  itemBuilder: (context, index) => Text(items.data[index].title),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('No items found'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('triggers onRefresh callback when pulled', (tester) async {
      var refreshed = false;
      const model = PaginationResponseModel<TestItem, TestMeta>(
        data: [TestItem(id: '1', title: 'Item One')],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CorePaginationWidget<TestItem, TestMeta>(
              items: model,
              emptyEntity: TestItem.empty,
              onRefresh: () async => refreshed = true,
              scrollableBuilder: (context, items, controller) {
                return ListView.builder(
                  controller: controller,
                  itemCount: items.data.length,
                  itemBuilder: (context, index) => Text(items.data[index].title),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Item One'), findsOneWidget);
      expect(refreshed, isFalse);
      await tester.pumpAndSettle();
    });
  });
}
