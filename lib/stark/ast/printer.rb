module Stark
  module AST
    class Printer
      def print(statements)
        statements.map do |statement|
          statement.accept(self)
        end
      end

      def visitVarStmt(stmt)
        {
          name: 'VarStmt',
          contents: [
            { name: stmt.name.lexeme },
            stmt.initializer.nil? ? { name: 'nil' } : stmt.initializer.accept(self)
          ]
        }
      end

      def visitPrintStmt(stmt)
        {
          name: 'PrintStmt',
          contents: [
            stmt.expression.accept(self),
          ]
        }
      end

      def visitExpressionStmt(stmt)
        {
          name: 'ExpressionStmt',
          contents: [
            stmt.expression.accept(self),
          ]
        }
      end

      def visitVariableExpr(expr)
        {
          name: 'VariableExpr',
          contents: [
            { name: expr.name.lexeme }
          ]
        }
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
