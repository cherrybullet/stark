module Stark
  class Function
    attr_reader :closure
    attr_reader :declaration

    def initialize(declaration, closure)
      @declaration, @closure = declaration, closure
    end

    def arity
      @declaration.params.size
    end

    def to_s
      "<fn #{@declaration.name.lexeme}>"
    end

    def call(interpreter, arguments)
      # interpreter.globals what?
      _environment = Environment.new(@closure)
      @declaration.params.each.with_index do |_declaration, index|
        _environment.define_var(_declaration.lexeme, arguments[index])
      end
      begin
        interpreter.executeBlock(@declaration.body, _environment)
      rescue ReturnSkip => skip
        return skip.value
      end
      nil
    end
  end
end
