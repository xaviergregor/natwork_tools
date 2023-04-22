 #!/bin/bash
#
# By: Brady Shea - 10FEB2020
#
# Usage (ip4 only):
#    geoip2lookup IP_ADDRESS
#
# ** Install GeoIP Tool and Updater **
#
#    sudo add-apt-repository ppa:maxmind/ppa
#    sudo apt install libmaxminddb0 libmaxminddb-dev mmdb-bin geoipupdate
#
# * Review: https://dev.maxmind.com/geoip/geoip2/geolite2/ and
#   sign up for a free license.
# * Edit your "/etc/GeoIP.conf":
# * Make sure you have the proper downloads location set:
#   "EditionIDs GeoLite2-Country GeoLite2-City GeoLite2-ASN"
# * Make sure you have added the 'AccountID' and 'LicenseKey'
#
# Then finally execute:
#
#    sudo geoipupdate
#
# Make sure you see new files in "/usr/share/GeoIP". If not, check
# the 'DatabaseDirectory' directive in your config/.conf above.
# A cron job will also be created to periodocally run the updater.
#
# Notes:
# * The valid_ip() function is taken from:
#   https://www.linuxjournal.com/content/validating-ip-address-bash-script
# * Updated Legacy files can be found here: https://www.miyuru.lk/geoiplegacy
#   - this script uses mmdb (only), though.
# * The country file is not currently used in this script. It can be removed
#   from your downloads in the .conf file above if needed.
#

#####################################################################
# Functions
#####################################################################

function process_quoted () {
  # Process all given tokens with spaces as one func argument= $*
  grab_quoted=`sed -E 's/.*"(.*)".*/\1/' <<< "$*"`
}

function process_unquoted () {
  grab_first_word=${1% *}
}

function valid_ip()
{
  local  ip=$1
  local  stat=1
  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.'
    ip=($ip)
    IFS=$OIFS
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    stat=$?
  fi
  return $stat
}

#####################################################################
# Validate
#####################################################################

# No argument given?
if [ -z "$1" ]; then
  printf "\nUsage:\n\n  geoip2lookup IP4_ADDRESS\n\n"
  exit 1
fi
# Check ip validity.
if ! valid_ip "$1"; then
  printf "\nThis is not a valid IP address. Exiting.\n\n"
  exit 1
fi

#####################################################################
# Execute
#####################################################################

printf "\nLooking up IP in the installed GeoIP database..\n"

file_country="/opt/homebrew/var/GeoIP/GeoLite2-Country.mmdb"
file_city="/opt/homebrew/var/GeoIP/GeoLite2-City.mmdb"
file_asn="/opt/homebrew/var/GeoIP/GeoLite2-ASN.mmdb"

city_string=`mmdblookup                 --file ${file_city}    --ip "$1" city names en 2>/dev/null`
subdivision_string=`mmdblookup          --file ${file_city}    --ip "$1" subdivisions 0 names en 2>/dev/null`
country_string=`mmdblookup              --file ${file_city}    --ip "$1" country names en 2>/dev/null`
continent_string=`mmdblookup            --file ${file_city}    --ip "$1" continent names en 2>/dev/null`
location_lat_string=`mmdblookup         --file ${file_city}    --ip "$1" location latitude 2>/dev/null`
location_lon_string=`mmdblookup         --file ${file_city}    --ip "$1" location longitude 2>/dev/null`
location_metrocode_string=`mmdblookup   --file ${file_city}    --ip "$1" location metro_code 2>/dev/null`
location_timezone_string=`mmdblookup    --file ${file_city}    --ip "$1" location time_zone 2>/dev/null`
postal_string=`mmdblookup               --file ${file_city}    --ip "$1" postal code 2>/dev/null`
asn_number_string=`mmdblookup           --file ${file_asn}     --ip "$1" autonomous_system_number 2>/dev/null`
asn_name_string=`mmdblookup             --file ${file_asn}     --ip "$1" autonomous_system_organization 2>/dev/null`

process_quoted    $city_string                && city=${grab_quoted}
process_quoted    $subdivision_string         && subdivisions=${grab_quoted}
process_quoted    $country_string             && country=${grab_quoted}
process_quoted    $continent_string           && continent=${grab_quoted}
process_unquoted  $location_lat_string        && location_lat=${grab_first_word}
process_unquoted  $location_lon_string        && location_lon=${grab_first_word}
process_unquoted  $location_metrocode_string  && location_code=${grab_first_word}
process_quoted    $location_timezone_string   && location_tz=${grab_quoted}
process_quoted    $postal_string              && postal=${grab_quoted}
process_unquoted  $asn_number_string          && asn_number=${grab_first_word}
process_quoted    $asn_name_string            && asn_name=${grab_quoted}

printf "
  City:                   ${city}
  Territory:              ${subdivisions}
  Country:                ${country}
  Continent:              ${continent}
  Location (approx):      ${location_lat},${location_lon}
  Metro Code:             ${location_code}
  Timezone:               ${location_tz}
  Postal Code:            ${postal}
  ASN Number:             ${asn_number}
  ASN Organization:       ${asn_name}
\n"
