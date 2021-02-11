class RecordsCompassAxesResultModel {
  List<Axes> axes;
  DateTime calendarEntryAt;

  RecordsCompassAxesResultModel({this.axes, this.calendarEntryAt,});

  RecordsCompassAxesResultModel.fromJson(Map<String, dynamic> json) {
    if (json['axes'] != null) {
      axes = new List<Axes>();
      json['axes'].forEach((v) {
        axes.add(new Axes.fromJson(v));
      });
    }
    calendarEntryAt = DateTime.parse(json["calendarEntryAt"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.axes != null) {
      data['axes'] = this.axes.map((v) => v.toJson()).toList();
    }
    data["calendarEntryAt"] = calendarEntryAt.toIso8601String();
    return data;
  }
}

class Axes {
  double total;
  int min;
  double max;
  String name;
  double value;

  Axes({this.total, this.min, this.max, this.name, this.value});

  Axes.fromJson(Map<String, dynamic> json) {
    total = double.tryParse(json['total'].toString());
    min = json['min'];
    max = double.tryParse(json['max'].toString());
    name = json['name'];
    value = double.tryParse(json['value'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['min'] = this.min;
    data['max'] = this.max;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
