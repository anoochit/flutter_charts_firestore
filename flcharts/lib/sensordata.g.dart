import 'package:cloud_firestore/cloud_firestore.dart';

class Sensordata {
  double cpuUsage;
  double memTotal;
  double memUsage;
  Timestamp timeStamp;

  Sensordata({
    this.cpuUsage,
    this.memTotal,
    this.memUsage,
    this.timeStamp,
  });
  Sensordata.fromJson(Map<String, dynamic> json) {
    cpuUsage = json["cpuUsage"]?.toDouble();
    memTotal = json["memTotal"]?.toDouble();
    memUsage = json["memUsage"]?.toDouble();
    timeStamp = json["timeStamp"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["cpuUsage"] = cpuUsage;
    data["memTotal"] = memTotal;
    data["memUsage"] = memUsage;
    data["timeStamp"] = timeStamp;
    return data;
  }
}
