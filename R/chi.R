#' @title chi functions
#'
#' @description
#'
#' The chi functions operate on CHI numbers:
#'
#' \itemize{
#' \item \code{chi_pad} adds a leading zero to 9 character CHIs
#' \item \code{chi_check} tests a CHI for validity
#' }
#'
#' @details
#' \code{chi_check}:
#'
#' This checks for a valid CHI by:
#'
#' \itemize{
#' \item checking for invalid characters (non-numeric)
#' \item checking for length of 10 characters
#' \item checking that first 6 characters parse to valid date
#' \item checksum digit is correct
#' }
#'
#' \code{chi_pad}:
#'
#' Depending on the source, CHI numbers are sometimes mising a leading zero.
#' \code{chi_pad} takes a 9 digit CHI and adds a leading zero. Only CHI numbers
#' of 9 characters are changed.
#'
#' @param to_check \code{character} vector of CHI numbers
#' @return character
#' @examples
#' x <- c("0101011237", "0101201234","3201201234", "0113201234",
#'  "3213201234", "123456789", "12345678900", "010120123?")
#' chi_check(x)
#'
#' #chi_pad differs from str_pad()
#' #as only 9 character CHIs are changed
#' x <- c("1234567890", "123456789", "123")
#' chi_pad(x)

#' @export
#' @rdname chi
chi_check <- function(to_check) {

  #stop if input is not character
  if(inherits(to_check, "character") != TRUE) {
    stop("input should be character class - try adding col_types = 'c' to read_csv")
  }

  #define checksum function
  checksum <- function(x) {

    #define sub_num helper function
    sub_num <- function(z, num) {

      #weight factor for checksum calculation
      wg <- c(10, 9, 8, 7, 6, 5, 4, 3, 2)

      #extract character by position
      z_ex <- substr(z, num, num)

      #multiply by weight factor
      as.numeric(z_ex) * wg[num]
    }

    #multiply by weights and add together
    y <- sub_num(x, 1) + sub_num(x, 2) +
        sub_num(x, 3) + sub_num(x, 4)+
        sub_num(x, 5) + sub_num(x, 6)+
        sub_num(x, 7) + sub_num(x, 8)+
        sub_num(x, 9)

    y2 <- floor(y/11) #discard remainder
    y3 <- 11 * (y2 + 1) - y #check sum calc
    y3 <- ifelse(y3 == 11, 0, y3) #if 11, make 0

    #check if output matches the checksum
    ifelse(y3 != substr(x, 10, 10), "fail", NA_character_)
  }

  #make vec of numerics, replacing invalid characters with NA
  to_check_num <- ifelse(grepl(x = to_check, pattern = "[[:punct:][:alpha:]]"),
                         NA_character_,
                         to_check)

  #perform checks
  dplyr::case_when(
  is.na(to_check_num) ~ "invalid character", #check character
  nchar(to_check_num) > 10 ~ "too long", #is it 10 digits?
  nchar(to_check_num) < 10 ~  "too short", #is it 10 digits?
  is.na(lubridate::dmy(substr(to_check_num, 1, 6), quiet = TRUE)) ~ "invalid date", #date check
  checksum(to_check_num) == "fail" ~ "invalid checksum", #checksum calculation
  TRUE ~ NA_character_) #NA if everything passes
}

#' @export
#' @rdname chi
chi_pad <- function(to_check){

  #stop if input is not character
  if(inherits(to_check, "character") != TRUE) {
    stop("input should be character class - try adding col_types = 'c' to read_csv")
  }

  #pad 9 characters to 10
  ifelse(nchar(to_check) == 9,
         paste0("0", to_check),
         paste0(to_check))
}
