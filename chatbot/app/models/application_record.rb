# frozen_string_literal: true

# contains the default activeRecord
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
