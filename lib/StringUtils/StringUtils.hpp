/**
 * Copyright (c) William Niemiec.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <iostream>
#include <vector>

namespace wniemiec { namespace util { namespace cpp {

    /**
     * Contains methods that perform string manipulation.
     */
    class StringUtils
    {
    //-------------------------------------------------------------------------
    //      Constructor
    //-------------------------------------------------------------------------
    private:
        StringUtils();


    //-------------------------------------------------------------------------
    //      Methods
    //-------------------------------------------------------------------------
    public:
        /**
         * Returns a list of the words in the string, separated by the 
         * delimiter string.
         * 
         * @param       str String to be splitted.
         * @param       sep Character dividing the string into split groups.
         * 
         * @return      Vector with split groups
         */
        static std::vector<std::string> split(std::string str, std::string sep);

        /**
         * Returns a copy of the string in UPPER CASE.
         * 
         * @param       str Some string
         * 
         * @return      String in upper case
         */
        static std::string to_upper(std::string str);

        /**
         * Searches a string for a value and generates a new string with the 
         * value(s) replaced.
         * 
         * @param       str Base string
         * @param       old_value Value to be search for
         * @param       new_value Value to replace with
         * 
         * @return      New string with the value(s) replaced
         */
        static std::string replace_all(
            std::string str, 
            std::string old_value, 
            std::string new_value
        );
    };
}}}
