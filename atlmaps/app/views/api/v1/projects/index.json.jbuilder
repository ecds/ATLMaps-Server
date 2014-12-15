json.projects @projects do |project|
  json.id project.id
  json.name project.name
  #json.layer_ids @layer_ids
  json.layers project.layers do |layer|
    json.id layer.id
    json.name layer.name
  end
end