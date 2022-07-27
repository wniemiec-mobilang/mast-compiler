#pragma once

#include <gtest/gtest.h>
#include "../../../../../../main/cpp/wniemiec/mobilex/mast/export/DotExport.hpp"

namespace wniemiec { namespace mobilex { namespace mast {

    class DotExportTest : public testing::Test
    {
    //-------------------------------------------------------------------------
    //		Attributes
    //-------------------------------------------------------------------------
    //private:
        //DotExport dotExport;


    //-------------------------------------------------------------------------
    //		Constructor
    //-------------------------------------------------------------------------
    // public:
    //     DotExportTest();


    //-------------------------------------------------------------------------
    //		Methods
    //-------------------------------------------------------------------------
    protected:
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
