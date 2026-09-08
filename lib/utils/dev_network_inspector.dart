import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume_plus/flutter_ume_plus.dart';

class DevNetworkInspector extends StatefulWidget implements Pluggable {
  DevNetworkInspector({Key? key, required Dio dio}) : super(key: key) {
    _install(dio);
  }

  static final List<_NetworkRecord> _records = <_NetworkRecord>[];
  static final StreamController<List<_NetworkRecord>> _recordsController =
      StreamController<List<_NetworkRecord>>.broadcast();
  static bool _installed = false;

  @override
  String get name => 'DevNetworkInspector';

  @override
  String get displayName => 'Network';

  @override
  ImageProvider get iconImageProvider =>
      const AssetImage('assets/images/logo_icon.webp');

  @override
  Widget? buildWidget(BuildContext? context) => const _NetworkInspectorPage();

  @override
  void onTrigger() {}

  @override
  State<DevNetworkInspector> createState() => _DevNetworkInspectorState();

  void _install(Dio dio) {
    if (_installed) return;
    _installed = true;
    dio.interceptors.add(_DevNetworkInterceptor());
  }

  static void _addRecord(_NetworkRecord record) {
    _records.insert(0, record);
    if (_records.length > 200) {
      _records.removeRange(200, _records.length);
    }
    _recordsController.add(List<_NetworkRecord>.unmodifiable(_records));
  }

  static void _clear() {
    _records.clear();
    _recordsController.add(List<_NetworkRecord>.unmodifiable(_records));
  }
}

class _DevNetworkInspectorState extends State<DevNetworkInspector> {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _DevNetworkInterceptor extends InterceptorsWrapper {
  static const String _requestIdKey = '_dev_network_request_id';
  int _nextRequestId = 0;
  final Map<int, _PendingRequest> _pendingRequests = <int, _PendingRequest>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final int requestId = _nextRequestId++;
    options.extra[_requestIdKey] = requestId;
    _pendingRequests[requestId] = _PendingRequest(
      method: options.method,
      uri: options.uri.toString(),
      data: _stringify(options.data),
      queryParameters: _stringify(options.queryParameters),
      startedAt: DateTime.now(),
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final _PendingRequest? pending = _takePending(response.requestOptions);
    if (pending != null) {
      DevNetworkInspector._addRecord(
        _NetworkRecord(
          method: pending.method,
          uri: pending.uri,
          statusCode: response.statusCode,
          durationMs:
              DateTime.now().difference(pending.startedAt).inMilliseconds,
          requestData: pending.data,
          queryParameters: pending.queryParameters,
          responseData: _stringify(response.data),
          error: '',
          createdAt: DateTime.now(),
        ),
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final _PendingRequest? pending = _takePending(err.requestOptions);
    DevNetworkInspector._addRecord(
      _NetworkRecord(
        method: pending?.method ?? err.requestOptions.method,
        uri: pending?.uri ?? err.requestOptions.uri.toString(),
        statusCode: err.response?.statusCode,
        durationMs: pending == null
            ? 0
            : DateTime.now().difference(pending.startedAt).inMilliseconds,
        requestData: pending?.data ?? _stringify(err.requestOptions.data),
        queryParameters: pending?.queryParameters ??
            _stringify(err.requestOptions.queryParameters),
        responseData: _stringify(err.response?.data),
        error: err.message,
        createdAt: DateTime.now(),
      ),
    );
    handler.next(err);
  }

  _PendingRequest? _takePending(RequestOptions options) {
    final Object? id = options.extra[_requestIdKey];
    return id is int ? _pendingRequests.remove(id) : null;
  }

  static String _stringify(Object? value) {
    if (value == null) return '';
    try {
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(value);
    } catch (_) {
      return value.toString();
    }
  }
}

class _NetworkInspectorPage extends StatelessWidget {
  const _NetworkInspectorPage();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF101114),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Network',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: DevNetworkInspector._clear,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<_NetworkRecord>>(
                stream: DevNetworkInspector._recordsController.stream,
                initialData: List<_NetworkRecord>.unmodifiable(
                    DevNetworkInspector._records),
                builder: (context, snapshot) {
                  final List<_NetworkRecord> records =
                      snapshot.data ?? const <_NetworkRecord>[];
                  if (records.isEmpty) {
                    return const Center(
                      child: Text(
                        'No requests',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: records.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: Color(0xFF2B2D33),
                    ),
                    itemBuilder: (context, index) =>
                        _NetworkRecordTile(record: records[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkRecordTile extends StatelessWidget {
  const _NetworkRecordTile({required this.record});

  final _NetworkRecord record;

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        record.isError ? const Color(0xFFFF5A5A) : const Color(0xFF4CD964);
    return ExpansionTile(
      collapsedIconColor: Colors.white70,
      iconColor: Colors.white,
      tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF252832),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  record.method,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${record.statusLabel}  ${record.durationMs}ms',
                style: TextStyle(color: statusColor, fontSize: 13),
              ),
              const SizedBox(width: 8),
              Text(
                record.timeLabel,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            record.hostLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            record.pathLabel,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.25,
            ),
          ),
        ],
      ),
      children: [
        _DetailBlock(label: 'URL', value: record.uri),
        _DetailBlock(label: 'Query', value: record.queryParameters),
        _DetailBlock(label: 'Request', value: record.requestData),
        _DetailBlock(label: 'Response', value: record.responseData),
        _DetailBlock(label: 'Error', value: record.error),
      ],
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF191B20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFFB20E),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(
            value,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _PendingRequest {
  _PendingRequest({
    required this.method,
    required this.uri,
    required this.data,
    required this.queryParameters,
    required this.startedAt,
  });

  final String method;
  final String uri;
  final String data;
  final String queryParameters;
  final DateTime startedAt;
}

class _NetworkRecord {
  _NetworkRecord({
    required this.method,
    required this.uri,
    required this.statusCode,
    required this.durationMs,
    required this.requestData,
    required this.queryParameters,
    required this.responseData,
    required this.error,
    required this.createdAt,
  });

  final String method;
  final String uri;
  final int? statusCode;
  final int durationMs;
  final String requestData;
  final String queryParameters;
  final String responseData;
  final String error;
  final DateTime createdAt;

  bool get isError =>
      error.isNotEmpty || (statusCode != null && statusCode! >= 400);

  String get statusLabel => statusCode == null ? 'ERR' : '$statusCode';

  String get hostLabel {
    final Uri? parsed = Uri.tryParse(uri);
    if (parsed == null || parsed.host.isEmpty) return uri;
    final String port = parsed.hasPort ? ':${parsed.port}' : '';
    return '${parsed.scheme}://${parsed.host}$port';
  }

  String get pathLabel {
    final Uri? parsed = Uri.tryParse(uri);
    if (parsed == null || parsed.path.isEmpty) return uri;
    final String query = parsed.hasQuery ? '?${parsed.query}' : '';
    return '${parsed.path}$query';
  }

  String get timeLabel {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(createdAt.hour)}:${two(createdAt.minute)}:${two(createdAt.second)}';
  }
}
