#pragma once

#include <cppally.hpp>
#include <string_view>

// Forward declarations to make functions visible to all translation units (cpp files).

namespace phsmethods {

namespace impl {

cppally::r_date parse_date(std::string_view s, int cutoff_2000);
bool all_valid_digits(std::string_view s) noexcept;
bool valid_date(std::string_view s);
bool valid_checksum(std::string_view s, bool check_mod11, bool check_mod10);

}

cppally::r_str chi_check(cppally::r_str_view x, bool check_mod11, bool check_mod10);

}
