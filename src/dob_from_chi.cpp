
#if __cplusplus >= 202002L

#include "phsmethods.h"
#include <string_view>

using namespace cppally;

namespace phsmethods {

namespace impl {

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

} // namespace impl

} // namespace phsmethods

// DOB from CHI
[[cppally::register]]
r_vector<r_date> cpp_dob_from_chi(
    const r_vector<r_str>& x,
    const r_vector<r_date>& min_date,
    const r_vector<r_date>& max_date
) {
  return pmap([](const r_str& chi, const r_date& min, const r_date& max){

    if (is_na(chi)){
      return na<r_date>();
    }

    std::string_view s = chi.cpp_str();

    // R dob_from_chi() already checked validity.
    // We still try to parse dates regardless of CHI number validity.
    if (s.size() < 6 || !phsmethods::impl::all_valid_digits(s.substr(0, 6))){
      return na<r_date>();
    }

    return phsmethods::impl::dob_from_chi(s, min, max);

  }, x, min_date, max_date);
}

#endif
