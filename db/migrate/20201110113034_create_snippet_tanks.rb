class CreateSnippetTanks < ActiveRecord::Migration[6.0]
  def change
    create_table :snippet_tanks do |t|
      t.text :snippets

      t.timestamps
    end
  end
end
