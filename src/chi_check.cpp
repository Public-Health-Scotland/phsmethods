
// ----- Check validity of Community Health Index (CHI) numbers -----
// Authors: Nick Christofides & phsmethods collaborators

#include <cppally.hpp>
#include <string_view>

using namespace cppally;

r_lgl checksum(r_str_view x, bool check_mod11, bool check_mod10) {

  if (x.is_na()) {
    return na<r_lgl>();
  }

  const std::string_view s = x.cpp_str();

  if (s.size() != 10) {
    return na<r_lgl>();
  }

  int d[10];
  for (int p = 0; p < 10; ++p) {
    const char c = s[p];
    if (c < '0' || c > '9') {
      return na<r_lgl>();
    }
    d[p] = c - '0';
  }
  const int tenth = d[9];

  bool passed = false;

  // Mod 11: weighted sum of the first nine digits (weights 10, 9, ..., 2)
  if (check_mod11) {
    int sum = 0;
    int weight = 10;
    for (int p = 0; p < 9; ++p) {
      sum += d[p] * weight;
      --weight;
    }
    int check_digit = 11 - (sum % 11); // == 11 * (floor(sum/11) + 1) - sum
    if (check_digit == 11) {
      check_digit = 0;
    }
    passed = passed || check_digit == tenth;
  }

  // Mod 10 (Luhn): double the 1st, 3rd, ..., 9th digits, casting out nines
  if (check_mod10) {
    int sum = 0;
    for (int p = 0; p < 9; ++p) {
      int v = d[p];
      if (p % 2 == 0) {
        v *= 2;
        if (v > 9) {
          v -= 9;
        }
      }
      sum += v;
    }
    int check_digit = 10 - (sum % 10);
    if (check_digit == 10) {
      check_digit = 0;
    }
    passed = passed || check_digit == tenth;
  }

  return r_lgl(passed);
}

// Extract number from single or double digit number
int two_digits(std::string_view s) {
  return (s[0] - '0') * 10 + (s[1] - '0');
}

// Valid DDMMYY?
// The C++ library chrono is used for thorough validation of dates
// NA is returned on impossible dates
bool valid_ddmmyy(std::string_view s) {
  const int day   = two_digits(s.substr(0, 2));
  const int month = two_digits(s.substr(2, 2));
  const int yy    = two_digits(s.substr(4, 2));
  const int year  = yy <= 68 ? 2000 + yy : 1900 + yy; // fast_strptime cutoff_2000 = 68
  return !r_date(year, month, day).is_na();
}

r_str chi_check(r_str_view x, bool check_mod11, bool check_mod10) {

  if (!check_mod11 && !check_mod10) {
    abort("chi_check: At least one of `check_mod11` and `check_mod10` must be TRUE.");
  }

  if (x.is_na()) {
    return cached_str<"Missing (NA)">();
  }

  const std::string_view s = x.cpp_str();

  if (s.empty()) {
    return cached_str<"Missing (Blank)">();
  }

  if (s.size() < 10) {
    return cached_str<"Too few characters">();
  }
  if (s.size() > 10) {
    return cached_str<"Too many characters">();
  }

  for (const char c : s) {
    if (c < '0' || c > '9') {
      return cached_str<"Invalid character(s) present">();
    }
  }

  if (!valid_ddmmyy(s)) {
    return cached_str<"Invalid date">();
  }

  return checksum(x, check_mod11, check_mod10).is_true() ? cached_str<"Valid CHI">() : cached_str<"Invalid checksum">();
}

[[cppally::register]]
r_vector<r_str> cpp_chi_check(const r_vector<r_str>& x, bool check_mod11, bool check_mod10) {
  return pmap([check_mod11, check_mod10](const r_str& v){
    return chi_check(v, check_mod11, check_mod10);
  }, x);
}
