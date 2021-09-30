#pragma once

typedef struct {
    int numero_linha;
    int tipo_token;
    int tipo_literal;
    char* label;
    struct {
        char* valor_cadeia_caracteres;
        char valor_char;
        int valor_int;
        float valor_float;
    } valor_token;
} conteudo_lexico;

static conteudo_lexico __conteudo_lexico_NULL = {
    .numero_linha = -1,
    .tipo_token = -1,
    .tipo_literal = -1,
    .label = "NULL"
};

#ifndef conteudo_lexico_NULL
#   define conteudo_lexico_NULL __conteudo_lexico_NULL
#endif
