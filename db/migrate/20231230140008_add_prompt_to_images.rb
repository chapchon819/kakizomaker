class AddPromptToImages < ActiveRecord::Migration[7.1]
  def change
    add_column :images, :prompt, :string, null: false
  end
end
