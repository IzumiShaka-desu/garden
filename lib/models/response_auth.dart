class ResponseAuth {
  int status;
  bool isError;
  Map data;
  ResponseAuth({this.status, this.data, this.isError});
  factory ResponseAuth.fromJson(Map json) => ResponseAuth(
      status: json['status'], isError: json['error'], data: json['data']);
}
