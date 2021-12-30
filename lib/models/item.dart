class Item {
  String itemName;
  String originalRate;
  String subsidyRate;
  String perDayLimit;
  String itemImage;
  String status;
  String type;
  String fromTime;
  String toTime;

  Item(
      {this.itemName,
      this.originalRate,
      this.subsidyRate,
      this.perDayLimit,
      this.itemImage,
      this.status,
      this.type,
      this.fromTime,
      this.toTime});

  Item.fromJson(Map<String, dynamic> json) {
    this.itemName = json['item'];
    this.originalRate = json['original_rate'];
    this.subsidyRate = json['subsidy_rate'];
    this.perDayLimit = json['limit'];
    this.itemImage = json['item_image'];
    this.status = json['status'];
    this.type = json['type'];
    this.fromTime = json['from_time'];
    this.toTime = json['to_time'];
  }
}
