import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Order {
  int? Id;
  String? Status;
  String? customerPhone;
  String? fromBuildingName;
  String? toBuildingName;
  String? storeName;
  String? storeImageUrl;
  String? customerName;
  int? CustomerId;
  int? BuildingId;
  String? toLat;
  String? toLng;
  String? fromLat;
  String? fromLng;
  String? customerImageUrl;

  Order(
      this.Id,
      this.Status,
      this.fromBuildingName,
      this.toBuildingName,
      this.storeName,
      this.storeImageUrl,
      this.customerName,
      this.BuildingId,
      this.CustomerId,
      this.customerPhone,
      this.fromLat,
      this.fromLng,
      this.toLat,
      this.toLng,
      this.customerImageUrl);

  int? getId() => this.Id;
  String? getStatus() => this.Status;
  int? getCustomerId() => this.CustomerId;
  int? getBuildingId() => this.BuildingId;
  String? getCustomerPhone() => this.customerPhone;
  String? getFromBuildingName() => this.fromBuildingName;
  String? getToBuildingName() => this.toBuildingName;
  String? getStoreName() => this.storeName;
  String? getStoreImageUrl() => this.storeImageUrl;
  String? getCustomerName() => this.customerName;
  String? getFromLat() => this.fromLat;
  String? getToLat() => this.toLat;
  String? getFromLng() => this.fromLng;
  String? getToLng() => this.toLng;
  String? getCustomerImageUrl() => this.customerImageUrl;


  Order.fromJson(Map<String, dynamic> json)
      : Id = json['id'],
        Status = json['status']["displayName"],
        fromBuildingName = json['fromBuilding']["name"],
        toBuildingName = json['toBuilding']["name"],
        storeName = json['store']["name"],
        storeImageUrl = json['store']["imageUrl"],
        customerName = json['customer']["name"],
        customerPhone = json['customer']['phone'],
        fromLat = json['fromBuilding']['latitude'].toString(),
        fromLng = json['fromBuilding']['longitude'].toString(),
        toLat = json['toBuilding']['latitude'].toString(),
        toLng = json['toBuilding']['longitude'].toString(),
        customerImageUrl = json['customer']['avatarUrl']
        ;

}
