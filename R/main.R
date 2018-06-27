#' Get domain info via Datanyze API
#'
#' @param email valid email registered in Datanyze
#' @param token Datanyze token
#' @param domain domain of interest
#' @param include_tech defaults to "true", see https://www.datanyze.com/api-documentation/ for more info
#'
#' @return The \code{curl} object with \code{status_code, headers, content} etc.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' get_domain_info("my_email", token = "my_token", domain = "facebook.com")
#' get_domain_info("my_email", token = "my_token", domain = "facebook.com", include_tech = "false")
#' }
get_domain_info <- function(email, token, domain, include_tech = "true") {

  request = paste0("https://api.datanyze.com/domain_info/",
                   "?email=", email,
                   "&token=", token,
                   "&domain=", domain,
                   "&tech_details", include_tech)

  response <- curl::curl_fetch_memory(request)
  code <- response$status_code

  if (code == 200){
    cat("\nrequest sent successfuly")
  } else {
    stop(paste("\nrequest failed with code:", code))
  }


  check_response_validity(response = response)

  response
}

check_response_validity <- function(response) {

  message = jsonlite::fromJSON(rawToChar(response$content))["message"]

  if (nchar(message) < 5){
    cat("\ndata fetched successfuly")
  } else {
    stop(message)
  }

}


#' Generate a formatted list out of Datanyze's response object
#'
#' @param json_response the \code{curl} object recieved as a response from \code{get_domain_info}
#'
#' @return The \code{list} with selected features - can be coerced to data.frame
#'
#' @export
#'
#' @examples
#' \dontrun{
#' json2formatted_list(json_response =
#'   get_domain_info("my_email", token = "my_token", domain = "facebook.com"))
#' }
json2formatted_list <- function(json_response) {

  df <- jsonlite::fromJSON(rawToChar(json_response$content), simplifyDataFrame = TRUE)
  df <- df[names(df) %in% feats()]

  # collapse social links & technologies into comma-separated list
  links <- collapse_list(df, "social_links")
  techs <- collapse_list(df, "technologies")

  # construct a structured list
  structured <-
    list("domain" = ifelse(nchar(df$domain) > 0, df$domain, ""),
         "alexa_rank" = ifelse(is.integer(df$rank), df$rank, NA),
         "has_phone" = ifelse(length(df$phone) > 0, "y", "n"),
         "has_email" = ifelse(length(df$email) > 0, "y", "n"),
         "company_name" = ifelse(length(df$company_name) > 0, df$company_name, NA),
         "city" = ifelse(length(df$city) > 0, df$city, NA),
         "revenue_str" = ifelse(length(df$revenue_str) > 0, df$revenue_str, NA),
         "public" = ifelse(is.integer(df$public), df$public, NA),
         "founded_year" = ifelse(is.integer(df$founded_year), df$founded_year, NA),
         "country" = ifelse(length(df$country_name) > 0, df$country_name, NA),
         "state" = ifelse(length(df$state_name) > 0, df$state_name, NA),
         "industry_name" = ifelse(length(df$industry_name) > 0, df$industry_name, NA),
         "employee_str" = ifelse(length(df$employees_str) > 0, df$employees_str, NA),
         "twitter_followers" = ifelse(is.integer(df$twitter_followers), df$twitter_followers, NA),
         "technologies" = techs,
         "monthly_tech_spend" = ifelse(length(df$monthly_tech_spend) > 0, df$monthly_tech_spend, NA),
         "social_links" = links)

  structured
}

