
// ----- Check validity of Community Health Index (CHI) numbers -----
// Authors: Nick Christofides, Alan Yeung & phsmethods collaborators

#include <cppally.hpp>
#include <string_view>

using namespace cppally;

namespace phsmethods {

namespace impl {

constexpr bool valid_char(const char c) noexcept {
  return !(c < '0' || c > '9');
}

constexpr bool all_valid_digits(std::string_view s) noexcept {
  for (const char c : s) {
    if (!valid_char(c)){
      return false;
    }
  }
  return true;
}


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


r_date dob_from_chi(std::string_view s, r_date min_date, r_date max_date){

  if (is_na(min_date) || is_na(max_date)){
    return na<r_date>();
  }

  // Equivalent to fast_strptime(..., cutoff_2000 = -1L)
  r_date date_1900 = parse_date(s, -1);

  // Equivalent to fast_strptime(..., cutoff_2000 = 100L)
  r_date date_2000 = parse_date(s, 100);

  if (is_na(date_1900)){
    return date_2000;
  }

  if (is_na(date_2000)){
    return date_1900;
  }

  bool date_1900_in_range = (date_1900 >= min_date && date_1900 <= max_date).is_true();
  bool date_2000_in_range = (date_2000 >= min_date && date_2000 <= max_date).is_true();

  if (date_2000_in_range && !date_1900_in_range) {
    return date_2000;
  }

  if (date_1900_in_range && !date_2000_in_range) {
    return date_1900;
  }

  return na<r_date>();
}

// // Overload without date ranges
// r_date dob_from_chi(std::string_view s){
//
//   // Equivalent to fast_strptime(..., cutoff_2000 = -1L)
//   r_date date_1900 = parse_date(s, -1);
//
//   // Equivalent to fast_strptime(..., cutoff_2000 = 100L)
//   r_date date_2000 = parse_date(s, 100);
//
//   if (is_na(date_1900)){
//     return date_2000;
//   } else {
//     return date_1900;
//   }
// }



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

// DOB from CHI
[[cppally::register]]
r_vector<r_date> cpp_dob_from_chi(
    const r_vector<r_str>& x,
    const r_vector<r_date>& min_date,
    const r_vector<r_date>& max_date
) {
  return pmap([](const r_str& chi, const r_date& min, const r_date& max){
    r_str check = phsmethods::chi_check(chi, true, true);
    if (!identical(check, cached_str<"Valid CHI">())){
      return na<r_date>();
    }
    return phsmethods::impl::dob_from_chi(chi.cpp_str(), min, max);
  }, x, min_date, max_date);
}
