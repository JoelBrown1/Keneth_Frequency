class AudioDeviceInfo {
  const AudioDeviceInfo({
    required this.id,
    required this.name,
    required this.inputChannels,
    required this.outputChannels,
    required this.nominalSampleRate,
    required this.isScarlett,
  });

  /// CoreAudio UID string — pass this back as `deviceId` to `openSession`.
  final String id;
  final String name;
  final int inputChannels;
  final int outputChannels;
  final double nominalSampleRate;

  /// Pre-computed by the Swift layer using VID/PID matching.
  final bool isScarlett;

  factory AudioDeviceInfo.fromJson(Map<String, dynamic> json) {
    return AudioDeviceInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      inputChannels: (json['inputChannels'] as num).toInt(),
      outputChannels: (json['outputChannels'] as num).toInt(),
      nominalSampleRate: (json['nominalSampleRate'] as num).toDouble(),
      isScarlett: json['isScarlett'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'inputChannels': inputChannels,
        'outputChannels': outputChannels,
        'nominalSampleRate': nominalSampleRate,
        'isScarlett': isScarlett,
      };

  @override
  bool operator ==(Object other) =>
      other is AudioDeviceInfo && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
