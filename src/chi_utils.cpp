#include "phsmethods.h"
#include <string_view>

using namespace cppally;

namespace phsmethods {

namespace impl {

// Extract number from double digit string
int parse_double_digit(std::string_view s){
  return (s[0] - '0') * 10 + (s[1] - '0');
}

// Valid DDMMYY?
// The C++ library chrono is used for thorough validation of dates
// r_date(year, month, day) evaluates to NA on impossible dates
r_date parse_date(std::string_view s, int cutoff_2000 = 68){
  int day   = parse_double_digit(s.substr(0, 2));
  int month = parse_double_digit(s.substr(2, 2));
  int yy    = parse_double_digit(s.substr(4, 2));
  int year  = yy <= cutoff_2000 ? 2000 + yy : 1900 + yy; // fast_strptime cutoff_2000 = 68
  return r_date(year, month, day);
}

bool valid_date(std::string_view s){
  r_date d = parse_date(s);
  return !is_na(d);
}

bool valid_checksum(std::string_view s, bool check_mod11, bool check_mod10) {

  int d[10];
  for (int p = 0; p < 10; ++p) {
    const char c = s[p];
    if (!valid_char(c)){
      return false;
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
  if (!passed && check_mod10) {
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

  return passed;
}

} // namespace impl

}
