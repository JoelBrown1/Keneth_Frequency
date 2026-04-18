// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MeasurementsTable extends Measurements
    with TableInfo<$MeasurementsTable, Measurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMsMeta =
      const VerificationMeta('timestampMs');
  @override
  late final GeneratedColumn<int> timestampMs = GeneratedColumn<int>(
      'timestamp_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pickupNameMeta =
      const VerificationMeta('pickupName');
  @override
  late final GeneratedColumn<String> pickupName = GeneratedColumn<String>(
      'pickup_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pickupTypeMeta =
      const VerificationMeta('pickupType');
  @override
  late final GeneratedColumn<String> pickupType = GeneratedColumn<String>(
      'pickup_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dcrMeta = const VerificationMeta('dcr');
  @override
  late final GeneratedColumn<double> dcr = GeneratedColumn<double>(
      'dcr', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _ambientTempCMeta =
      const VerificationMeta('ambientTempC');
  @override
  late final GeneratedColumn<double> ambientTempC = GeneratedColumn<double>(
      'ambient_temp_c', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _resonantFrequencyHzMeta =
      const VerificationMeta('resonantFrequencyHz');
  @override
  late final GeneratedColumn<double> resonantFrequencyHz =
      GeneratedColumn<double>('resonant_frequency_hz', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _qFactorMeta =
      const VerificationMeta('qFactor');
  @override
  late final GeneratedColumn<double> qFactor = GeneratedColumn<double>(
      'q_factor', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _peakAmplitudeDbMeta =
      const VerificationMeta('peakAmplitudeDb');
  @override
  late final GeneratedColumn<double> peakAmplitudeDb = GeneratedColumn<double>(
      'peak_amplitude_db', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dcrCorrectedMeta =
      const VerificationMeta('dcrCorrected');
  @override
  late final GeneratedColumn<double> dcrCorrected = GeneratedColumn<double>(
      'dcr_corrected', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _inductanceMeta =
      const VerificationMeta('inductance');
  @override
  late final GeneratedColumn<double> inductance = GeneratedColumn<double>(
      'inductance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _capacitanceMeta =
      const VerificationMeta('capacitance');
  @override
  late final GeneratedColumn<double> capacitance = GeneratedColumn<double>(
      'capacitance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _calibrationAppliedMeta =
      const VerificationMeta('calibrationApplied');
  @override
  late final GeneratedColumn<bool> calibrationApplied = GeneratedColumn<bool>(
      'calibration_applied', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("calibration_applied" IN (0, 1))'));
  static const VerificationMeta _frequencyResponseDisplayJsonMeta =
      const VerificationMeta('frequencyResponseDisplayJson');
  @override
  late final GeneratedColumn<String> frequencyResponseDisplayJson =
      GeneratedColumn<String>(
          'frequency_response_display_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frequencyResponseStorageJsonMeta =
      const VerificationMeta('frequencyResponseStorageJson');
  @override
  late final GeneratedColumn<String> frequencyResponseStorageJson =
      GeneratedColumn<String>(
          'frequency_response_storage_json', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        timestampMs,
        pickupName,
        pickupType,
        dcr,
        ambientTempC,
        resonantFrequencyHz,
        qFactor,
        peakAmplitudeDb,
        dcrCorrected,
        inductance,
        capacitance,
        calibrationApplied,
        frequencyResponseDisplayJson,
        frequencyResponseStorageJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurements';
  @override
  VerificationContext validateIntegrity(Insertable<Measurement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp_ms')) {
      context.handle(
          _timestampMsMeta,
          timestampMs.isAcceptableOrUnknown(
              data['timestamp_ms']!, _timestampMsMeta));
    } else if (isInserting) {
      context.missing(_timestampMsMeta);
    }
    if (data.containsKey('pickup_name')) {
      context.handle(
          _pickupNameMeta,
          pickupName.isAcceptableOrUnknown(
              data['pickup_name']!, _pickupNameMeta));
    } else if (isInserting) {
      context.missing(_pickupNameMeta);
    }
    if (data.containsKey('pickup_type')) {
      context.handle(
          _pickupTypeMeta,
          pickupType.isAcceptableOrUnknown(
              data['pickup_type']!, _pickupTypeMeta));
    } else if (isInserting) {
      context.missing(_pickupTypeMeta);
    }
    if (data.containsKey('dcr')) {
      context.handle(
          _dcrMeta, dcr.isAcceptableOrUnknown(data['dcr']!, _dcrMeta));
    } else if (isInserting) {
      context.missing(_dcrMeta);
    }
    if (data.containsKey('ambient_temp_c')) {
      context.handle(
          _ambientTempCMeta,
          ambientTempC.isAcceptableOrUnknown(
              data['ambient_temp_c']!, _ambientTempCMeta));
    } else if (isInserting) {
      context.missing(_ambientTempCMeta);
    }
    if (data.containsKey('resonant_frequency_hz')) {
      context.handle(
          _resonantFrequencyHzMeta,
          resonantFrequencyHz.isAcceptableOrUnknown(
              data['resonant_frequency_hz']!, _resonantFrequencyHzMeta));
    } else if (isInserting) {
      context.missing(_resonantFrequencyHzMeta);
    }
    if (data.containsKey('q_factor')) {
      context.handle(_qFactorMeta,
          qFactor.isAcceptableOrUnknown(data['q_factor']!, _qFactorMeta));
    } else if (isInserting) {
      context.missing(_qFactorMeta);
    }
    if (data.containsKey('peak_amplitude_db')) {
      context.handle(
          _peakAmplitudeDbMeta,
          peakAmplitudeDb.isAcceptableOrUnknown(
              data['peak_amplitude_db']!, _peakAmplitudeDbMeta));
    } else if (isInserting) {
      context.missing(_peakAmplitudeDbMeta);
    }
    if (data.containsKey('dcr_corrected')) {
      context.handle(
          _dcrCorrectedMeta,
          dcrCorrected.isAcceptableOrUnknown(
              data['dcr_corrected']!, _dcrCorrectedMeta));
    }
    if (data.containsKey('inductance')) {
      context.handle(
          _inductanceMeta,
          inductance.isAcceptableOrUnknown(
              data['inductance']!, _inductanceMeta));
    }
    if (data.containsKey('capacitance')) {
      context.handle(
          _capacitanceMeta,
          capacitance.isAcceptableOrUnknown(
              data['capacitance']!, _capacitanceMeta));
    }
    if (data.containsKey('calibration_applied')) {
      context.handle(
          _calibrationAppliedMeta,
          calibrationApplied.isAcceptableOrUnknown(
              data['calibration_applied']!, _calibrationAppliedMeta));
    } else if (isInserting) {
      context.missing(_calibrationAppliedMeta);
    }
    if (data.containsKey('frequency_response_display_json')) {
      context.handle(
          _frequencyResponseDisplayJsonMeta,
          frequencyResponseDisplayJson.isAcceptableOrUnknown(
              data['frequency_response_display_json']!,
              _frequencyResponseDisplayJsonMeta));
    } else if (isInserting) {
      context.missing(_frequencyResponseDisplayJsonMeta);
    }
    if (data.containsKey('frequency_response_storage_json')) {
      context.handle(
          _frequencyResponseStorageJsonMeta,
          frequencyResponseStorageJson.isAcceptableOrUnknown(
              data['frequency_response_storage_json']!,
              _frequencyResponseStorageJsonMeta));
    } else if (isInserting) {
      context.missing(_frequencyResponseStorageJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Measurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Measurement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      timestampMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp_ms'])!,
      pickupName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pickup_name'])!,
      pickupType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pickup_type'])!,
      dcr: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}dcr'])!,
      ambientTempC: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ambient_temp_c'])!,
      resonantFrequencyHz: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}resonant_frequency_hz'])!,
      qFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}q_factor'])!,
      peakAmplitudeDb: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}peak_amplitude_db'])!,
      dcrCorrected: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}dcr_corrected']),
      inductance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}inductance']),
      capacitance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}capacitance']),
      calibrationApplied: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}calibration_applied'])!,
      frequencyResponseDisplayJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frequency_response_display_json'])!,
      frequencyResponseStorageJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frequency_response_storage_json'])!,
    );
  }

  @override
  $MeasurementsTable createAlias(String alias) {
    return $MeasurementsTable(attachedDatabase, alias);
  }
}

class Measurement extends DataClass implements Insertable<Measurement> {
  final String id;
  final int timestampMs;
  final String pickupName;
  final String pickupType;
  final double dcr;
  final double ambientTempC;
  final double resonantFrequencyHz;
  final double qFactor;
  final double peakAmplitudeDb;
  final double? dcrCorrected;
  final double? inductance;
  final double? capacitance;
  final bool calibrationApplied;
  final String frequencyResponseDisplayJson;
  final String frequencyResponseStorageJson;
  const Measurement(
      {required this.id,
      required this.timestampMs,
      required this.pickupName,
      required this.pickupType,
      required this.dcr,
      required this.ambientTempC,
      required this.resonantFrequencyHz,
      required this.qFactor,
      required this.peakAmplitudeDb,
      this.dcrCorrected,
      this.inductance,
      this.capacitance,
      required this.calibrationApplied,
      required this.frequencyResponseDisplayJson,
      required this.frequencyResponseStorageJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp_ms'] = Variable<int>(timestampMs);
    map['pickup_name'] = Variable<String>(pickupName);
    map['pickup_type'] = Variable<String>(pickupType);
    map['dcr'] = Variable<double>(dcr);
    map['ambient_temp_c'] = Variable<double>(ambientTempC);
    map['resonant_frequency_hz'] = Variable<double>(resonantFrequencyHz);
    map['q_factor'] = Variable<double>(qFactor);
    map['peak_amplitude_db'] = Variable<double>(peakAmplitudeDb);
    if (!nullToAbsent || dcrCorrected != null) {
      map['dcr_corrected'] = Variable<double>(dcrCorrected);
    }
    if (!nullToAbsent || inductance != null) {
      map['inductance'] = Variable<double>(inductance);
    }
    if (!nullToAbsent || capacitance != null) {
      map['capacitance'] = Variable<double>(capacitance);
    }
    map['calibration_applied'] = Variable<bool>(calibrationApplied);
    map['frequency_response_display_json'] =
        Variable<String>(frequencyResponseDisplayJson);
    map['frequency_response_storage_json'] =
        Variable<String>(frequencyResponseStorageJson);
    return map;
  }

  MeasurementsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementsCompanion(
      id: Value(id),
      timestampMs: Value(timestampMs),
      pickupName: Value(pickupName),
      pickupType: Value(pickupType),
      dcr: Value(dcr),
      ambientTempC: Value(ambientTempC),
      resonantFrequencyHz: Value(resonantFrequencyHz),
      qFactor: Value(qFactor),
      peakAmplitudeDb: Value(peakAmplitudeDb),
      dcrCorrected: dcrCorrected == null && nullToAbsent
          ? const Value.absent()
          : Value(dcrCorrected),
      inductance: inductance == null && nullToAbsent
          ? const Value.absent()
          : Value(inductance),
      capacitance: capacitance == null && nullToAbsent
          ? const Value.absent()
          : Value(capacitance),
      calibrationApplied: Value(calibrationApplied),
      frequencyResponseDisplayJson: Value(frequencyResponseDisplayJson),
      frequencyResponseStorageJson: Value(frequencyResponseStorageJson),
    );
  }

  factory Measurement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Measurement(
      id: serializer.fromJson<String>(json['id']),
      timestampMs: serializer.fromJson<int>(json['timestampMs']),
      pickupName: serializer.fromJson<String>(json['pickupName']),
      pickupType: serializer.fromJson<String>(json['pickupType']),
      dcr: serializer.fromJson<double>(json['dcr']),
      ambientTempC: serializer.fromJson<double>(json['ambientTempC']),
      resonantFrequencyHz:
          serializer.fromJson<double>(json['resonantFrequencyHz']),
      qFactor: serializer.fromJson<double>(json['qFactor']),
      peakAmplitudeDb: serializer.fromJson<double>(json['peakAmplitudeDb']),
      dcrCorrected: serializer.fromJson<double?>(json['dcrCorrected']),
      inductance: serializer.fromJson<double?>(json['inductance']),
      capacitance: serializer.fromJson<double?>(json['capacitance']),
      calibrationApplied: serializer.fromJson<bool>(json['calibrationApplied']),
      frequencyResponseDisplayJson:
          serializer.fromJson<String>(json['frequencyResponseDisplayJson']),
      frequencyResponseStorageJson:
          serializer.fromJson<String>(json['frequencyResponseStorageJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestampMs': serializer.toJson<int>(timestampMs),
      'pickupName': serializer.toJson<String>(pickupName),
      'pickupType': serializer.toJson<String>(pickupType),
      'dcr': serializer.toJson<double>(dcr),
      'ambientTempC': serializer.toJson<double>(ambientTempC),
      'resonantFrequencyHz': serializer.toJson<double>(resonantFrequencyHz),
      'qFactor': serializer.toJson<double>(qFactor),
      'peakAmplitudeDb': serializer.toJson<double>(peakAmplitudeDb),
      'dcrCorrected': serializer.toJson<double?>(dcrCorrected),
      'inductance': serializer.toJson<double?>(inductance),
      'capacitance': serializer.toJson<double?>(capacitance),
      'calibrationApplied': serializer.toJson<bool>(calibrationApplied),
      'frequencyResponseDisplayJson':
          serializer.toJson<String>(frequencyResponseDisplayJson),
      'frequencyResponseStorageJson':
          serializer.toJson<String>(frequencyResponseStorageJson),
    };
  }

  Measurement copyWith(
          {String? id,
          int? timestampMs,
          String? pickupName,
          String? pickupType,
          double? dcr,
          double? ambientTempC,
          double? resonantFrequencyHz,
          double? qFactor,
          double? peakAmplitudeDb,
          Value<double?> dcrCorrected = const Value.absent(),
          Value<double?> inductance = const Value.absent(),
          Value<double?> capacitance = const Value.absent(),
          bool? calibrationApplied,
          String? frequencyResponseDisplayJson,
          String? frequencyResponseStorageJson}) =>
      Measurement(
        id: id ?? this.id,
        timestampMs: timestampMs ?? this.timestampMs,
        pickupName: pickupName ?? this.pickupName,
        pickupType: pickupType ?? this.pickupType,
        dcr: dcr ?? this.dcr,
        ambientTempC: ambientTempC ?? this.ambientTempC,
        resonantFrequencyHz: resonantFrequencyHz ?? this.resonantFrequencyHz,
        qFactor: qFactor ?? this.qFactor,
        peakAmplitudeDb: peakAmplitudeDb ?? this.peakAmplitudeDb,
        dcrCorrected:
            dcrCorrected.present ? dcrCorrected.value : this.dcrCorrected,
        inductance: inductance.present ? inductance.value : this.inductance,
        capacitance: capacitance.present ? capacitance.value : this.capacitance,
        calibrationApplied: calibrationApplied ?? this.calibrationApplied,
        frequencyResponseDisplayJson:
            frequencyResponseDisplayJson ?? this.frequencyResponseDisplayJson,
        frequencyResponseStorageJson:
            frequencyResponseStorageJson ?? this.frequencyResponseStorageJson,
      );
  Measurement copyWithCompanion(MeasurementsCompanion data) {
    return Measurement(
      id: data.id.present ? data.id.value : this.id,
      timestampMs:
          data.timestampMs.present ? data.timestampMs.value : this.timestampMs,
      pickupName:
          data.pickupName.present ? data.pickupName.value : this.pickupName,
      pickupType:
          data.pickupType.present ? data.pickupType.value : this.pickupType,
      dcr: data.dcr.present ? data.dcr.value : this.dcr,
      ambientTempC: data.ambientTempC.present
          ? data.ambientTempC.value
          : this.ambientTempC,
      resonantFrequencyHz: data.resonantFrequencyHz.present
          ? data.resonantFrequencyHz.value
          : this.resonantFrequencyHz,
      qFactor: data.qFactor.present ? data.qFactor.value : this.qFactor,
      peakAmplitudeDb: data.peakAmplitudeDb.present
          ? data.peakAmplitudeDb.value
          : this.peakAmplitudeDb,
      dcrCorrected: data.dcrCorrected.present
          ? data.dcrCorrected.value
          : this.dcrCorrected,
      inductance:
          data.inductance.present ? data.inductance.value : this.inductance,
      capacitance:
          data.capacitance.present ? data.capacitance.value : this.capacitance,
      calibrationApplied: data.calibrationApplied.present
          ? data.calibrationApplied.value
          : this.calibrationApplied,
      frequencyResponseDisplayJson: data.frequencyResponseDisplayJson.present
          ? data.frequencyResponseDisplayJson.value
          : this.frequencyResponseDisplayJson,
      frequencyResponseStorageJson: data.frequencyResponseStorageJson.present
          ? data.frequencyResponseStorageJson.value
          : this.frequencyResponseStorageJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Measurement(')
          ..write('id: $id, ')
          ..write('timestampMs: $timestampMs, ')
          ..write('pickupName: $pickupName, ')
          ..write('pickupType: $pickupType, ')
          ..write('dcr: $dcr, ')
          ..write('ambientTempC: $ambientTempC, ')
          ..write('resonantFrequencyHz: $resonantFrequencyHz, ')
          ..write('qFactor: $qFactor, ')
          ..write('peakAmplitudeDb: $peakAmplitudeDb, ')
          ..write('dcrCorrected: $dcrCorrected, ')
          ..write('inductance: $inductance, ')
          ..write('capacitance: $capacitance, ')
          ..write('calibrationApplied: $calibrationApplied, ')
          ..write(
              'frequencyResponseDisplayJson: $frequencyResponseDisplayJson, ')
          ..write('frequencyResponseStorageJson: $frequencyResponseStorageJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      timestampMs,
      pickupName,
      pickupType,
      dcr,
      ambientTempC,
      resonantFrequencyHz,
      qFactor,
      peakAmplitudeDb,
      dcrCorrected,
      inductance,
      capacitance,
      calibrationApplied,
      frequencyResponseDisplayJson,
      frequencyResponseStorageJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Measurement &&
          other.id == this.id &&
          other.timestampMs == this.timestampMs &&
          other.pickupName == this.pickupName &&
          other.pickupType == this.pickupType &&
          other.dcr == this.dcr &&
          other.ambientTempC == this.ambientTempC &&
          other.resonantFrequencyHz == this.resonantFrequencyHz &&
          other.qFactor == this.qFactor &&
          other.peakAmplitudeDb == this.peakAmplitudeDb &&
          other.dcrCorrected == this.dcrCorrected &&
          other.inductance == this.inductance &&
          other.capacitance == this.capacitance &&
          other.calibrationApplied == this.calibrationApplied &&
          other.frequencyResponseDisplayJson ==
              this.frequencyResponseDisplayJson &&
          other.frequencyResponseStorageJson ==
              this.frequencyResponseStorageJson);
}

class MeasurementsCompanion extends UpdateCompanion<Measurement> {
  final Value<String> id;
  final Value<int> timestampMs;
  final Value<String> pickupName;
  final Value<String> pickupType;
  final Value<double> dcr;
  final Value<double> ambientTempC;
  final Value<double> resonantFrequencyHz;
  final Value<double> qFactor;
  final Value<double> peakAmplitudeDb;
  final Value<double?> dcrCorrected;
  final Value<double?> inductance;
  final Value<double?> capacitance;
  final Value<bool> calibrationApplied;
  final Value<String> frequencyResponseDisplayJson;
  final Value<String> frequencyResponseStorageJson;
  final Value<int> rowid;
  const MeasurementsCompanion({
    this.id = const Value.absent(),
    this.timestampMs = const Value.absent(),
    this.pickupName = const Value.absent(),
    this.pickupType = const Value.absent(),
    this.dcr = const Value.absent(),
    this.ambientTempC = const Value.absent(),
    this.resonantFrequencyHz = const Value.absent(),
    this.qFactor = const Value.absent(),
    this.peakAmplitudeDb = const Value.absent(),
    this.dcrCorrected = const Value.absent(),
    this.inductance = const Value.absent(),
    this.capacitance = const Value.absent(),
    this.calibrationApplied = const Value.absent(),
    this.frequencyResponseDisplayJson = const Value.absent(),
    this.frequencyResponseStorageJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasurementsCompanion.insert({
    required String id,
    required int timestampMs,
    required String pickupName,
    required String pickupType,
    required double dcr,
    required double ambientTempC,
    required double resonantFrequencyHz,
    required double qFactor,
    required double peakAmplitudeDb,
    this.dcrCorrected = const Value.absent(),
    this.inductance = const Value.absent(),
    this.capacitance = const Value.absent(),
    required bool calibrationApplied,
    required String frequencyResponseDisplayJson,
    required String frequencyResponseStorageJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        timestampMs = Value(timestampMs),
        pickupName = Value(pickupName),
        pickupType = Value(pickupType),
        dcr = Value(dcr),
        ambientTempC = Value(ambientTempC),
        resonantFrequencyHz = Value(resonantFrequencyHz),
        qFactor = Value(qFactor),
        peakAmplitudeDb = Value(peakAmplitudeDb),
        calibrationApplied = Value(calibrationApplied),
        frequencyResponseDisplayJson = Value(frequencyResponseDisplayJson),
        frequencyResponseStorageJson = Value(frequencyResponseStorageJson);
  static Insertable<Measurement> custom({
    Expression<String>? id,
    Expression<int>? timestampMs,
    Expression<String>? pickupName,
    Expression<String>? pickupType,
    Expression<double>? dcr,
    Expression<double>? ambientTempC,
    Expression<double>? resonantFrequencyHz,
    Expression<double>? qFactor,
    Expression<double>? peakAmplitudeDb,
    Expression<double>? dcrCorrected,
    Expression<double>? inductance,
    Expression<double>? capacitance,
    Expression<bool>? calibrationApplied,
    Expression<String>? frequencyResponseDisplayJson,
    Expression<String>? frequencyResponseStorageJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestampMs != null) 'timestamp_ms': timestampMs,
      if (pickupName != null) 'pickup_name': pickupName,
      if (pickupType != null) 'pickup_type': pickupType,
      if (dcr != null) 'dcr': dcr,
      if (ambientTempC != null) 'ambient_temp_c': ambientTempC,
      if (resonantFrequencyHz != null)
        'resonant_frequency_hz': resonantFrequencyHz,
      if (qFactor != null) 'q_factor': qFactor,
      if (peakAmplitudeDb != null) 'peak_amplitude_db': peakAmplitudeDb,
      if (dcrCorrected != null) 'dcr_corrected': dcrCorrected,
      if (inductance != null) 'inductance': inductance,
      if (capacitance != null) 'capacitance': capacitance,
      if (calibrationApplied != null) 'calibration_applied': calibrationApplied,
      if (frequencyResponseDisplayJson != null)
        'frequency_response_display_json': frequencyResponseDisplayJson,
      if (frequencyResponseStorageJson != null)
        'frequency_response_storage_json': frequencyResponseStorageJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasurementsCompanion copyWith(
      {Value<String>? id,
      Value<int>? timestampMs,
      Value<String>? pickupName,
      Value<String>? pickupType,
      Value<double>? dcr,
      Value<double>? ambientTempC,
      Value<double>? resonantFrequencyHz,
      Value<double>? qFactor,
      Value<double>? peakAmplitudeDb,
      Value<double?>? dcrCorrected,
      Value<double?>? inductance,
      Value<double?>? capacitance,
      Value<bool>? calibrationApplied,
      Value<String>? frequencyResponseDisplayJson,
      Value<String>? frequencyResponseStorageJson,
      Value<int>? rowid}) {
    return MeasurementsCompanion(
      id: id ?? this.id,
      timestampMs: timestampMs ?? this.timestampMs,
      pickupName: pickupName ?? this.pickupName,
      pickupType: pickupType ?? this.pickupType,
      dcr: dcr ?? this.dcr,
      ambientTempC: ambientTempC ?? this.ambientTempC,
      resonantFrequencyHz: resonantFrequencyHz ?? this.resonantFrequencyHz,
      qFactor: qFactor ?? this.qFactor,
      peakAmplitudeDb: peakAmplitudeDb ?? this.peakAmplitudeDb,
      dcrCorrected: dcrCorrected ?? this.dcrCorrected,
      inductance: inductance ?? this.inductance,
      capacitance: capacitance ?? this.capacitance,
      calibrationApplied: calibrationApplied ?? this.calibrationApplied,
      frequencyResponseDisplayJson:
          frequencyResponseDisplayJson ?? this.frequencyResponseDisplayJson,
      frequencyResponseStorageJson:
          frequencyResponseStorageJson ?? this.frequencyResponseStorageJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestampMs.present) {
      map['timestamp_ms'] = Variable<int>(timestampMs.value);
    }
    if (pickupName.present) {
      map['pickup_name'] = Variable<String>(pickupName.value);
    }
    if (pickupType.present) {
      map['pickup_type'] = Variable<String>(pickupType.value);
    }
    if (dcr.present) {
      map['dcr'] = Variable<double>(dcr.value);
    }
    if (ambientTempC.present) {
      map['ambient_temp_c'] = Variable<double>(ambientTempC.value);
    }
    if (resonantFrequencyHz.present) {
      map['resonant_frequency_hz'] =
          Variable<double>(resonantFrequencyHz.value);
    }
    if (qFactor.present) {
      map['q_factor'] = Variable<double>(qFactor.value);
    }
    if (peakAmplitudeDb.present) {
      map['peak_amplitude_db'] = Variable<double>(peakAmplitudeDb.value);
    }
    if (dcrCorrected.present) {
      map['dcr_corrected'] = Variable<double>(dcrCorrected.value);
    }
    if (inductance.present) {
      map['inductance'] = Variable<double>(inductance.value);
    }
    if (capacitance.present) {
      map['capacitance'] = Variable<double>(capacitance.value);
    }
    if (calibrationApplied.present) {
      map['calibration_applied'] = Variable<bool>(calibrationApplied.value);
    }
    if (frequencyResponseDisplayJson.present) {
      map['frequency_response_display_json'] =
          Variable<String>(frequencyResponseDisplayJson.value);
    }
    if (frequencyResponseStorageJson.present) {
      map['frequency_response_storage_json'] =
          Variable<String>(frequencyResponseStorageJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('timestampMs: $timestampMs, ')
          ..write('pickupName: $pickupName, ')
          ..write('pickupType: $pickupType, ')
          ..write('dcr: $dcr, ')
          ..write('ambientTempC: $ambientTempC, ')
          ..write('resonantFrequencyHz: $resonantFrequencyHz, ')
          ..write('qFactor: $qFactor, ')
          ..write('peakAmplitudeDb: $peakAmplitudeDb, ')
          ..write('dcrCorrected: $dcrCorrected, ')
          ..write('inductance: $inductance, ')
          ..write('capacitance: $capacitance, ')
          ..write('calibrationApplied: $calibrationApplied, ')
          ..write(
              'frequencyResponseDisplayJson: $frequencyResponseDisplayJson, ')
          ..write(
              'frequencyResponseStorageJson: $frequencyResponseStorageJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalibrationsTable extends Calibrations
    with TableInfo<$CalibrationsTable, Calibration> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalibrationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMsMeta =
      const VerificationMeta('timestampMs');
  @override
  late final GeneratedColumn<int> timestampMs = GeneratedColumn<int>(
      'timestamp_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _spectrumJsonMeta =
      const VerificationMeta('spectrumJson');
  @override
  late final GeneratedColumn<String> spectrumJson = GeneratedColumn<String>(
      'spectrum_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, timestampMs, label, spectrumJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calibrations';
  @override
  VerificationContext validateIntegrity(Insertable<Calibration> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp_ms')) {
      context.handle(
          _timestampMsMeta,
          timestampMs.isAcceptableOrUnknown(
              data['timestamp_ms']!, _timestampMsMeta));
    } else if (isInserting) {
      context.missing(_timestampMsMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('spectrum_json')) {
      context.handle(
          _spectrumJsonMeta,
          spectrumJson.isAcceptableOrUnknown(
              data['spectrum_json']!, _spectrumJsonMeta));
    } else if (isInserting) {
      context.missing(_spectrumJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Calibration map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Calibration(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      timestampMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp_ms'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      spectrumJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}spectrum_json'])!,
    );
  }

  @override
  $CalibrationsTable createAlias(String alias) {
    return $CalibrationsTable(attachedDatabase, alias);
  }
}

class Calibration extends DataClass implements Insertable<Calibration> {
  final String id;
  final int timestampMs;
  final String label;
  final String spectrumJson;
  const Calibration(
      {required this.id,
      required this.timestampMs,
      required this.label,
      required this.spectrumJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp_ms'] = Variable<int>(timestampMs);
    map['label'] = Variable<String>(label);
    map['spectrum_json'] = Variable<String>(spectrumJson);
    return map;
  }

  CalibrationsCompanion toCompanion(bool nullToAbsent) {
    return CalibrationsCompanion(
      id: Value(id),
      timestampMs: Value(timestampMs),
      label: Value(label),
      spectrumJson: Value(spectrumJson),
    );
  }

  factory Calibration.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Calibration(
      id: serializer.fromJson<String>(json['id']),
      timestampMs: serializer.fromJson<int>(json['timestampMs']),
      label: serializer.fromJson<String>(json['label']),
      spectrumJson: serializer.fromJson<String>(json['spectrumJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestampMs': serializer.toJson<int>(timestampMs),
      'label': serializer.toJson<String>(label),
      'spectrumJson': serializer.toJson<String>(spectrumJson),
    };
  }

  Calibration copyWith(
          {String? id,
          int? timestampMs,
          String? label,
          String? spectrumJson}) =>
      Calibration(
        id: id ?? this.id,
        timestampMs: timestampMs ?? this.timestampMs,
        label: label ?? this.label,
        spectrumJson: spectrumJson ?? this.spectrumJson,
      );
  Calibration copyWithCompanion(CalibrationsCompanion data) {
    return Calibration(
      id: data.id.present ? data.id.value : this.id,
      timestampMs:
          data.timestampMs.present ? data.timestampMs.value : this.timestampMs,
      label: data.label.present ? data.label.value : this.label,
      spectrumJson: data.spectrumJson.present
          ? data.spectrumJson.value
          : this.spectrumJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Calibration(')
          ..write('id: $id, ')
          ..write('timestampMs: $timestampMs, ')
          ..write('label: $label, ')
          ..write('spectrumJson: $spectrumJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestampMs, label, spectrumJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Calibration &&
          other.id == this.id &&
          other.timestampMs == this.timestampMs &&
          other.label == this.label &&
          other.spectrumJson == this.spectrumJson);
}

class CalibrationsCompanion extends UpdateCompanion<Calibration> {
  final Value<String> id;
  final Value<int> timestampMs;
  final Value<String> label;
  final Value<String> spectrumJson;
  final Value<int> rowid;
  const CalibrationsCompanion({
    this.id = const Value.absent(),
    this.timestampMs = const Value.absent(),
    this.label = const Value.absent(),
    this.spectrumJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalibrationsCompanion.insert({
    required String id,
    required int timestampMs,
    required String label,
    required String spectrumJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        timestampMs = Value(timestampMs),
        label = Value(label),
        spectrumJson = Value(spectrumJson);
  static Insertable<Calibration> custom({
    Expression<String>? id,
    Expression<int>? timestampMs,
    Expression<String>? label,
    Expression<String>? spectrumJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestampMs != null) 'timestamp_ms': timestampMs,
      if (label != null) 'label': label,
      if (spectrumJson != null) 'spectrum_json': spectrumJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalibrationsCompanion copyWith(
      {Value<String>? id,
      Value<int>? timestampMs,
      Value<String>? label,
      Value<String>? spectrumJson,
      Value<int>? rowid}) {
    return CalibrationsCompanion(
      id: id ?? this.id,
      timestampMs: timestampMs ?? this.timestampMs,
      label: label ?? this.label,
      spectrumJson: spectrumJson ?? this.spectrumJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestampMs.present) {
      map['timestamp_ms'] = Variable<int>(timestampMs.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (spectrumJson.present) {
      map['spectrum_json'] = Variable<String>(spectrumJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationsCompanion(')
          ..write('id: $id, ')
          ..write('timestampMs: $timestampMs, ')
          ..write('label: $label, ')
          ..write('spectrumJson: $spectrumJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MeasurementsTable measurements = $MeasurementsTable(this);
  late final $CalibrationsTable calibrations = $CalibrationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [measurements, calibrations];
}

typedef $$MeasurementsTableCreateCompanionBuilder = MeasurementsCompanion
    Function({
  required String id,
  required int timestampMs,
  required String pickupName,
  required String pickupType,
  required double dcr,
  required double ambientTempC,
  required double resonantFrequencyHz,
  required double qFactor,
  required double peakAmplitudeDb,
  Value<double?> dcrCorrected,
  Value<double?> inductance,
  Value<double?> capacitance,
  required bool calibrationApplied,
  required String frequencyResponseDisplayJson,
  required String frequencyResponseStorageJson,
  Value<int> rowid,
});
typedef $$MeasurementsTableUpdateCompanionBuilder = MeasurementsCompanion
    Function({
  Value<String> id,
  Value<int> timestampMs,
  Value<String> pickupName,
  Value<String> pickupType,
  Value<double> dcr,
  Value<double> ambientTempC,
  Value<double> resonantFrequencyHz,
  Value<double> qFactor,
  Value<double> peakAmplitudeDb,
  Value<double?> dcrCorrected,
  Value<double?> inductance,
  Value<double?> capacitance,
  Value<bool> calibrationApplied,
  Value<String> frequencyResponseDisplayJson,
  Value<String> frequencyResponseStorageJson,
  Value<int> rowid,
});

class $$MeasurementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MeasurementsTable,
    Measurement,
    $$MeasurementsTableFilterComposer,
    $$MeasurementsTableOrderingComposer,
    $$MeasurementsTableCreateCompanionBuilder,
    $$MeasurementsTableUpdateCompanionBuilder> {
  $$MeasurementsTableTableManager(_$AppDatabase db, $MeasurementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MeasurementsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MeasurementsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> timestampMs = const Value.absent(),
            Value<String> pickupName = const Value.absent(),
            Value<String> pickupType = const Value.absent(),
            Value<double> dcr = const Value.absent(),
            Value<double> ambientTempC = const Value.absent(),
            Value<double> resonantFrequencyHz = const Value.absent(),
            Value<double> qFactor = const Value.absent(),
            Value<double> peakAmplitudeDb = const Value.absent(),
            Value<double?> dcrCorrected = const Value.absent(),
            Value<double?> inductance = const Value.absent(),
            Value<double?> capacitance = const Value.absent(),
            Value<bool> calibrationApplied = const Value.absent(),
            Value<String> frequencyResponseDisplayJson = const Value.absent(),
            Value<String> frequencyResponseStorageJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeasurementsCompanion(
            id: id,
            timestampMs: timestampMs,
            pickupName: pickupName,
            pickupType: pickupType,
            dcr: dcr,
            ambientTempC: ambientTempC,
            resonantFrequencyHz: resonantFrequencyHz,
            qFactor: qFactor,
            peakAmplitudeDb: peakAmplitudeDb,
            dcrCorrected: dcrCorrected,
            inductance: inductance,
            capacitance: capacitance,
            calibrationApplied: calibrationApplied,
            frequencyResponseDisplayJson: frequencyResponseDisplayJson,
            frequencyResponseStorageJson: frequencyResponseStorageJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int timestampMs,
            required String pickupName,
            required String pickupType,
            required double dcr,
            required double ambientTempC,
            required double resonantFrequencyHz,
            required double qFactor,
            required double peakAmplitudeDb,
            Value<double?> dcrCorrected = const Value.absent(),
            Value<double?> inductance = const Value.absent(),
            Value<double?> capacitance = const Value.absent(),
            required bool calibrationApplied,
            required String frequencyResponseDisplayJson,
            required String frequencyResponseStorageJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              MeasurementsCompanion.insert(
            id: id,
            timestampMs: timestampMs,
            pickupName: pickupName,
            pickupType: pickupType,
            dcr: dcr,
            ambientTempC: ambientTempC,
            resonantFrequencyHz: resonantFrequencyHz,
            qFactor: qFactor,
            peakAmplitudeDb: peakAmplitudeDb,
            dcrCorrected: dcrCorrected,
            inductance: inductance,
            capacitance: capacitance,
            calibrationApplied: calibrationApplied,
            frequencyResponseDisplayJson: frequencyResponseDisplayJson,
            frequencyResponseStorageJson: frequencyResponseStorageJson,
            rowid: rowid,
          ),
        ));
}

class $$MeasurementsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get timestampMs => $state.composableBuilder(
      column: $state.table.timestampMs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pickupName => $state.composableBuilder(
      column: $state.table.pickupName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pickupType => $state.composableBuilder(
      column: $state.table.pickupType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get dcr => $state.composableBuilder(
      column: $state.table.dcr,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get ambientTempC => $state.composableBuilder(
      column: $state.table.ambientTempC,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get resonantFrequencyHz => $state.composableBuilder(
      column: $state.table.resonantFrequencyHz,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get qFactor => $state.composableBuilder(
      column: $state.table.qFactor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get peakAmplitudeDb => $state.composableBuilder(
      column: $state.table.peakAmplitudeDb,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get dcrCorrected => $state.composableBuilder(
      column: $state.table.dcrCorrected,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get inductance => $state.composableBuilder(
      column: $state.table.inductance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get capacitance => $state.composableBuilder(
      column: $state.table.capacitance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get calibrationApplied => $state.composableBuilder(
      column: $state.table.calibrationApplied,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get frequencyResponseDisplayJson =>
      $state.composableBuilder(
          column: $state.table.frequencyResponseDisplayJson,
          builder: (column, joinBuilders) =>
              ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get frequencyResponseStorageJson =>
      $state.composableBuilder(
          column: $state.table.frequencyResponseStorageJson,
          builder: (column, joinBuilders) =>
              ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$MeasurementsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MeasurementsTable> {
  $$MeasurementsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get timestampMs => $state.composableBuilder(
      column: $state.table.timestampMs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pickupName => $state.composableBuilder(
      column: $state.table.pickupName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pickupType => $state.composableBuilder(
      column: $state.table.pickupType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get dcr => $state.composableBuilder(
      column: $state.table.dcr,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get ambientTempC => $state.composableBuilder(
      column: $state.table.ambientTempC,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get resonantFrequencyHz => $state.composableBuilder(
      column: $state.table.resonantFrequencyHz,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get qFactor => $state.composableBuilder(
      column: $state.table.qFactor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get peakAmplitudeDb => $state.composableBuilder(
      column: $state.table.peakAmplitudeDb,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get dcrCorrected => $state.composableBuilder(
      column: $state.table.dcrCorrected,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get inductance => $state.composableBuilder(
      column: $state.table.inductance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get capacitance => $state.composableBuilder(
      column: $state.table.capacitance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get calibrationApplied => $state.composableBuilder(
      column: $state.table.calibrationApplied,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get frequencyResponseDisplayJson =>
      $state.composableBuilder(
          column: $state.table.frequencyResponseDisplayJson,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get frequencyResponseStorageJson =>
      $state.composableBuilder(
          column: $state.table.frequencyResponseStorageJson,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CalibrationsTableCreateCompanionBuilder = CalibrationsCompanion
    Function({
  required String id,
  required int timestampMs,
  required String label,
  required String spectrumJson,
  Value<int> rowid,
});
typedef $$CalibrationsTableUpdateCompanionBuilder = CalibrationsCompanion
    Function({
  Value<String> id,
  Value<int> timestampMs,
  Value<String> label,
  Value<String> spectrumJson,
  Value<int> rowid,
});

class $$CalibrationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CalibrationsTable,
    Calibration,
    $$CalibrationsTableFilterComposer,
    $$CalibrationsTableOrderingComposer,
    $$CalibrationsTableCreateCompanionBuilder,
    $$CalibrationsTableUpdateCompanionBuilder> {
  $$CalibrationsTableTableManager(_$AppDatabase db, $CalibrationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CalibrationsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CalibrationsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> timestampMs = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String> spectrumJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CalibrationsCompanion(
            id: id,
            timestampMs: timestampMs,
            label: label,
            spectrumJson: spectrumJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int timestampMs,
            required String label,
            required String spectrumJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              CalibrationsCompanion.insert(
            id: id,
            timestampMs: timestampMs,
            label: label,
            spectrumJson: spectrumJson,
            rowid: rowid,
          ),
        ));
}

class $$CalibrationsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CalibrationsTable> {
  $$CalibrationsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get timestampMs => $state.composableBuilder(
      column: $state.table.timestampMs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get label => $state.composableBuilder(
      column: $state.table.label,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get spectrumJson => $state.composableBuilder(
      column: $state.table.spectrumJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CalibrationsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CalibrationsTable> {
  $$CalibrationsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get timestampMs => $state.composableBuilder(
      column: $state.table.timestampMs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get label => $state.composableBuilder(
      column: $state.table.label,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get spectrumJson => $state.composableBuilder(
      column: $state.table.spectrumJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MeasurementsTableTableManager get measurements =>
      $$MeasurementsTableTableManager(_db, _db.measurements);
  $$CalibrationsTableTableManager get calibrations =>
      $$CalibrationsTableTableManager(_db, _db.calibrations);
}
