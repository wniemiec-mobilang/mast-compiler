#include <stdio.h>
#include "export/DotExport.hpp"


//-----------------------------------------------------------------------------
//		Prototypes
//-----------------------------------------------------------------------------
extern int yyparse(void);
extern int yylex_destroy(void);

void *tree = NULL;
void export_tree(void *tree);
void free_tree(void *tree);


//-----------------------------------------------------------------------------
//		Main
//-----------------------------------------------------------------------------
int main(int argc, char **argv)
{
    int ret = yyparse();

    export_tree(tree);
    free_tree(tree);
    tree = NULL;
    yylex_destroy();

    wniemiec::mobilex::ama::DotExport dotExport();

    return ret;
}
