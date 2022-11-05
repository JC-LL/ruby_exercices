# We keep track of token position.

Token=Struct.new(:kind,:val,:pos)

module Sexp
  class Lexer
    def tokenize str
      tokens=[]
      while str.size>0
        case str
        when /\A\n/
          tokens << Token.new(:newline,$&)
        when /\A +/
          tokens << Token.new(:space,$&)
        when /\A\(/
          tokens << Token.new(:lparen,$&)
        when /\A\)/
          tokens << Token.new(:rparen,$&)
        when /\A\=/
          tokens << Token.new(:eq,$&)
        when /\A[\+\-\*\/]/
          tokens << Token.new($&.to_sym,$&)
        when /\A[a-z]+(\w)*\b/
          tokens << Token.new(:ident,$&)
        when /\A[+-]?[0-9]+\.[0-9]+/
          tokens << Token.new(:float_lit,$&)
        when /\A[+-]?[0-9]+/
          tokens << Token.new(:int_lit,$&)
        when /\A\"(.*)\"/
          tokens << Token.new(:str_lit,$&)
        else
          raise "lexical error : #{str[0..-1]}"
        end
        str.delete_prefix!($&)
        tokens.last.pos=compute_pos($&)
      end
      return tokens
    end

    def compute_pos str
      @line||=1
      @col||=1
      old_col=@col
      if str=="\n"
        @line+=1
        @col=1
      else
        @col+=str.size
      end
      [@line,old_col]
    end
  end
end

if $PROGRAM_NAME==__FILE__
  txt=IO.read(ARGV.first)
  pp Sexp::Lexer.new.tokenize txt
end
