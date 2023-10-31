import 'dart:developer';

import 'package:cep/models/endereco.dart';
import 'package:dio/dio.dart';

import 'repos_cep.dart';

class CepReposImp implements CepRepos {
  @override
  Future<Endereco> getCep(String cep) async {
    try {
      final resultado = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      return Endereco.fromMap(resultado.data);
    } on DioError catch (e) {
      log('erro ao buscar dados do CEP', error: e);
      throw Exception('erro ao buscar cep');
    }
  }
}
