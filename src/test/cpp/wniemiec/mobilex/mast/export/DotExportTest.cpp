#include "DotExportTest.hpp"

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <experimental/filesystem>

using namespace wniemiec::mobilex::mast;
namespace fs = std::experimental::filesystem;

//-----------------------------------------------------------------------------
//		Tests
//-----------------------------------------------------------------------------
TEST_F(DotExportTest, test_run_with_ast_and_output)
{
    std::string ast = "../../../../../test/resources/simple-dot.ast";
    std::string output = fs::temp_directory_path();
    DotExport dotExport = DotExport(ast, output);
    dotExport.run();

    std::string expected_dot_path = "../../../../../test/resources/simple-dot.dot";
    std::string obtained_dot_path = output + "/simple-dot.dot";

    std::vector<std::string> tmp = read_file(ast);
    std::vector<std::string> expected_dot = read_file(expected_dot_path);
    std::vector<std::string> obtained_dot = read_file(obtained_dot_path);

    assert_has_same_lines(expected_dot, obtained_dot);
    
    //with_ast();
    //with_output();
    //do_export();
    //assert_exported_file_is();
}

std::vector<std::string> DotExportTest::read_file(std::string file)
{
    std::vector<std::string> lines; 
    std::string line;
    std::ifstream file_stream(file);
    
    while (std::getline(file_stream, line))
    {
        lines.push_back(line);
    }

    return lines;
}

void DotExportTest::assert_has_same_lines(
    std::vector<std::string> expected, 
    std::vector<std::string> obtained
)
{
    assert_has_same_size(expected, obtained);    

    for (int i = 0; i < expected.size(); i++) {    
        assert_has_same_line(expected[i], obtained[i]);
    }
}

void DotExportTest::assert_has_same_size(
    std::vector<std::string> expected, 
    std::vector<std::string> obtained
)
{
    EXPECT_EQ(expected.size(), obtained.size());
}

void DotExportTest::assert_has_same_line(std::string expected, std::string obtained)
{
    EXPECT_STREQ(
        remove_white_spaces(expected).c_str(), 
        remove_white_spaces(obtained).c_str()
    );
}

std::string DotExportTest::remove_white_spaces(std::string text)
{
    std::string parsed_text = "";
    std::stringstream text_stream(text);
    std::string term;
    
    while (getline(text_stream, term, ' ')) {
        parsed_text = parsed_text + term;
    }

    return parsed_text;
}