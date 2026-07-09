class PlayerProfile {
  final String displayName;
  final String avatarIcon;
  final int totalPotionsCreated;

  const PlayerProfile({
    this.displayName = 'Alchemist',
    this.avatarIcon = 'science', // Material icon name
    this.totalPotionsCreated = 0,
  });

  PlayerProfile copyWith({
    String? displayName,
    String? avatarIcon,
    int? totalPotionsCreated,
  }) {
    return PlayerProfile(
      displayName: displayName ?? this.displayName,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      totalPotionsCreated: totalPotionsCreated ?? this.totalPotionsCreated,
    );
  }
}
