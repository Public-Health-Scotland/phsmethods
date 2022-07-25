#include "cpp11/strings.hpp"
#include "cpp11/logicals.hpp"
#include <bits/stdc++.h>

[[cpp11::register]]
cpp11::logicals valid_checksum(cpp11::strings chis) {
  int n = chis.size();
  cpp11::writable::logicals is_valid_checksum(n);

  for(int i = 0; i < n; ++i) {

    std::string chi = chis[i];

    // Computing weighted sum
    // of first 9 digits
    int sum = 0;
    for (int position = 0; position < 9; position++)  {
      int digit = chi[position] - '0';

      sum += (digit * (10 - position));
    }

    // Add the last digit to the sum
    sum += (chi[9] - '0');

    // Return true if weighted sum
    // of digits is divisible by 11.
    is_valid_checksum[i] = (sum % 11 == 0);
  }

  return is_valid_checksum;
}


