#include "n_tree.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../text/string_utils.h"


//-----------------------------------------------------------------------------
//		Functions                                                
//-----------------------------------------------------------------------------
void display_nodes(node* root)
{
	if(root == NULL) 
		return;

	char* node_label = (root->key).label;
    printf("%p [label=\"%s\"];\n", root, node_label);
	
	node* p=root->child;
	
	while (p)
	{
		display_nodes(p);
		p = p->brother;
	}
}

void display_edge(node* root, node* child)
{
	printf("%p, %p\n", root, child);
}

void display_edges(node* root)
{
	if(root == NULL) 
		return;

	node* p = root->child;
	
	while (p)
	{
		display_edge(root, p);
		display_edges(p);
		p = p->brother;
	}
}

void export_tree(void* tree)
{
    display_edges((node*) tree);
    display_nodes((node*) tree);
}

void __free_tree(node* root)
{
	if(root == NULL) 
		return;
	
	node* p = root->child;
	free(root);
	
	while (p)
	{
		node* i = p->brother;
		__free_tree(p);
		p=i;
	}	
}

void free_tree(void* tree)
{
    __free_tree((node*) tree);
}

node* create_node(node* n, node* parent)
{
	if (parent == NULL)
		return n;
	
	if (n == NULL)
		return parent;

	node* p = parent->child;
	
	if (!p) {
		parent->child = n;
	}
	else {
		while (p->brother)
			p = p->brother;

		p->brother = n;
	}
	return parent;
}

node* create_2node(node* child1, node* child2, node* parent)
{
	if (child2 == NULL)
		return create_node(child1, parent);

	if (child1 == NULL)
		return create_node(child2, parent);

	if (parent == NULL)
	{
		child1->brother = child2;
		return child1;
	}

	node* p = parent->child;
	if (!p) {
		parent->child = child1;
		parent->child->brother = child2;
	}
	else {
		while (p->brother)
			p = p->brother;

		p->brother = child1;
		p->brother->brother = child2;
	}
	return parent;
}

node* create_3node(node* child1, node* child2, node* child3, node* parent)
{
	if (parent == NULL)
	{
		child1->brother = child2;
		return child1;
	}

	node* p = parent->child;
	if (!p) {
		parent->child = child1;
		parent->child->brother = child2;
		parent->child->brother->brother = child3;
	}
	else {
		while (p->brother)
			p = p->brother;

		p->brother = child1;
		p->brother->brother = child2;
		p->brother->brother->brother = child3;
	}
	return parent;
}

node* create_json_node(node* n, node* parent)
{
	(n->key).label = replace_str((n->key).label, "\"", "\\\"");

	return create_node(n, parent);
}

node* to_node(lexeme lex, bool escape_quotes)
{
	node* new_node = (node*) malloc(sizeof(node));
	
	new_node->child = NULL;
	new_node->brother = NULL;
	new_node->key = generate_key_from_lexeme(lex, escape_quotes);

	return new_node;
}

lexeme generate_key_from_lexeme(lexeme lex, bool escape_quotes)
{
	lexeme key;

    key.label = lex.label;
    key.line_number = lex.line_number;

	if (escape_quotes)
		key.label = replace_str(key.label, "\"", "\\\"");

	return key;
}

node* merge_nodes_label(node* n1, node* n2)
{
	if (n2 == NULL)
		return n1;
	
	char* txt = (char*) malloc(sizeof(char)*10000);
	
	strcat(txt, (n1->key).label);
	strcat(txt, (n2->key).label);
	(n1->key).label = txt;
	
	return n1;
}
