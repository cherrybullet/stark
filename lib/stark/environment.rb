module Stark
  class Environment
    def initialize
      @values = {}
    end

    def define_var(name, value)
      @values[name] = value
    end

    def assign(name, value)
      if @values.has_key?(name.lexeme)
        @values[name.lexeme] = value
        return true
      end

      puts "Undefined variable `#{name.lexeme}`."
    end

    def get_var(name)
      if @values.has_key?(name.lexeme)
        @values[name.lexeme]
      else
        raise "Undefined variable `#{name.lexeme}`."
      end
    end
  end
end
