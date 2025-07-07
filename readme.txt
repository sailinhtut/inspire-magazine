Backend
Laravel Version - 10
Database - MySQL
Last Deployment - C Panel | Share Hosting 
Authentication - Sanctuom Token
Media Storage - Laravel File Storage (/storage) 
(You will need to delete '/public/internal' when you new to start project and run 'php artisan 
storage:link' to get downloadable public image urls)


Mobile (inspire_blog)
Flutter 3.7 Approved 
iOS Configruation Not Yet.


Web Dashboard (inspire_panel)
Flutter 3.7 Approved



Postman Collection
'Accept: application/json' header is essential to get status and error response in json format 
from laravel server because I used Larvel Sanctum Authentication which return route('login') HTML Response in default when something failed. 
If you forgot to put 'application/json' header in every api to laravel server, when your api token is 
invalid or something went wrong, it will return Log In HTML Page. To validate and catch error only in
json format, please do use 'Accept:application/json' in every request.



