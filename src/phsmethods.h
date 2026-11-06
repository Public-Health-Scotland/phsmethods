#pragma once

#if __cplusplus >= 202002L

#include <cppally.hpp>
#include <string_view>

// Forward declarations to make functions visible to all translation units (cpp files).

namespace phsmethods {

namespace impl {

cppally::r_date parse_date(std::string_view s, int cutoff_2000);
bool valid_date(std::string_view s);
bool valid_checksum(std::string_view s, bool check_mod11, bool check_mod10);

// compiler sometimes doesn't optimise valid_char or all_valid_digits unless they are
// in a header file, where the compiler can easily inline it.
inline bool valid_char(const char c) noexcept {
  return !(c < '0' || c > '9');
}
// Number of string characters
inline cppally::r_int nchars(cppally::r_str_view x) {
  using namespace cppally;

  if (x.is_na()){
    return r_int::na();
  }

  // ascii strings are 1 byte for each character so N bytes = N chars
  if (x.is_ascii()){
    return r_int(x.n_bytes());
  }

  // Normalise to valid UTF-8
  // Important: this assumes strings marked as CE_UTF8 are valid UTF-8
  // which is already a common R convention.
  r_str utf8_str = r_str(x, internal::view_tag{}).as_utf8();
  std::string_view s = utf8_str.cpp_str();

  // https://en.wikipedia.org/wiki/UTF-8
  // Since we have normalised it to a valid UTF-8 string
  // we simply count the bytes that start with a zero bit or two one bits.
  // We skip continuation bytes.
  constexpr unsigned char top_two_bits = 0b11000000;
  constexpr unsigned char continuation_prefix = 0b10000000;

  int n_chars = 0;
  for (const char c : s) {
    // top_two_bits is 11000000
    // continuation_prefix is 10000000
    // X & top_two_bits will zero all bits except the top 2 leaving one of the following combinations:
    // 11000000, 01000000, 00000000 (first byte of a character)
    // 10000000 (continuation byte, which we skip)
    bool is_continuation = (static_cast<unsigned char>(c) & top_two_bits) == continuation_prefix;
    n_chars += !is_continuation;
  }
  return r_int(n_chars);
}

inline bool all_valid_digits(std::string_view s) noexcept {
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

#endif
