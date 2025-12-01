import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService({Dio? client})
      : dio = client ??
            Dio(
              BaseOptions(
                baseUrl: 'http://localhost:3000',
                connectTimeout: const Duration(milliseconds: 5000),
                receiveTimeout: const Duration(milliseconds: 5000),
              ),
            ) {
    dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
      ),
    );
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> payload) async {
    final r = await dio.post('/tasks', data: payload);
    return Map<String, dynamic>.from(r.data);
  }

  Future<Map<String, dynamic>> updateTask(
      String id, Map<String, dynamic> payload) async {
    final r = await dio.put('/tasks/$id', data: payload);
    return Map<String, dynamic>.from(r.data);
  }

  Future<List<dynamic>> fetchTasks() async {
    final r = await dio.get('/tasks');
    return r.data as List<dynamic>;
  }
}
