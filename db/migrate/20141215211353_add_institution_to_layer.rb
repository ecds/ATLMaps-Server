class AddInstitutionToLayer < ActiveRecord::Migration
  def change
    # add_reference :layers, :institution, index: true, :after => :maxy
  end
end
