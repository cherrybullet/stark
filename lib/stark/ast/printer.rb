module Stark
  module AST
    class Printer
      def print(statements)
        statements.map do |statement|
          statement.accept(self)
        end
      end

      def visitBinaryExpr(expr)
        {
          name: 'BinaryExpr',
          contents: [
            {
              name: "0perator (#{expr.operator.lexeme})",
              contents: [
                expr.left.accept(self),
                expr.right.accept(self)
              ]
            }
          ]
        }
      end

      def visitGroupingExpr(expr)
        {
          name: 'GroupingExpr',
          contents: [
            expr.expression.accept(self),
          ]
        }
      end

      def visitLiteralExpr(expr)
        {
          name: 'LiteralExpr',
          contents: [
            {
              name: expr.value.nil? ? 'nil' : expr.value.to_s
            }
          ]
        }
      end

      def visitUnaryExpr(expr)
        {
          name: 'UnaryExpr',
          contents: [
            {
              name: "0perator (#{expr.operator.lexeme})",
              contents: [
                expr.right.accept(self)
              ]
            }
          ]
        }
      end
    end
  end
end
