json.project do
	json.id @project.id
	json.name @project.name
	json.description @project.description
	json.owner @project.owner
	json.published @project.published
	json.saved @project.saved
	json.layer_ids @project.layer_ids
	json.is_mine @is_mine
	json.may_edit @may_edit
end