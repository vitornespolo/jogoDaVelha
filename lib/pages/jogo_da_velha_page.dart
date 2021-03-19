import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogodavelha/models/jogador_model.dart';

class JogoDaVelhaPage extends StatefulWidget {
  @override
  _JogoDaVelhaPageSate createState() => _JogoDaVelhaPageSate();
}

class _JogoDaVelhaPageSate extends State<JogoDaVelhaPage> {
  Jogador _jogadorDaVez;
  Jogador _jogadorX = Jogador(nome: 'X');
  Jogador _jogadorO = Jogador(nome: 'O');
  int _total = 0;
  bool _vitoria = false;

  List<List<Jogador>> _tabuleiro;

  @override
  void initState() {
    _jogadorDaVez = _jogadorX;
    _tabuleiro = [
      [null, null, null],
      [null, null, null],
      [null, null, null],
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da velha, jogador: ${_jogadorDaVez.nome}'),
        elevation: 0,
        backgroundColor: Colors.grey,
      ),
      body: Container(color: Colors.greenAccent, child: _createBoard()),
    );
  }

  Widget _createBoard() {
    final List<int> listaFixa =
        Iterable<int>.generate(_tabuleiro.length).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: listaFixa.map((j) => _createLinha(_tabuleiro[j], j)).toList(),
    );
  }

  Widget _createLinha(List<Jogador> linha, int j) {
    final List<int> listaFixa = Iterable<int>.generate(linha.length).toList();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            listaFixa.map((i) => _createPosition(linha[i], j, i)).toList(),
      ),
    );
  }

  Widget _createPosition(Jogador jogador, int j, int i) {
    return Container(
      child: GestureDetector(
        onTap: () {
          _jogada(j, i);
        },
        child: Container(
          height: 100,
          width: 100,
          color: Colors.white,
          child: Center(
            child: _criaImagemPosicao(jogador),
          ),
        ),
      ),
    );
  }

  Image _criaImagemPosicao(Jogador jogador) {
    if (jogador == null) {
      return null;
    }
    if (jogador.nome == 'X') {
      return Image.asset('assets/x.png');
    } else {
      return Image.asset('assets/o.png');
    }
  }

  resetGame() {
    Timer(
      Duration(seconds: 1),
      () {
        setState(
          () {
            _tabuleiro = [
              [null, null, null],
              [null, null, null],
              [null, null, null],
            ];
          },
        );
        _total = 0;
        _vitoria = false;
      },
    );
  }

  void _jogada(int j, int i) {
    if (_tabuleiro[j][i] == null) {
      setState(() => _tabuleiro[j][i] = _jogadorDaVez);
      _verificaGanhador();
      _trocaJogador();
      _total++;
    } else {
      _mostrarMensagem('Jogada invalida!');
    }
  }

  void _trocaJogador() {
    setState(() {
      _jogadorDaVez = _jogadorDaVez.nome == 'X' ? _jogadorO : _jogadorX;
    });
  }

  void _mostrarMensagem(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _verificaGanhador() {
    _verificarHorizontal();
    _verificarVertical();
    _verificaDiagonal();
    _empate();
  }

  void _verificarHorizontal() {
    for (var i = 0; i < 3; i++) {
      if (_tabuleiro[i][0] != null &&
          _tabuleiro[i][0] == _tabuleiro[i][1] &&
          _tabuleiro[i][0] == _tabuleiro[i][2]) {
        _mostrarMensagem('O jogador ${_tabuleiro[i][0].nome} ganhou!');
        _vitoria = true;
        resetGame();
      }
    }
  }

  void _verificarVertical() {
    for (var i = 0; i < 3; i++) {
      if (_tabuleiro[0][i] != null &&
          _tabuleiro[0][i] == _tabuleiro[1][i] &&
          _tabuleiro[0][i] == _tabuleiro[2][i]) {
        _mostrarMensagem('O jogador ${_tabuleiro[0][i].nome} ganhou!');
        _vitoria = true;
        resetGame();
      }
    }
  }

  void _verificaDiagonal() {
    if (_tabuleiro[0][0] != null &&
        _tabuleiro[0][0] == _tabuleiro[1][1] &&
        _tabuleiro[0][0] == _tabuleiro[2][2]) {
      _mostrarMensagem('O jogador ${_tabuleiro[0][0].nome} ganhou!');
      _vitoria = true;
      resetGame();
    } else if (_tabuleiro[0][2] != null &&
        _tabuleiro[0][2] == _tabuleiro[1][1] &&
        _tabuleiro[0][2] == _tabuleiro[2][0]) {
      _mostrarMensagem('O jogador ${_tabuleiro[0][2].nome} ganhou!');
      _vitoria = true;
      resetGame();
    }
  }

  void _empate() {
    if (_total == 8 && _vitoria == false) {
      _mostrarMensagem('Ninguem ganhou!');
      _vitoria = true;
      resetGame();
    }
    print(_total);
  }
}
