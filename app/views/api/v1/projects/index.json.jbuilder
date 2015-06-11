json.projects @projects do |project|
	json.id @project.id
	json.name @project.name
	json.description @project.description
	json.owner @project.owner
	json.published @project.published
	json.saved @project.saved
	#json.layer_ids @project.layer_ids
end