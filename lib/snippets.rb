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
geo_data[:features].select {|n| n[:properties]['NAME'] == 'Reynoldstown'}

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
  hood_geo = geo_data[:features].select {|n| n[:properties]['NAME'] == hood_name}
  if hood_geo.empty?
    missing2.push(hood_name)
    next
  end
  link = "https://en.wikipedia.org/wiki/#{hood['title'].gsub(' ', '_')}"
  hood_geo.first[:properties]['description'] = "#{wiki_content['extract']} <p>Source: <a href='#{link}>Wikipedia</a><p>"
end; nil

wiki_data['query']['categorymembers'].each do |hood|
  url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&pageids=#{hood['pageid']}"
  puts(url)
  wiki = Faraday.get(url)
  wiki_content = JSON.parse(wiki.body)
  puts(wiki_content['query']['pages'][hood['pageid']]['extract'])
end; nil

missing = []
vl.tmp_geojson[:features].each do |f|
  if f[:properties]['description'].nil?
    missing.push(f[:properties]['title'])
  end
end

title = 'Druid Hills'
wiki_title = 'Druid_Hills,_Georgia'
id = '110038'
r = vl.tmp_geojson[:features].select {|n| n[:properties]['title'] == title}.first
url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&pageids=#{id}"
wiki = HTTParty.get(url)
w = JSON.parse(wiki.body)
content = w['query']['pages'][id]['extract']
r[:properties]['description'] = "#{content}<p>Source: <a href='https://en.wikipedia.org/wiki/#{wiki_title}'>Wikipedia</a></p>"
puts(r[:properties]['description'])


rows = CSV.read('/data/geocoder.csv', headers: true, header_converters: :symbol)
b = VectorLayer.find(570)
geojson = JSON.parse(HTTParty.get(geoserver_url).body, symbolize_names: true)
RGeo::GeoJSON.decode(b.geojson[:features].first['geometry'])
factory = RGeo::Geographic.simple_mercator_factory
factory.point(rows.first[:latitude].to_f, rows.first[:longitude].to_f)

buildings = []
poly = RGeo::GeoJSON.decode(geojson[:features].first[:geometry].to_json)
rows.each do |r|
  point = factory.point(r[:longitude].to_f, r[:latitude].to_f)
  if point.within?(poly)
    puts(point)
    buildings.push(r)
  end
end

rows.each do |r|
  next if r[:longitude].to_f.nil?
  next if r[:latitude].to_f.nil?
  r[:point] = factory.point(r[:longitude].to_f, r[:latitude].to_f)
end

geojson[:features].each do |feature|
  poly = RGeo::GeoJSON.decode(feature[:geometry].to_json, geo_factory: factory)
  next if poly.nil?
  feature[:properties][:occupants] = []
  rows.each do |r|
    next if r[:point].nil?
    if r[:point].within? poly
      puts(r[:stnam])
      buildings.push(r[:stnam])
      feature[:properties][:occupants].push(r.to_h)
    end
  end
end


VectorLayer.all.each do |vl|
  if vl.url.nil? && vl.vector_features.count > 0
    vl.tmp_geojson = {type: 'FeatureCollection', features: []}
    vl.vector_features.each do |f|
      feature = {type: 'Feature', geometry: {type: f.geojson['geometries'].first['type'], coordinates: f.geojson['geometries'].first['coordinates'] } , properties: f.geojson[:properties]}
      vl.tmp_geojson[:features].push(feature)
    end
    vl.save
  end
end

VectorLayer.all.each do |vl|
  puts vl.id
  if vl.tmp_geojson.nil? && vl.geojson
    if vl.geojson[:features]first['geometry'].is_a? Array
      vl.geojson[:features].each do |f|
        f['geometry'] = f['geometry'].first
      end
    end
    vl.tmp_geojson = vl.geojson
    vl.save
  end
end


