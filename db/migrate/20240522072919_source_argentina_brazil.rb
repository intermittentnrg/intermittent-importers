class SourceArgentinaBrazil < ActiveRecord::Migration[7.1]
  def change
    rename_enum_value :regions, from: 'south_america', to: 'argentina'
    add_enum_value :regions, :brazil
  end
end
