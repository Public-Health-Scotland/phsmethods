#' Create NRS triplicate ID from three separate fields
#'
#' @description This function creates NRS triplicate ID by combining the fields
#' registration year, registration district and entry number
#' this ID is prefixed with a letter "B", "S" or "D" depenging on whether
#' the data is from live births, stillbirth or death registrations
#' the user must select this.
#'
#'
#' @param year.of.reg variable that represents the registration year
#' @param reg.district variable that represents the registration district
#' @param entry.no variable that represents the entry number
#' @param data.type user must select which NRS dataset they are using:
#' options are "Live birth" "Stillbirth" or "Death". This option determines
#' the prefix added to the triplicate ID to make them truly unique.
#' The function adds a prefix to ensure there is no confusion between
#' NRS triplicate IDS from different sources when combining datasets.
#' Although NRS triplicate ID is unique within the registration type, they are
#' not unique across the different registers. E.g. a live birth could have the
#' same triplicate ID as a stillbirth registered in the same registration
#' district and this could cause confusion when carrying out work that uses
#' both live and stillbirth records
#'
#' @return An alphnumeric
#'
#' @examples

#' @export

nrs_trip_id <- function(year.of.reg = year_of_registration,
                        reg.district = registration_district,
                        entry.no = entry_number,
                        data_type = c("Stillbirth", "Live birth",  "Death")){
  if(!data_type %in% c("Stillbirth", "Live birth",  "Death")){
    cli::cli_abort("data type must be specified as NRS live births 'Live birth',
                   NRS stillbirths 'Stillbirth', or NRS deaths 'Death'.")
  }

  if(data_type %in% c( "Death")){
    print(paste0("You have selected", data_type, "the prefix will be D,
                 if you want to create the birth ID from
                 the birth ID fields in the deaths data, select option Live birth.
                 Please check that you have entered the correct identifier
                 fields as the NRS infant deaths data
                 contains two sets of registration values, one for the death
                 registration and one for the linked birth registration"))
  }

  if(data_type=="Live birth") {
x <- paste0("B",substr(year.of.reg,3,4), reg.district,
            stringr::str_pad(entry.no, width = 4, pad="0"))
  }
  if(data_type=="Stillbirth"){
    x <- paste0("S",substr(year.of.reg,3,4), reg.district,
                stringr::str_pad(entry.no, width = 4, pad="0"))
  }

  if(data_type=="Death"){
    x <- paste0("D",substr(year.of.reg,3,4), reg.district,
                stringr::str_pad(entry.no, width = 4, pad="0"))
  }
  x
}
