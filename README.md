# R Wrapper around Datanyze API

This package is very basic - it provides convenient functions to send requests to `Datznyze` and analyze the response from within `R`.  
Read about `Datanyze` [here](https://www.datanyze.com/)


## Functions:

  + `get_domain_info()` - retrieves info about domain of your interest  
  
  + `json2formatted_list()` - formats the JSON response into structured list (can be coerced to data.frame)


### get_domain_info

You will need valid credentials (email & token) to use this function.
For security reasons, it is advised to keep a local file with your `Datanyze` credentials and read it into `R`.


### json2formatted_list

A list of features was pre-defined (see the `feats()` function). The features are being extracted from the raw JSON response and constructed as a list.  

The fields "technologies" and "social_links" are being reshaped into a comma-separated string.

Note: using this function only extracts a portion of original features contained in the raw JSON response from `Datanyze`, feel free to edit this function as suitable to your own needs/features of interest.



## Examples

Let us see what can we learn about "facebook.com".

```
email = "my_valid_email"
token = "my_valild_token"
domain = "facebook.com"
response <- get_domain_info(email, token, domain)

# response is binary, we need to decode it:
content <- fromJSON(rawToChar(response$content))
```

The content would look like this (excerpt):

```
$domain
[1] "facebook.com"

$rank
[1] 3

$email
[1] "info@facebook.com"

$company_name
[1] "Facebook, Inc."

$city
[1] "Menlo Park"

$street
[1] "1601 Willow Road"

$full_address
[1] "1601 Willow Road Menlo Park CA 94025 United States"

$founded_year
[1] 2004

$country_name
[1] "United States"

$state_name
[1] "CA"

$employees_str
[1] "10K - 50K"

$revenue_str
[1] "> 10B"

$industry_name
[1] "Internet"

$twitter_followers
[1] 14022819

$social_links
$social_links$linkedin
[1] "http://www.linkedin.com/company/10667"

$social_links$facebook
[1] "https://www.facebook.com/FacebookRussia/?brand_redir=20531316728"

$social_links$instagram
[1] "https://www.instagram.com/facebook/"

..

$technologies
$technologies$`52192`
[1] "Adobe Photoshop"

$technologies$`55726`
[1] "Amazon Alexa"

..
```



