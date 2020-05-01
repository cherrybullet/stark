module Stark
  class Environment
    def initialize(enclosing=nil)
      @values = {}
      @enclosing = enclosing
    end

    def define_var(name, value)
      @values[name] = value
    end

    def assign(name, value)
      if @values.has_key?(name.lexeme)
        @values[name.lexeme] = value
        return true
      end

      if @enclosing
        @enclosing.assign(name, value)
        return true
      end

      puts "Undefined variable `#{name.lexeme}`."
    end

    def get_var(name)
      if @values.has_key?(name.lexeme)
        @values[name.lexeme]
      elsif @enclosing
        @enclosing.get_var(name)
      else
        raise "Undefined variable `#{name.lexeme}`."
      end
    end
  end
end
