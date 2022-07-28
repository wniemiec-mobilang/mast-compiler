#pragma once

#include <gtest/gtest.h>
#include "../../../../../../main/cpp/wniemiec/mobilex/mast/export/DotExport.hpp"

namespace wniemiec { namespace mobilex { namespace mast {

    class DotExportTest : public testing::Test
    {
    //-------------------------------------------------------------------------
    //		Attributes
    //-------------------------------------------------------------------------
    protected:
        static std::string RESOURCES;
        std::string ast;
        std::string output;


    //-------------------------------------------------------------------------
    //		Test hooks
    //-------------------------------------------------------------------------
    protected:
        void SetUp() override { set_up(); }
        void set_up();


    //-------------------------------------------------------------------------
    //		Methods
    //-------------------------------------------------------------------------
    protected:
        void with_ast(std::string path);
        void with_output(std::string path);
        void do_export();
        void assert_exported_file_is_equal_to_file(std::string path);

        std::vector<std::string> read_file(std::string file);
        void assert_has_same_size(
            std::vector<std::string> expected, 
            std::vector<std::string> obtained
        );
        void assert_has_same_lines(
            std::vector<std::string> expected, 
            std::vector<std::string> obtained
        );
        void assert_has_same_line(std::string expected, std::string obtained);
        std::string remove_white_spaces(std::string text);
    };
}}}
