json.projectlayers @projectlayers do |projectlayer|
  json.id projectlayer.id
  json.project_id projectlayer.project_id
  json.layer_id projectlayer.layer_id
  json.marker projectlayer.marker
end