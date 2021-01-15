#!/bin/bash

#sciaganie strony
function download_website() {
    $(wget -k "$1" -O tmp &> /dev/null)
}

#wylawiam linki i przekazuje je do pliku
function get_links() {
    $(cat tmp | grep img | grep -Po 'src="\K.*?(?=")' > links)
    $(cat tmp | grep "image:" | grep -Po 'url\(\K.*?(?=\))' >> links)
    
}

#z pliku z kazdego url pobieramy zdjecia/filmy
function get_images() {
    if [ -e website_images ] 
    then 
        $(rm -r website_images)
    fi
    $(mkdir website_images)
    $(wget -i links -P ./website_images &> /dev/null)
}

#usuwamy zbedne pliki
function remove_tmp() {
    $(rm tmp)
    $(rm links)
}

#jesli brak zdjec na stronie wykonujemy ponizsza funkcje
function no_images() {
    echo -e "\e[1;34mNiestety nie ma zdjęć/filmów na podanej stronie \e[1;31m$1"
    $(rmdir website_images)
}

#jesli zdjecia zostana znalezione wykonuje sie ponizsza funkcja
function info() {
    echo -e "\e[1;34mPobrano wszystkie zdjęcia ze strony \e[1;31m$1"
    echo -e "\e[1;34mJest ich \e[1;31m$val \e[1;34mi znajdują się w katalogu \e[1;31m$(pwd)/website_images\e[1;34m!"
}

#wykonuje potrzebne funkcje
download_website $1
get_links
get_images
remove_tmp

#dodatkowo wykonuje opcjonalne funkcje wyswietlajace informacje
let val=$(ls website_images | wc -l)
if [ $val -gt 0 ]
then
    info $1 $val
else
    no_images $1
fi

