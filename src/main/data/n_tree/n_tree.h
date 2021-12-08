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


//-----------------------------------------------------------------------------
//		Prototypes                                                
//-----------------------------------------------------------------------------
void display_nodes(node* root);
void display_edges(node* root);
void display_edge(node* root, node* child);
void __free_tree(node* root);
void free_tree(void* tree);
void export_tree(void* tree);
node* create_node(node* n, node* parent);
node* create_2node(node* child1, node* child2, node* parent);
node* create_3node(node* child1, node* child2, node* child3, node* parent);
node* create_json_node(node* n, node* parent);
node* to_node(lexeme lex, bool escape_quotes);
lexeme generate_key_from_lexeme(lexeme lex, bool escape_quotes);
node* merge_nodes_label(node* n1, node* n2);
