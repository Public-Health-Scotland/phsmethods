#pragma once

#include <cppally.hpp>
#include <string_view>

// Forward declarations to make functions visible to all translation units (cpp files).

namespace phsmethods {

namespace impl {

cppally::r_date parse_date(std::string_view s, int cutoff_2000);
bool valid_date(std::string_view s);
bool valid_checksum(std::string_view s, bool check_mod11, bool check_mod10);

// compiler sometimes doesn't optimise valid_char or all_valid_digits unless they are
// marked constexpr and we can't forward declare constexpr in a header
// so we fully define them here
inline constexpr bool valid_char(const char c) noexcept {
  return !(c < '0' || c > '9');
}
inline constexpr bool all_valid_digits(std::string_view s) noexcept {
  for (const char c : s) {
    if (!valid_char(c)){
      return false;
    }
  }
  return true;
}

}

cppally::r_str chi_check(cppally::r_str_view x, bool check_mod11, bool check_mod10);

}
