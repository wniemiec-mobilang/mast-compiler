#pragma once

#include <stdio.h>
#include <stdbool.h>
#include "../../lexeme.h"

typedef lexeme KEY;

typedef struct __node {
	KEY key;
	struct __node* child;
	struct __node* brother;
} node;

void display_nodes(node* root);
void display_edges(node* root);
void display_edge(node* root, node* child);
void __free_tree(node* root);
void free_tree(void* tree);
void export_tree(void* tree);
node* create_node(node* n, node* parent);
node* create_2node(node* child1, node* child2, node* parent);
node* create_3node(node* child1, node* child2, node* child3, node* parent);
