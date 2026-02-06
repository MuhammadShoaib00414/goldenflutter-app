class SignalsResponse {
  bool? success;
  String? message;
  List<TradeSignal>? signals;

  SignalsResponse({this.success, this.message, this.signals});

  factory SignalsResponse.fromMap(Map<String, dynamic> json) {
    return SignalsResponse(
      success: json['success'],
      message: json['message'],
      signals: json['data']?['signals'] == null
          ? []
          : List<TradeSignal>.from(
              json['data']['signals'].map((x) => TradeSignal.fromJson(x)),
            ),
    );
  }
}

class TradeSignal {
  final String? id;
  final String symbol;
  final String orderType;
  final String entryZone;
  final String stopLoss;
  final String takeProfit1;
  final String? takeProfit2;
  final String? takeProfit3;
  final String? zoneValidity;
  final String tradeStatus;
  final String? tradeProbability;
  final String? adminNotes;
  final String? tradeStatusImage;
  TradeSignal({
    this.id,
    required this.symbol,
    required this.orderType,
    required this.entryZone,
    required this.stopLoss,
    required this.takeProfit1,
    this.takeProfit2,
    this.takeProfit3,
    this.zoneValidity,
    required this.tradeStatus,
    this.tradeProbability,
    this.adminNotes,
    this.tradeStatusImage,
  });

  factory TradeSignal.fromJson(Map<String, dynamic> json) {
    return TradeSignal(
      id: json['id']?.toString(),
      symbol: json['symbol']?.toString() ?? '',
      orderType: json['order_type']?.toString() ?? '',
      entryZone: json['entry_zone']?.toString() ?? '',
      stopLoss: json['stop_loss']?.toString() ?? '',
      takeProfit1: json['take_profit_1']?.toString() ?? '',
      takeProfit2: json['take_profit_2']?.toString(),
      takeProfit3: json['take_profit_3']?.toString(),
      zoneValidity: json['zone_validity']?.toString() ?? '',
      tradeStatus: json['trade_status']?.toString() ?? '',
      tradeProbability: json['trade_probability']?.toString(),
      adminNotes: json['admin_notes']?.toString(),
      tradeStatusImage: json["trade_status_image_url"]?.toString() ??'',     
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'order_type': orderType,
      'entry_zone': entryZone,
      'stop_loss': stopLoss,
      'take_profit_1': takeProfit1,
      'take_profit_2': takeProfit2,
      'take_profit_3': takeProfit3,
      'zone_validity': zoneValidity,
      'trade_status': tradeStatus,
      'trade_probability': tradeProbability,
      'admin_notes': adminNotes,
      'trade_status_image_url':tradeStatusImage,
      
    };
  }

  TradeSignal copyWith({
    String? id,
    String? symbol,
    String? orderType,
    String? entryZone,
    String? stopLoss,
    String? takeProfit1,
    String? takeProfit2,
    String? takeProfit3,
    String? zoneValidity,
    String? tradeStatus,
    String? tradeProbability,
    String? adminNotes,
    String? tradeStatusImage,
    
  }) {
    return TradeSignal(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      orderType: orderType ?? this.orderType,
      entryZone: entryZone ?? this.entryZone,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit1: takeProfit1 ?? this.takeProfit1,
      takeProfit2: takeProfit2 ?? this.takeProfit2,
      takeProfit3: takeProfit3 ?? this.takeProfit3,
      zoneValidity: zoneValidity ?? this.zoneValidity,
      tradeStatus: tradeStatus ?? this.tradeStatus,
      tradeProbability: tradeProbability ?? this.tradeProbability,
      adminNotes: adminNotes ?? this.adminNotes,
      tradeStatusImage: tradeStatusImage??this.tradeStatusImage,
     
    );
  }
}
