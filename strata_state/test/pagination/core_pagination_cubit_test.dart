import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_state/strata_state.dart';

class TestItem extends Equatable implements Identifiable {
  const TestItem(this.id, this.name);

  @override
  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

void main() {
  group('CorePaginationCubit Tests', () {
    late PagePaginationStrategy strategy;

    setUp(() {
      strategy = PagePaginationStrategy(limit: 2);
    });

    test('fetches initial data and handles success', () async {
      final cubit = CorePaginationCubit<TestItem, NoMetaModel>(
        paginationStrategy: strategy,
        paginationFunction: (batch, limit, {requestId}) async {
          return right(
            const PaginationResponseModel(
              data: [TestItem('1', 'Item 1'), TestItem('2', 'Item 2')],
            ),
          );
        },
      );

      await cubit.fetchInitialData();

      expect(cubit.state, isA<PaginationSucceeded<TestItem, NoMetaModel>>());
      expect(
        cubit.state.paginatedResponseModel.data,
        equals([const TestItem('1', 'Item 1'), const TestItem('2', 'Item 2')]),
      );
    });

    test('addFirst and delete mutate pagination list items', () async {
      final cubit = CorePaginationCubit<TestItem, NoMetaModel>(
        paginationStrategy: strategy,
        paginationFunction: (batch, limit, {requestId}) async {
          return right(
            const PaginationResponseModel(
              data: [TestItem('1', 'Item 1')],
            ),
          );
        },
      );

      await cubit.fetchInitialData();
      cubit.addFirst(const TestItem('0', 'Item 0'));

      expect(
        cubit.state.paginatedResponseModel.data,
        equals([const TestItem('0', 'Item 0'), const TestItem('1', 'Item 1')]),
      );

      cubit.delete('0');
      expect(
        cubit.state.paginatedResponseModel.data,
        equals([const TestItem('1', 'Item 1')]),
      );
    });
  });
}
