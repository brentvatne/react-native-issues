class AddUniqueCommentersToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :unique_commenters, :integer
  end
end
