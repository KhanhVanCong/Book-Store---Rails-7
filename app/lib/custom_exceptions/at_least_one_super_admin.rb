# frozen_string_literal: true

module CustomExceptions
  class AtLeastOneSuperAdmin < Exception
    def initialize(message = nil)
      super(message || "can't update/destroy this record because we have at least one super admin.")
    end
  end
end