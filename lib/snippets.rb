a# Random bits of code to keep around as reminders/exampels.
RasterLayer.all.each do |r|
  puts r.id
  next if r.tmp_thumb.attached?
  next if r.thumb.url.nil?
  res = Net::HTTP.get_response(URI(r.thumb.url))
  if res.kind_of? Net::HTTPSuccess
    r.tmp_thumb.attach(io: URI.open(r.thumb.url), filename: r.thumb.url.split('/').last)
  end
end

# Migrate Carrierwave files to ActiveStorage
RasterLayer.all.each do |r|
  puts r.id
  next if r.thumbnail.attached?
  next if r.thumb.url.nil?
  res = Net::HTTP.get_response(URI(r.thumb.url))
  if res.kind_of? Net::HTTPSuccess
    r.thumbnail.attach(io: URI.open(r.thumb.url), filename: r.thumb.url.split('/').last)
  end
end


categories = Faraday.get('https://en.wikipedia.org/w/api.php?action=query&format=json&list=categorymembers&cmtitle=Category:Neighborhoods_in_Atlanta&cmlimit=124')
wiki_data = JSON.parse(categories.body)
wiki_data['query']['categorymembers'].map {|n| n['title']}

geo = Faraday.get 'https://geoserver.ecds.emory.edu/ATLMaps/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=ATLMaps:Atlanta%20Neighborhoods&maxFeatures=500&outputFormat=application%2Fjson'
geo_data = JSON.parse(geo.body)
geo_data['features'].select {|n| n['properties']['NAME'] == 'Reynoldstown'}

missing2 = []
wiki_data['query']['categorymembers'].each do |hood|
  url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&pageids=#{hood['pageid']}"
  wiki = Faraday.get(url)
  next unless wiki.success?
  puts(url)
  wiki_content = JSON.parse(wiki.body)['query']['pages'][hood['pageid'].to_s]
  if wiki_content.nil?
    missing2.push(hood['title'])
    next
  end
  hood_name = hood['title'].split(',').first.gsub(' (Atlanta)', '')
  hood_geo = geo_data['features'].select {|n| n['properties']['NAME'] == hood_name}
  if hood_geo.empty?
    missing2.push(hood_name)
    next
  end
  link = "https://en.wikipedia.org/wiki/#{hood['title'].gsub(' ', '_')}"
  hood_geo.first['properties']['description'] = "#{wiki_content['extract']} <p>Source: <a href='#{link}>Wikipedia</a><p>"
end; nil

wiki_data['query']['categorymembers'].each do |hood|
  url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&pageids=#{hood['pageid']}"
  puts(url)
  wiki = Faraday.get(url)
  wiki_content = JSON.parse(wiki.body)
  puts(wiki_content['query']['pages'][hood['pageid']]['extract'])
end; nil

missing = []
vl.tmp_geojson['features'].each do |f|
  if f['properties']['description'].nil?
    missing.push(f['properties']['title'])
  end
end

title = 'Druid Hills'
wiki_title = 'Druid_Hills,_Georgia'
id = '110038'
r = vl.tmp_geojson['features'].select {|n| n['properties']['title'] == title}.first
url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&pageids=#{id}"
wiki = HTTParty.get(url)
w = JSON.parse(wiki.body)
content = w['query']['pages'][id]['extract']
r['properties']['description'] = "#{content}<p>Source: <a href='https://en.wikipedia.org/wiki/#{wiki_title}'>Wikipedia</a></p>"
puts(r['properties']['description'])


rows = CSV.read('geocoder.csv', headers: true, header_converters: :symbol)
b = VectorLayer.find(570)
RGeo::GeoJSON.decode(b.geojson['features'].first['geometry'])
factory = RGeo::Geographic.simple_mercator_factory
factory.point(rows.first[:latitude].to_f, rows.first[:longitude].to_f)

building = nil
poly = RGeo::GeoJSON.decode(b.geojson['features'].first['geometry'])
rows.each do |r|
  point = factory.point(r[:latitude].to_f, r[:longitude].to_f)
  point.within? poly
  building = r
end


VectorLayer.all.each do |vl|
  if vl.url.nil? && vl.vector_features.count > 0
    vl.tmp_geojson = {type: 'FeatureCollection', features: []}
    vl.vector_features.each do |f|
      feature = {type: 'Feature', geometry: {type: f.geojson['geometries'].first['type'], coordinates: f.geojson['geometries'].first['coordinates'] } , properties: f.geojson['properties']}
      vl.tmp_geojson['features'].push(feature)
    end
    vl.save
  end
end

VectorLayer.all.each do |vl|
  puts vl.id
  if vl.tmp_geojson.nil? && vl.geojson
    if vl.geojson['features']first['geometry'].is_a? Array
      vl.geojson['features'].each do |f|
        f['geometry'] = f['geometry'].first
      end
    end
    vl.tmp_geojson = vl.geojson
    vl.save
  end
end
