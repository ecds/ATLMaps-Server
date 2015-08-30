require 'httparty'
require 'nokogiri'

namespace :gs_harvest do
  desc "TODO"
  task sync: :environment do

	class Layers
		
		include HTTParty
		include Nokogiri

		def initialize(uri)
			@base_uri = uri
			@auth = {username: 'admin', password: 'geospatialisthefuture'}
		end

		def get_layers(workspace, type)
			response = HTTParty.get("#{@base_uri}/#{workspace}/#{type.downcase}s.xml", :basic_auth => @auth)
			
			layer_list = Array.new

			data = Nokogiri::XML(response.body)

			data.xpath("//#{type}//name//text()").each do |layer|
				layer_list.push self.get_layer_data(layer, workspace, type)
			end

			return layer_list

		end

		def get_layer_data(layer, workspace, type)
			response = HTTParty.get("#{@base_uri}/#{workspace}/#{type.downcase}s/#{layer}.xml", :basic_auth => @auth)

			data = Nokogiri::XML(response.body)

			abstract = data.xpath("//#{type}//abstract//text()")
			minx = data.xpath("//#{type}//latLonBoundingBox//minx//text()")
			maxx = data.xpath("//#{type}//latLonBoundingBox//maxx//text()")
			miny = data.xpath("//#{type}//latLonBoundingBox//miny//text()")
			maxy = data.xpath("//#{type}//latLonBoundingBox//maxy//text()")

			layer_data = {
				:name => layer.to_s,
				:abstract => abstract.to_s,
				:minx => minx.to_s,
				:maxx => maxx.to_s,
				:miny => miny.to_s,
				:maxy => maxy.to_s,
			}

			if RasterLayer.where(name: layer_data[:name]).empty?
				self.create_layer(layer_data)
			end

			return layer_data

		end

		def create_layer(layer_data)
			new_layer = RasterLayer.new()
			new_layer.name = layer_data[:name]
			new_layer.description = layer_data[:abstract]
			new_layer.minx = layer_data[:minx]
			new_layer.maxx = layer_data[:minx]
			new_layer.miny = layer_data[:minx]
			new_layer.maxy = layer_data[:minx]
			# new_layer.save
		end

	end

	gs = Layers.new('http://geospatial.library.emory.edu:8081/geoserver/rest/workspaces')

	#vector_layers = gs.get_layers('ATLMaps', 'featureType')
	raster_layers =  gs.get_layers('ATLMaps', 'coverage')

	#puts vector_layers
	puts raster_layers
  
  end

end
