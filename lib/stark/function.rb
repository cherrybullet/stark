module Stark
  class Function
    attr_reader :declaration

    def initialize(declaration)
      @declaration = declaration
    end

    def arity
      @declaration.params.size
    end

    def to_s
      "<fn #{@declaration.name.lexeme}>"
    end

    def call(interpreter, arguments)
      _environment = Environment.new(interpreter.globals)
      @declaration.params.each.with_index do |_declaration, index|
        _environment.define_var(_declaration.lexeme, arguments[index])
      end
      # catch Return returnValue -> returnValue.value
      interpreter.executeBlock(@declaration.body, _environment)
      nil
    end
  end
end
