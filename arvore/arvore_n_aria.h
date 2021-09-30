#pragma once

#include <stdio.h>
#include "../conteudo_lexico.h"

#define true 1
#define false 0

typedef int bool;
typedef conteudo_lexico TIPOCHAVE;

/**
 * Representacao de um nodo.
 */
typedef struct no{
	TIPOCHAVE chave;
	struct no *primFilho;
	struct no *proxIrmao;
} NO;

typedef NO *PONT;


PONT criaNovoNo(TIPOCHAVE ch);
PONT inicializa(TIPOCHAVE ch);
PONT buscaChave(TIPOCHAVE ch, PONT raiz);
bool insere(PONT raiz, TIPOCHAVE novaChave,  TIPOCHAVE chavePai);
void exibeArvore(PONT raiz);
void liberaArvore(PONT raiz);
void libera(void* arvore);
void exporta (void* arvore);
