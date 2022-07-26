/**
 * Copyright (c) William Niemiec.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <iostream>
#include <fstream>
#include <list>
#include <vector>
#include <map>

namespace wniemiec { namespace mobilex { namespace mast {

    /**
     * Responsible for exporting GraphViz file from a Mobilang abstract syntax
     * tree.
     */
    class DotExport 
    {
    //-------------------------------------------------------------------------
    //		Attributes
    //-------------------------------------------------------------------------
    private:
        std::string ast;
        std::string output;
        std::ofstream opened_output;
        std::list<std::string> ast_content;
        std::map<std::string, std::string> dict_nodes;
        int node_count;


    //-------------------------------------------------------------------------
    //		Constructor
    //-------------------------------------------------------------------------
    public:
        DotExport(std::string ast, std::string output);
        DotExport(char* ast, char* output);


    //-------------------------------------------------------------------------
    //		Methods
    //-------------------------------------------------------------------------
    public:
        void run();

    private:
        void read_ast();
        void write_ast_in_dot_file();
        void cleanup_output();
        void open_output_file();
        void write_header();
        void write_body();
        bool is_edge(std::string line);
        void write_edge(std::string line);
        void write_node(std::string line);
        void write_footer();
        void close_output_file();
        void setup_output_permissions();
        std::vector<std::string> split(std::string str, std::string sep);
        std::string replace_all(std::string str, std::string old_str, std::string new_str);


    //-------------------------------------------------------------------------
    //		Setters
    //-------------------------------------------------------------------------
    public:
        void set_output(std::string path);
    };
}}}
