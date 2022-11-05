require_relative 'sexp_lexer'

#
# 1) Here we generate a Ruby Array structure, representative of the AST.
# ---
# We have choosen to feed the arrays with the _value_ of the tokens, so
# that we can further apply Ruby pattern matching on these Arrays, to
# get a typed AST, as performed in eq_lang.rb and mini_vhdl.rb etc.
# ----
# 2) However, this example can be modified to *directly* generate a typed AST.
#

module Sexp
  class Parser
    def parse str
      @tokens=Lexer.new.tokenize(str)
      @tokens=@tokens.reject{|tok| tok.kind==:space}
      parse_parenth_expr
    end

    def parse_parenth_expr
      content=[]
      expect :lparen
      while (tok=show_next).kind!=:rparen
        case tok.kind
        when :lparen
          content << parse_parenth_expr
        when :ident
          tok=accept_it
          content << tok.val.to_sym
        when :int_lit
          tok=accept_it
          content << tok.val.to_i
        when :float_lit
          tok=accept_it
          content << tok.val.to_f
        when :str_lit
          tok=accept_it
          content << tok.val.to_s
        when :+,:-,:*,:/
          tok=accept_it
          content << tok.kind
        else
          raise "ERROR : syntactical error on token '#{show_next}'"
        end
      end
      expect :rparen
      return content
    end

    def show_next
      @tokens.first
    end

    def expect tok_kind
      actual_kind=show_next.kind
      if tok_kind!=actual_kind
        raise "ERROR : expecting token '#{tok_kind}'. Received #{actual_kind}"
      else
        accept_it
      end
    end

    def accept_it
      @tokens.shift
    end
  end
end

# testing
if $PROGRAM_NAME==__FILE__
  # to compare OUR parser with "sxp" gem
  require "sxp"
  txt=IO.read(ARGV.first)
  pp SXP.read(txt)

  pp Sexp::Parser.new.parse(txt)
end
