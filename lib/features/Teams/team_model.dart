class TeamModel {
  final String teamName;
  final String imgUrl;
  final String teamShortName;
  final String teamLocation;
  final Map<String, dynamic> stats;

  TeamModel({
    required this.teamName,
    required this.imgUrl,
    required this.teamShortName,
    required this.teamLocation,
    required this.stats,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      teamName: json['team_name'],
      imgUrl: json['imgurl'],
      teamShortName: json['teamshortname'],
      teamLocation: json['team_location'],
      stats: json['stats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_name': teamName,
      'imgurl': imgUrl,
      'teamshortname': teamShortName,
      'team_location': teamLocation,
      'stats': stats,
    };
  }
}
