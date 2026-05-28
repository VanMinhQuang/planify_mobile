import 'package:flutter_test/flutter_test.dart';
import 'package:planify_mobile/data/dto/plan_dto.dart';
import 'package:planify_mobile/domain/models/plan.dart';

void main() {
  test('PlanDto maps backend payloads to domain', () {
    final plan = PlanDto.fromJson({
      'id': 'plan-1',
      'title': 'Da Lat trip',
      'description': 'Mountain weekend',
      'category': 'TRAVEL',
      'coverImageUrl': null,
      'startDate': '2026-06-01T00:00:00.000Z',
      'endDate': '2026-06-03T00:00:00.000Z',
      'ownerId': 'user-1',
      'isArchived': false,
    }).toDomain();

    expect(plan.id, 'plan-1');
    expect(plan.category, PlanCategory.travel);
    expect(plan.isArchived, isFalse);
  });
}
