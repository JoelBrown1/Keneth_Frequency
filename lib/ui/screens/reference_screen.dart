import 'package:flutter/material.dart';

import '../../domain/entities/pickup_profile.dart';
import '../../domain/services/pickup_reference_data.dart';
import '../theme/app_theme.dart';

// ── Sort column enum ──────────────────────────────────────────────────────────

enum _SortColumn { label, dcrMin, inductanceMin, freqMin }

// ── Screen ────────────────────────────────────────────────────────────────────

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  _SortColumn _sortColumn = _SortColumn.freqMin;
  bool _sortAscending = true;

  List<PickupProfile> get _sorted {
    final profiles = List<PickupProfile>.from(PickupReferenceData.profiles);
    profiles.sort((a, b) {
      int cmp;
      switch (_sortColumn) {
        case _SortColumn.label:
          cmp = a.label.compareTo(b.label);
        case _SortColumn.dcrMin:
          cmp = a.dcrRangeKohm.min.compareTo(b.dcrRangeKohm.min);
        case _SortColumn.inductanceMin:
          cmp = a.inductanceRangeH.min.compareTo(b.inductanceRangeH.min);
        case _SortColumn.freqMin:
          cmp = a.searchRangeHz.min.compareTo(b.searchRangeHz.min);
      }
      return _sortAscending ? cmp : -cmp;
    });
    return profiles;
  }

  void _onSort(_SortColumn col) {
    setState(() {
      if (_sortColumn == col) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = col;
        _sortAscending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profiles = _sorted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Reference'),
      ),
      body: Column(
        children: [
          // Sort header row.
          _SortHeader(
            sortColumn: _sortColumn,
            ascending: _sortAscending,
            onSort: _onSort,
          ),

          const Divider(height: 1),

          // Expandable rows.
          Expanded(
            child: ListView.separated(
              itemCount: profiles.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (context, i) =>
                  _ProfileTile(key: Key('ref_row_${profiles[i].type.name}'), profile: profiles[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sort header ───────────────────────────────────────────────────────────────

class _SortHeader extends StatelessWidget {
  const _SortHeader({
    required this.sortColumn,
    required this.ascending,
    required this.onSort,
  });

  final _SortColumn sortColumn;
  final bool ascending;
  final void Function(_SortColumn) onSort;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceVariant,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _SortButton(
              label: 'Pickup Type',
              column: _SortColumn.label,
              current: sortColumn,
              ascending: ascending,
              onSort: onSort,
            ),
          ),
          Expanded(
            flex: 2,
            child: _SortButton(
              label: 'DCR Range',
              column: _SortColumn.dcrMin,
              current: sortColumn,
              ascending: ascending,
              onSort: onSort,
            ),
          ),
          Expanded(
            flex: 2,
            child: _SortButton(
              label: 'Inductance',
              column: _SortColumn.inductanceMin,
              current: sortColumn,
              ascending: ascending,
              onSort: onSort,
            ),
          ),
          Expanded(
            flex: 2,
            child: _SortButton(
              label: 'Freq Range',
              column: _SortColumn.freqMin,
              current: sortColumn,
              ascending: ascending,
              onSort: onSort,
            ),
          ),
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({
    required this.label,
    required this.column,
    required this.current,
    required this.ascending,
    required this.onSort,
  });

  final String label;
  final _SortColumn column;
  final _SortColumn current;
  final bool ascending;
  final void Function(_SortColumn) onSort;

  @override
  Widget build(BuildContext context) {
    final isActive = column == current;
    return GestureDetector(
      onTap: () => onSort(column),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? AppTheme.primary : AppTheme.onSurfaceDim,
            ),
          ),
          if (isActive) ...[
            const SizedBox(width: 2),
            Icon(
              ascending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 12,
              color: AppTheme.primary,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Profile tile ──────────────────────────────────────────────────────────────

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({super.key, required this.profile});

  final PickupProfile profile;

  String _formatFreqRange(FrequencyRange r) {
    String _fmt(double hz) =>
        hz >= 1000 ? '${(hz / 1000).toStringAsFixed(0)}k' : '${hz.toInt()}';
    return '${_fmt(r.min)}–${_fmt(r.max)} Hz';
  }

  String _formatDcr(DcrRange r) =>
      '${r.min.toStringAsFixed(0)}–${r.max.toStringAsFixed(0)} kΩ';

  String _formatInductance(InductanceRange r) =>
      '${r.min.toStringAsFixed(0)}–${r.max.toStringAsFixed(0)} H';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        childrenPadding:
            const EdgeInsets.fromLTRB(16, 0, 16, 12),
        title: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profile.label,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  // Badges.
                  if (profile.verificationPickup != null)
                    _Badge(
                      label: 'Verification ref',
                      color: AppTheme.primary,
                    ),
                  if (profile.notMeasurable)
                    _Badge(
                      label: 'Not measurable — active electronics',
                      color: AppTheme.error,
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _formatDcr(profile.dcrRangeKohm),
                style: AppTheme.measurementSmall,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _formatInductance(profile.inductanceRangeH),
                style: AppTheme.measurementSmall,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                _formatFreqRange(profile.searchRangeHz),
                style: AppTheme.measurementSmall,
              ),
            ),
          ],
        ),
        children: [
          // Expanded detail: multimeter range + verification details.
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(6),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  label: 'Multimeter range',
                  value: '${profile.multimeterRangeKohm.toStringAsFixed(0)} kΩ',
                ),
                _DetailRow(
                  label: 'Inductance range',
                  value: _formatInductance(profile.inductanceRangeH),
                ),
                _DetailRow(
                  label: 'Resonant freq search',
                  value: _formatFreqRange(profile.searchRangeHz),
                ),
                if (profile.verificationPickup != null)
                  _DetailRow(
                    label: 'Verification pickup',
                    value: profile.verificationPickup!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withAlpha(100)),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.onSurfaceDim)),
          ),
          Expanded(
            child: Text(value, style: AppTheme.measurementSmall),
          ),
        ],
      ),
    );
  }
}
