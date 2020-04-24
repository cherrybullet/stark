module Stark
  class Lexer
    def initialize
      @tokens   = []
      @start    = 0
      @current  = 0
      @line     = 1
      @keywords = {
        :and    => Token::AND,
        :class  => Token::CLASS,
        :else   => Token::ELSE,
        :false  => Token::FALSE,
        :for    => Token::FOR,
        :fun    => Token::FUN,
        :if     => Token::IF,
        :nil    => Token::NIL,
        :or     => Token::OR,
        :print  => Token::PRINT,
        :return => Token::RETURN,
        :super  => Token::SUPER,
        :this   => Token::THIS,
        :true   => Token::TRUE,
        :var    => Token::VAR,
        :while  => Token::WHILE,
      }
    end

    def tokenize(code)
      @code = code.chomp

      loop {
        break if at_end?
        @start = @current
        scan_token
      }

      @tokens << Token.new(type: Token::EOF, lexeme: '', literal: nil, line: @line)
    end

    private

    def scan_token
      char = advance
      case char
      when '(' then add_token(Token::LEFT_PAREN)
      when ')' then add_token(Token::RIGHT_PAREN)
      when '{' then add_token(Token::LEFT_BRACE)
      when '}' then add_token(Token::RIGHT_BRACE)
      when ',' then add_token(Token::COMMA)
      when '.' then add_token(Token::DOT)
      when '-' then add_token(Token::MINUS)
      when '+' then add_token(Token::PLUS)
      when ';' then add_token(Token::SEMICOLON)
      when '*' then add_token(Token::STAR)
      when '!' then add_token(match?('=') ? Token::BANG_EQUAL : Token::BANG)
      when '=' then add_token(match?('=') ? Token::EQUAL_EQUAL : Token::EQUAL)
      when '<' then add_token(match?('=') ? Token::LESS_EQUAL : Token::LESS)
      when '>' then add_token(match?('=') ? Token::GREATER_EQUAL : Token::GREATER)
      when '/'
        if match?('/')
          loop {
            break if peek == %{\n}
            break if at_end?
            advance
          }
        else
          add_token(Token::SLASH)
        end
      when ' '
      when '\r'
      when '\t'
      when %{\n}
        @line += 1
      when '"' then string
      else
        if digit?(char)
          number
        elsif alpha?(char)
          identifier
        else
          puts "Something goes wrong!!!"
        end
      end
    end

    def add_token(type, literal=nil)
      lexeme = @code[@start...@current]
      @tokens << Token.new(type: type, lexeme: lexeme, literal: literal, line: @line)
    end

    def match?(char)
      return false if at_end?
      return false unless @code[@current] == char

      @current += 1
      return true
    end

    def peek
      return '\0' if at_end?
      @code[@current]
    end

    def peek_next
      return '\0' if @current + 1 >= @code.length
      @code[@current + 1]
    end

    def identifier
      while alpha_numeric?(peek)
        advance
      end

      add_token(@keywords[@code[@start...@current].to_sym] || Token::IDENTIFIER)
    end

    def string
      loop {
        break if peek == '"'
        break if at_end?

        if peek == %{\n}
          @line += 1
        end

        advance
      }

      if at_end?
        puts "Something goes wrong!!!"
      else
        advance
        add_token(Token::STRING, @code[(@start + 1)...(@current - 1)])
      end
    end

    def number
      while digit?(peek)
        advance
      end

      if peek == '.' && digit?(peek_next)
        advance
        while digit?(peek)
          advance
        end
      end

      add_token(Token::NUMBER, @code[@start...@current].to_f)
    end

    def advance
      @current += 1
      @code[@current - 1]
    end

    def alpha_numeric?(char)
      alpha?(char) || digit?(char)
    end

    def digit?(char)
      ('0'..'9').include?(char)
    end

    def alpha?(char)
      ('a'..'z').include?(char) || ('A'..'Z').include?(char) || char == '_'
    end

    def at_end?
      @current >= @code.length
    end
  end
end
