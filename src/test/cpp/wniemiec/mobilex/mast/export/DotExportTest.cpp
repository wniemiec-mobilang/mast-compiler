#include "DotExportTest.hpp"

#include <iostream>

using namespace wniemiec::mobilex::mast;

//-----------------------------------------------------------------------------
//		Tests
//-----------------------------------------------------------------------------
TEST_F(DotExportTest, test_hello)
{
    std::string expected = "hello";
    std::string obtained = "hello";

    EXPECT_STREQ(expected.c_str(), obtained.c_str());
}
