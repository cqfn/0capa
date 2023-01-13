# frozen_string_literal: true

require 'csv'

class GeneratedCapa < ApplicationRecord
  def self.to_csv(url)
    capas = where(repo_name: url)
    CSV.generate do |csv|
      csv << column_names
      capas.each do |capa|
        csv << capa.attributes.values_at(*column_names)
      end
    end
  end

  def self.all_to_csv
    capas = all
    CSV.generate do |csv|
      csv << column_names
      capas.each do |capa|
        csv << capa.attributes.values_at(*column_names)
      end
    end
  end
end
