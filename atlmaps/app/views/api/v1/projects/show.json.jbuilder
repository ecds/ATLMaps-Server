json.project do
  json.id @project.id
  json.name @project.name
  json.saved @project.saved
  json.published @project.published
  json.layer_ids @layer_ids
  json.layers @project.layers
end