class RSS {
  RSS({
    required this.name,
    required this.showName,
    required this.subscribeUrl,
    required this.type,
    required this.autoUpdate,
    this.data = null,
  });

  final String name;
  final String showName;
  final String subscribeUrl;
  final int type;
  final bool autoUpdate;
  dynamic data;

  RSS.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        showName = json['show_name'],
        subscribeUrl = json['subscribe_url'],
        type = json['type'],
        autoUpdate = json['auto_update'];

  Map<String, dynamic> toJson() => {
        "name": name,
        "show_name": showName,
        "subscribe_url": subscribeUrl,
        'type': type,
        'auto_update': autoUpdate,
      };
}
