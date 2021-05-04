# frozen_string_literal: true

require('rails_helper')

RSpec.describe('V1::ProjectCrud', type: :request) do

end

# curl 'https://api.atlmaps-dev.com:3000/users/me' \
#   -H 'Connection: keep-alive' \
#   -H 'Pragma: no-cache' \
#   -H 'Cache-Control: no-cache' \
#   -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.146 Safari/537.36' \
#   -H 'DNT: 1' \
#   -H 'Accept: */*' \
#   -H 'Origin: https://lvh.me:4200' \
#   -H 'Sec-Fetch-Site: cross-site' \
#   -H 'Sec-Fetch-Mode: cors' \
#   -H 'Sec-Fetch-Dest: empty' \
#   -H 'Referer: https://lvh.me:4200/' \
#   -H 'Accept-Language: en-US,en;q=0.9,de;q=0.8,pt-BR;q=0.7,pt;q=0.6,fr;q=0.5' \
#   -H 'Cookie: CSRF-TOKEN=jJrYzA5YyZJN0arAK4vWZYAi4xqOJoIdng9RAfl7MJAWdYRbtw%2BCMP1Ge6jVGqnNvkfzgrOAb699CsMnoF8LXA%3D%3D; auth=eyJfcmFpbHMiOnsibWVzc2FnZSI6IkltVjVTbWhpUjJOcFQybEtTVlY2U1RGT2FVbzVMbVY1U210WldGSm9TV3B3TjBsdVpHOWllVWsyU1cxd2FHVllXbWhqYlRWc1kydENibUpYUm5CaVF6VnFZakl3YVdaVGQybGFXR2gzU1dwdmVFNXFSWGxPVkZreVQwUkJlbVpSTGkxdlNVODFkRWs1UldoT2IxRmZWMjkwTmpNeE9HVTFXbWs1WkY5NlJFOVpVMWxIUkdOWVNXOWxPSGNpIiwiZXhwIjoiMjAyMS0wMi0xOVQxOToxMzoyMy42NDBaIiwicHVyIjpudWxsfX0%3D--d46ad66a1857601509a23860c11b7826dd9c48dd' \
#   --compressed \
#   --insecure

#   fetch("https://api.atlmaps-dev.com:3000/users/me", {
#     "headers": {
#       "accept": "*/*",
#       "accept-language": "en-US,en;q=0.9,de;q=0.8,pt-BR;q=0.7,pt;q=0.6,fr;q=0.5",
#       "cache-control": "no-cache",
#       "pragma": "no-cache",
#       "sec-fetch-dest": "empty",
#       "sec-fetch-mode": "cors",
#       "sec-fetch-site": "cross-site"
#     },
#     "referrer": "https://lvh.me:4200/",
#     "referrerPolicy": "strict-origin-when-cross-origin",
#     "body": null,
#     "method": "GET",
#     "mode": "cors",
#     "credentials": "include"
#   });