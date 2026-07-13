
// ----- Check validity of Community Health Index (CHI) numbers -----
// Authors: Nick Christofides, Alan Yeung & phsmethods collaborators

#include "phsmethods.h"
#include <string_view>

using namespace cppally;

namespace phsmethods {

r_str chi_check(r_str_view x, bool check_mod11, bool check_mod10) {

  // cached_str<> allocates the string once on first call and re-uses it on subsequents calls

  if (is_na(x)) {
    return cached_str<"Missing (NA)">();
  }

  const std::string_view s = x.cpp_str();

  const auto n_chars = s.size();

  if (n_chars == 0) {
    return cached_str<"Missing (Blank)">();
  }
  if (n_chars < 10) {
    return cached_str<"Too few characters">();
  }
  if (n_chars > 10){
    return cached_str<"Too many characters">();
  }

  if (!impl::all_valid_digits(s)){
    return cached_str<"Invalid character(s) present">();
  }

  if (!impl::valid_date(s)) {
    return cached_str<"Invalid date">();
  }

  if (!impl::valid_checksum(s, check_mod11, check_mod10)){
    return cached_str<"Invalid checksum">();
  }

  return cached_str<"Valid CHI">();
}

} // namespace phsmethods

[[cppally::register]]
r_vector<r_str> cpp_chi_check(const r_vector<r_str>& x, bool check_mod11, bool check_mod10) {
  return pmap([check_mod11, check_mod10](const r_str& chi){
    return phsmethods::chi_check(chi, check_mod11, check_mod10);
  }, x);
}
