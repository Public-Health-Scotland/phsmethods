# Warning gives true number of values that don't adhere to format

    Code
      format_postcode("g2")
    Condition
      Warning:
      1 value has lower case letters these will be converted to upper case.
      Warning:
      1 non-NA input value does not adhere to the standard UK postcode format (with or without spaces) and will be coded as NA.
      The standard format is:
      * 1 or 2 letters, followed by
      * 1 number, followed by
      * 1 optional letter or number, followed by
      * 1 number, followed by
      * 2 letters
    Output
      [1] NA

---

    Code
      format_postcode(c("DG98BS", "dg98b"))
    Condition
      Warning:
      1 value has lower case letters these will be converted to upper case.
      Warning:
      1 non-NA input value does not adhere to the standard UK postcode format (with or without spaces) and will be coded as NA.
      The standard format is:
      * 1 or 2 letters, followed by
      * 1 number, followed by
      * 1 optional letter or number, followed by
      * 1 number, followed by
      * 2 letters
    Output
      [1] "DG9 8BS" NA       

---

    Code
      format_postcode(c("ML53RB", NA, "ML5", "???", 53, as.factor("ML53RB")))
    Condition
      Warning:
      4 non-NA input values do not adhere to the standard UK postcode format (with or without spaces) and will be coded as NA.
      The standard format is:
      * 1 or 2 letters, followed by
      * 1 number, followed by
      * 1 optional letter or number, followed by
      * 1 number, followed by
      * 2 letters
    Output
      [1] "ML5 3RB" NA        NA        NA        NA        NA       

---

    Code
      format_postcode(c("KY1 1RZ", "ky1rz", "KY11 R", "KY11R!"), quiet = TRUE)
    Output
      [1] "KY1 1RZ" NA        NA        NA       
    Code
      format_postcode(c("KY1 1RZ", "ky1rz", "KY11 R", "KY11R!"), quiet = FALSE)
    Condition
      Warning:
      1 value has lower case letters these will be converted to upper case.
      Warning:
      3 non-NA input values do not adhere to the standard UK postcode format (with or without spaces) and will be coded as NA.
      The standard format is:
      * 1 or 2 letters, followed by
      * 1 number, followed by
      * 1 optional letter or number, followed by
      * 1 number, followed by
      * 2 letters
    Output
      [1] "KY1 1RZ" NA        NA        NA       

