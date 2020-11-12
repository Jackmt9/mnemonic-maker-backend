class RemoveSnippetsFromSnippetTank < ActiveRecord::Migration[6.0]
  def change
    remove_column :snippet_tanks, :snippets, :text
  end
end
