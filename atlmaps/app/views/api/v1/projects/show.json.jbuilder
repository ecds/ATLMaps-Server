json.project do
  json.id @project.id
  json.name @project.name
  json.layer_ids @layer_ids
  #json.layers @project.layers do |layer|
  #  json.id layer.id
  #end
end