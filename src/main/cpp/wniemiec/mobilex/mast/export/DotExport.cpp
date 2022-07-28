/**
 * Copyright (c) William Niemiec.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "DotExport.hpp"

#include <iostream>
#include <fstream>
#include <experimental/filesystem>
#include <string>
#include <list>
#include <vector>
#include <string.h>
#include <map>
#include <algorithm>
#include <sys/types.h>
#include <sys/stat.h>
#include "../../../../../../../lib/StringUtils/StringUtils.hpp"

using namespace wniemiec::mobilex::mast;
namespace fs = std::experimental::filesystem;


//-----------------------------------------------------------------------------
//		Constructor
//-----------------------------------------------------------------------------
DotExport::DotExport(char* ast, char* output) 
    : DotExport(std::string(ast), std::string(output))
{
}

DotExport::DotExport(std::string ast, std::string output)
{
    this->ast = ast;
    ast_content = {};
    dict_nodes = {};
    node_count = 0;

    set_output(output + "/" + fs::path(ast).stem().c_str() + ".dot");
}


//-----------------------------------------------------------------------------
//		Methods
//-----------------------------------------------------------------------------
void DotExport::run() 
{
    read_ast();
    write_ast_in_dot_file();
}

void DotExport::read_ast()
{
    std::ifstream opened_ast(ast);
    std::string line;

    while (std::getline(opened_ast, line))
    {
        ast_content.push_back(line);
    }
}

void DotExport::write_ast_in_dot_file()
{
    cleanup_output();
    open_output_file();
    write_header();
    write_body();
    write_footer();
    close_output_file();
    setup_output_permissions();
}

void DotExport::cleanup_output()
{
    if (!fs::is_directory(output)) {
        std::remove(output.c_str());
    }
}

void DotExport::open_output_file()
{
    opened_output.open(output);
}

void DotExport::write_header()
{
    opened_output << "digraph G {\n";
}

void DotExport::write_body()
{
    for (std::string line : ast_content)
    {
        std::string new_line = line;

        if (is_edge(line)) {
            write_edge(line);
        }
        else {
           write_node(line);
        }
    }
}

bool DotExport::is_edge(std::string line)
{
    return (line.find("[") == std::string::npos);
}

void DotExport::write_edge(std::string line)
{
    std::string new_line = line;
    std::vector<std::string> nodes = wniemiec::util::cpp::StringUtils::split(
        wniemiec::util::cpp::StringUtils::replace_all(line, "\n", ""), 
        ", "
    );

    for (std::string node : nodes) {
        if (!dict_nodes.count(node)) {
            dict_nodes[node] = "n" + std::to_string(node_count);
            node_count++;
        }
    }

    new_line = wniemiec::util::cpp::StringUtils::replace_all(line, ", ", " -> ");
    for (std::string node : nodes) {
        new_line = wniemiec::util::cpp::StringUtils::replace_all(new_line, node, dict_nodes[node]);
    }

    new_line = wniemiec::util::cpp::StringUtils::replace_all(new_line, "\n", "") + ";\n";
    opened_output << new_line;
}

void DotExport::write_node(std::string line)
{
    std::string node = wniemiec::util::cpp::StringUtils::split(line, " ")[0];
    std::string new_line = wniemiec::util::cpp::StringUtils::replace_all(line, node, dict_nodes[node]);

    opened_output << new_line << "\n";
}

void DotExport::write_footer()
{
    opened_output << "\n}";
}

void DotExport::close_output_file()
{
    opened_output.close();
}

void DotExport::setup_output_permissions()
{
    chmod(output.c_str(), S_IRWXU);
}


//-----------------------------------------------------------------------------
//		Setters
//-----------------------------------------------------------------------------
void DotExport::set_output(std::string path)
{
    std::string normalized_path = path;
    std::replace(normalized_path.begin(), normalized_path.end(), '\\', '/');

    this->output = normalized_path;
}