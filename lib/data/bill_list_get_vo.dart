class BillListGetVO {
  String? date;
  List<Data>? data;

  BillListGetVO({this.date, this.data});

  BillListGetVO.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? name;
  String? artist;
  String? image;
  int? rank;
  int? lastWeekRank;
  int? peakRank;
  int? weeksOnChart;

  Data(
      {this.name,
      this.artist,
      this.image,
      this.rank,
      this.lastWeekRank,
      this.peakRank,
      this.weeksOnChart});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    artist = json['artist'];
    image = json['image'];
    rank = json['rank'];
    lastWeekRank = json['last_week_rank'];
    peakRank = json['peak_rank'];
    weeksOnChart = json['weeks_on_chart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['artist'] = artist;
    data['image'] = image;
    data['rank'] = rank;
    data['last_week_rank'] = lastWeekRank;
    data['peak_rank'] = peakRank;
    data['weeks_on_chart'] = weeksOnChart;
    return data;
  }
}
