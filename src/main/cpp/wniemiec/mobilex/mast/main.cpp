#include <iostream>
#include <string>
#include <experimental/filesystem>
#include "export/DotExport.hpp"

namespace mast = wniemiec::mobilex::mast;
namespace fs = std::experimental::filesystem;

//-----------------------------------------------------------------------------
//		Prototypes
//-----------------------------------------------------------------------------
extern "C" int yyparse(void);
extern "C" int yylex_destroy(void);

extern "C" void *tree = NULL;
extern "C" void export_tree(void *tree, const char* output);
extern "C" void free_tree(void *tree);
std::string extract_name_from_file(std::string path);


//-----------------------------------------------------------------------------
//		Main
//-----------------------------------------------------------------------------
int main(int argc, char **argv)
{
    std::string mobilang_file = std::string(argv[1]);
    std::string output = std::string(argv[2]) + "/ast/";
    std::string ast = output + extract_name_from_file(mobilang_file) + ".ast";

    if (!fs::is_directory(output) || !fs::exists(output)) {
        fs::create_directory(output);
    }

    int ret = yyparse();

    export_tree(tree, ast.c_str());
    free_tree(tree);
    tree = NULL;
    yylex_destroy();

    mast::DotExport dotExport = mast::DotExport(ast, output);
    dotExport.run();

    fs::remove(ast);

    return ret;
}


//-----------------------------------------------------------------------------
//		Functions
//-----------------------------------------------------------------------------
std::string extract_name_from_file(std::string path)
{
    std::string filename = fs::canonical(path).stem();
    int indexOfFirstDot = filename.find(".");
    
    return filename.substr(0, indexOfFirstDot);
}
