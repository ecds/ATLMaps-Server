class AddInstitutionToLayer < ActiveRecord::Migration[4.2]
  def change
    # add_reference :layers, :institution, index: true, :after => :maxy
  end
end
