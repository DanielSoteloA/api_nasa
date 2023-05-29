require 'open-uri'
require 'json'
require 'net/http'

def request(url_requested)
  url = URI(url_requested)

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  request = Net::HTTP::Get.new(url)
  request['cache-control'] = 'no-cache'
  request['postman-token'] = '5f4b1b36-5bcd-4c49-f578-75a752af8fd5'

  response = http.request(request)
  JSON.parse(response.body)
end
url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=dX0Hwjp7NjuDfffR8jCl6LV3NflbhlA7gGOPnttV'

response = URI.open(url).read
data = JSON.parse(response)

html = "
<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css\" integrity=\"sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T\" crossorigin=\"anonymous\">
    <title>Document</title>
</head>
<body>
<div class=\"container\">
<h1></h1>
"
i = 0
data['photos'].each do |photo|
  img_src = photo['img_src']
  camera  = photo['camera']['name']
  i = i + 1
  total = data['photos'].length

  html += "<div class=\"card border border-secundary\" style=\"width: 38rem;\">"
  html += "<img src=\"#{img_src}\">"
  html += "<div class=\"card-body\">"
  html += "<h5 class=\"card-title\">Curiosity : imagen [#{i} de #{total}] </h5>"
  html += "<p class=\"card-text\">#{camera}</p>"
  html += "<a href=\"#{img_src}\" class=\"btn btn-primary\">Ver</a>"
  html += "</div></div><br />"
end
html += '<script src=\"https://code.jquery.com/jquery-3.3.1.slim.min.js\" integrity=\"sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo\" crossorigin=\"anonymous\"></script>'
html += '</div></body></html>'

File.write('index.html', html)