module Stark
  module Expr
    class Binary
      attr_reader :left
      attr_reader :operator
      attr_reader :right

      def initialize(left, operator, right)
        @left, @operator, @right = left, operator, right
      end

      def accept(visitor)
        visitor.visitBinaryExpr(self)
      end
    end

    class Assign
      attr_reader :name
      attr_reader :value

      def initialize(name, value)
        @name, @value = name, value
      end

      def accept(visitor)
        visitor.visitAssignExpr(self)
      end
    end

    class Call
      attr_reader :callee
      attr_reader :paren
      attr_reader :args

      def initialize(callee, paren, args)
        @callee, @paren, @args = callee, paren, args
      end

      def accept(visitor)
        visitor.visitCallExpr(self)
      end
    end

    class Get
      attr_reader :object
      attr_reader :name

      def initialize(object, name)
        @object, @name = object, name
      end

      def accept(visitor)
        visitor.visitGetExpr(self)
      end
    end

    class Grouping
      attr_reader :expression

      def initialize(expression)
        @expression = expression
      end

      def accept(visitor)
        visitor.visitGroupingExpr(self)
      end
    end

    class Literal
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def accept(visitor)
        visitor.visitLiteralExpr(self)
      end
    end

    class Logical
      attr_reader :left
      attr_reader :operator
      attr_reader :right

      def initialize(left, operator, right)
        @left, @operator, @right = left, operator, right
      end

      def accept(visitor)
        visitor.visitLogicalExpr(self)
      end
    end

    class Set
      attr_reader :object
      attr_reader :name
      attr_reader :value

      def initialize(object, name, value)
        @object, @name, @value = object, name, value
      end

      def accept(visitor)
        visitor.visitSetExpr(self)
      end
    end

    class Super
      attr_reader :keyword
      attr_reader :method

      def initialize(keyword, method)
        @keyword, @method = keyword, method
      end

      def accept(visitor)
        visitor.visitSuperExpr(self)
      end
    end

    class This
      attr_reader :keyword

      def initialize(keyword)
        @keyword = keyword
      end

      def accept(visitor)
        visitor.visitThisExpr(self)
      end
    end

    class Unary
      attr_reader :operator
      attr_reader :right

      def initialize(operator, right)
        @operator, @right = operator, right
      end

      def accept(visitor)
        visitor.visitUnaryExpr(self)
      end
    end

    class Variable
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def accept(visitor)
        visitor.visitVariableExpr(self)
      end
    end
  end
end
