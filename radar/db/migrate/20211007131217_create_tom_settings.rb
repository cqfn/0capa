class CreateTomSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :tom_settings do |t|
      t.string :agentname
      t.string :accesstokenendpoint
      t.string :authorizationbaseurl
      t.string :requesttokenendpoint
      t.string :authenticationmethod
      t.string :apikey
      t.string :apisecret
      t.string :isactive

      t.timestamps
    end
  end
end
