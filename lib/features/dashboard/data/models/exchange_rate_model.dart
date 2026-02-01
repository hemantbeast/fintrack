import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate_model.g.dart';

@JsonSerializable()
class ExchangeRateModel extends HiveObject {
  ExchangeRateModel({
    this.result,
    this.baseCode,
    this.conversionRates,
    this.timeLastUpdateUnix,
  });

  factory ExchangeRateModel.fromJson(JSON json) => _$ExchangeRateModelFromJson(json);

  JSON toJson() => _$ExchangeRateModelToJson(this);

  @JsonKey(name: 'result')
  String? result;

  @JsonKey(name: 'base_code')
  String? baseCode;

  @JsonKey(name: 'conversion_rates')
  JSON? conversionRates;

  @JsonKey(name: 'time_last_update_unix')
  int? timeLastUpdateUnix;

  /// Check if the cached data is still valid (less than 24 hours old)
  bool get isValid {
    if (timeLastUpdateUnix == null) return false;

    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(timeLastUpdateUnix! * 1000);
    final now = DateTime.now();
    final difference = now.difference(lastUpdate);

    return difference.inHours < 24;
  }

  /// Convert to ExchangeRates domain entity
  ExchangeRates toEntity() {
    final ratesMap = <String, double>{};

    if (conversionRates != null) {
      for (final entry in conversionRates!.entries) {
        if (entry.value is num) {
          ratesMap[entry.key] = (entry.value as num).toDouble();
        }
      }
    }

    return ExchangeRates(
      baseCurrency: baseCode ?? 'INR',
      rates: ratesMap,
      lastUpdated: timeLastUpdateUnix != null
          ? DateTime.fromMillisecondsSinceEpoch(timeLastUpdateUnix! * 1000)
          : DateTime.now(),
    );
  }
}
