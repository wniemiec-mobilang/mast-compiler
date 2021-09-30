#include "arvore_n_aria.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../parser.tab.h"

PONT criaNovoNo(TIPOCHAVE ch){
	PONT novo = (PONT) malloc(sizeof(NO));
	novo->primFilho = NULL;
	novo->proxIrmao = NULL;
	novo->chave = ch;
	return(novo);
}

PONT inicializa(TIPOCHAVE ch){
	return (criaNovoNo(ch));
}

 PONT buscaChave(TIPOCHAVE ch, PONT raiz){
	 if(raiz == NULL) return NULL;
	 if(raiz->chave.numero_linha, ch.numero_linha) return raiz;
	 PONT p=raiz->primFilho;
	 while (p){
		 PONT resp=buscaChave(ch, p);
		 if(resp) return resp;
		 p=p->proxIrmao;
	 }
	 return NULL;
 }

bool insere(PONT raiz, TIPOCHAVE novaChave,  TIPOCHAVE chavePai){
  PONT pai = buscaChave(chavePai, raiz); 
  if(!pai) {	  
	  return(false);
  }  
  PONT filho = criaNovoNo(novaChave);
  PONT p = pai->primFilho;
  if (!p) {
     pai->primFilho = filho;
   }
  else {
   while  (p->proxIrmao)
    p= p->proxIrmao;

	p->proxIrmao = filho;
   }
  return(true);
}
//-------------------------------------------------------
void exibeArvore(PONT raiz){
	if(raiz==NULL) return;

    printf("%p [label= %s ];\n",raiz,(raiz->chave).label);
	PONT p=raiz->primFilho;
	while (p){
		exibeArvore(p);
		p=p->proxIrmao;
	}
}

void exporta (void* arvore)
{
    exibeArvore((PONT) arvore);
}

void liberaArvore(PONT raiz)
{
	if(raiz==NULL) return;
	
	//printf("%p [label=%d];\n",raiz,raiz->chave);
	PONT p=raiz->primFilho;
	free(raiz);
	
	while (p){
		liberaArvore(p);
		p=p->proxIrmao;
	}	
}

void libera(void* arvore)
{
    liberaArvore((PONT) arvore);
}
