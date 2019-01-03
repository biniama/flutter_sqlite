// To parse this JSON data, do
//
//     final setting = settingFromJson(jsonString);

import 'dart:convert';

Setting settingFromJson(String str) {
    final jsonData = json.decode(str);
    return Setting.fromJson(jsonData);
}

String settingToJson(Setting data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class Setting {
    int id;
    String property;
    String value;
    bool expired;

    Setting({
        this.id,
        this.property,
        this.value,
        this.expired,
    });

    factory Setting.fromJson(Map<String, dynamic> json) => new Setting(
        id: json["id"],
        property: json["property"],
        value: json["value"],
        expired: json["expired"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "property": property,
        "value": value,
        "expired": expired,
    };
}
