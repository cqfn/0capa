# frozen_string_literal: true

# Contains the default ActiveRecord
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
