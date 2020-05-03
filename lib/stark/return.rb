module Stark
  class Return
    attr_reader :value

    def initialize(value)
      @value = value
    end
  end

  class ReturnSkip < RuntimeError
    attr_reader :value

    def initialize(value)
      @value = value
      super('<ReturnSkip>')
    end
  end
end
