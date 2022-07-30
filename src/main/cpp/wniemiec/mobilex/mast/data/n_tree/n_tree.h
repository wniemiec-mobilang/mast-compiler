#pragma once

#include <stdio.h>
#include <stdbool.h>
#include "../../syntax/lexeme.h"


//-----------------------------------------------------------------------------
//		Data definitions                                                
//-----------------------------------------------------------------------------
typedef lexeme KEY;

typedef struct __node {
	KEY key;
	struct __node* child;
	struct __node* brother;
	char* properties;
} node;

typedef struct __list_node {
	node* value;
	struct __list_node* next;
} list_node;


//-----------------------------------------------------------------------------
//		Prototypes                                                
//-----------------------------------------------------------------------------
void display_nodes(node* root, FILE* output_file);
void display_edges(node* root, FILE* output_file);
void display_edge(node* root, node* child, FILE* output_file);
void __free_tree(node* root);
void free_tree(void* tree);
void export_tree(void* tree, const char* output);
node* create_node(node* n, node* parent);
node* create_2node(node* child1, node* child2, node* parent);
node* create_3node(node* child1, node* child2, node* child3, node* parent);
node* create_n_node(list_node* nodes, node* parent);
node* create_json_node(node* n, node* parent);
node* to_node(lexeme lex, bool escape_quotes);
lexeme generate_key_from_lexeme(lexeme lex, bool escape_quotes);
node* merge_nodes_label(node* n1, node* n2);
void append_list_nodes(node* n, list_node* nodes);
list_node* initialize_list_nodes();