VectorLayer.all.each do |vl|
  next if vl.tmp_geojson.nil?
    vl.tmp_geojson[:features].each do |f|
      next if f[:properties]['image'].nil?
      f[:properties][:images] = [f[:properties]['image']]
      f[:properties].delete('image')
    end
  vl.save
end


vl.tmp_geojson[:features].each do |f|
  images = f[:properties][:images]
  f[:properties][:images] = []
  images.each do |i|
    f[:properties][:images].push({url: i})
  end
  vl.save
end

VectorLayer.all.each do |vl|
  next if vl.tmp_geojson.nil?
  next if vl.tmp_geojson[:features].nil?
  if vl.tmp_geojson[:features].first[:properties][:gx_media_links].present?
    puts('Updating')
    vl.tmp_geojson[:features].each do |f|
      f[:properties][:youtube] = f[:properties][:gx_media_links]
      f[:properties].delete(:gx_media_links)
    end
    vl.save
  end
end; nil

VectorLayer.all.each do |vl|
  next if vl.tmp_geojson.nil?
  next if vl.tmp_geojson[:features].nil?
  if vl.tmp_geojson[:features].first[:properties][:images].is_a?(Array) && vl.tmp_geojson[:features].first[:properties][:images].first.is_a?(String)
    puts('Updating')
    vl.tmp_geojson[:features].each do |f|
      images = f[:properties][:images]
      next if images.nil?
      f[:properties][:images] = []
      images.each do |i|
        f[:properties][:images].push({url: i})
      end
      puts(f[:properties][:images])
    end
    vl.save
  end
end; nil

vl.tmp_geojson[:features].each do |f|
  next if f[:properties]['PHOTO LOCATION'] == 'NO PHOTO'
  photo_loc = f[:properties]['PHOTO LOCATION']
  collection = photo_loc.split('collection').last.split('/')[1]
  id = photo_loc.split('id').last.split('/')[1]
  html = Nokogiri::HTML.parse(f[:properties][:description])
  images = html.xpath("//img")
  puts images
  next if images.empty?
  # res = HTTParty.get(images.first['src'])
  # next if res.body.starts_with? "\xFF"
  images.first['src'] = "https://digitalcollections.library.gsu.edu/digital/api/singleitem/image/#{collection}/#{id}/default.jpg"
  f[:properties][:description] = html.to_s
end; nil

vls = [199, 207, 205, 201, 208, 200, 206]
vls.each do |i|
  vl = VectorLayer.find(i)
  vl.tmp_geojson[:features].each do |f|
    f[:properties][:description] = "#{f[:properties][:audio]}<br>#{f[:properties][:description]}"
    puts f[:properties][:description]
  end
  vl.save
end; nil

vl.tmp_geojson[:features].each do |f|
  image_url = "https://atlmaps-data.s3.amazonaws.com/holc/#{f[:properties][:holc_id]}.png"
  pdf_url = "https://atlmaps-data.s3.amazonaws.com/holc/#{f[:properties][:holc_id]}.pdf"
  f[:properties][:images] = [{url: image_url, link: pdf_url}]
end; nil

feature_ids = vl.tmp_geojson[:features].map {|f| f[:properties][:holc_id]}
vfs.each do |f|
  next if feature_ids.include? f.properties['holc_id']
  f.geojson['properties'] =
  geojson = f.geojson.transform_keys(&:to_sym)
  geojson[:type] = 'Feature'
  geojson[:properties] = f.properties.transform_keys(&:to_sym)
  geometry = geojson.delete(:geometries)
  geojson[:geometry] = geometry[0]
  vl.tmp_geojson[:features].append geojson
  puts f.properties['holc_id']
end; nil

Dir.foreach('.') do |f|
  next if f.start_with? '.'
  name = "#{f.to_s.split('.')[0]}.png"
  next if File.exist? name
  puts name
  i = MiniMagick::Image.open(f.to_s)
  i.format 'png'
  i.resize '25%'
  i.write name
  i.destroy!
end