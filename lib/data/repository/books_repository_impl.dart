import 'dart:io';

import 'package:books_app/core/constants/constants.dart';
import 'package:books_app/core/resources/data_state.dart';
import 'package:books_app/data/sources/remote/books_service.dart';
import 'package:books_app/domain/repository/books_repository.dart';
import 'package:dio/dio.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksService _booksService;

  BooksRepositoryImpl(this._booksService);

  @override
  Future<DataState> getBooks() async {
    try {
      final httpResponse =
          await _booksService.getBooks(q: q, download: download, key: key);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSucess(httpResponse.data);
      } else {
        return DataError(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataError(e);
    }
  }
}
