class Episode {
  String serverName;
  List<EpisodeData> serverData;


  Episode({
    required this.serverName,
    required this.serverData,
  });

  factory Episode.fromJson(Map<String, dynamic> json){
    List<EpisodeData> listData = [];
    if(json["server_data"] != null){
      for(var item in json["server_data"]){
        listData.add(
          EpisodeData.fromJson(item)
        );
      }
    }
    return Episode(
      serverName: json["server_name"] ?? "",
      serverData: listData
    );
  }
}

class EpisodeData {
  String name;
  String slug;
  String filename;
  String linkM3u8;

  EpisodeData({
    required this.name,
    required this.slug,
    required this.filename,
    required this.linkM3u8,
  });

  factory EpisodeData.fromJson(Map<String, dynamic> json){
    return EpisodeData(
        name: json["name"] ?? "",
        slug: json["slug"] ?? "",
        filename: json["filename"] ?? "",
        linkM3u8: json["link_m3u8"] ?? "",
    );
  }

}