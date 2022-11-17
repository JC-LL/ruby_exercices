Token=Struct.new(:kind,:val)
module VHDL
  class Lexer
    def tokenize txt
      tokens=[]
      while txt.size>0
        case txt
        when /\A\s+/
        when /\Aentity/
          tokens << Token.new(:entity,$&)
        when /\A\(/
          tokens << Token.new(:lparen,$&)
        when /\A\)/
          tokens << Token.new(:rparen,$&)
        when /\A\,/
          tokens << Token.new(:comma,$&)
        when /\A\;/
          tokens << Token.new(:semicolon,$&)
        when /\A\:/
          tokens << Token.new(:colon,$&)
        when /\Ais/
          tokens << Token.new(:is,$&)
        when /\Ain/
          tokens << Token.new(:in,$&)
        when /\Aout/
          tokens << Token.new(:out,$&)
        when /\Abit/
          tokens << Token.new(:bit,$&)
        when /\Aboolean/
          tokens << Token.new(:boolean,$&)
        when /\Abegin/
          tokens << Token.new(:begin,$&)
        when /\Aend/
          tokens << Token.new(:end,$&)
        when /\Aof/
          tokens << Token.new(:of,$&)
        when /\Aport/
          tokens << Token.new(:port,$&)
        when /\Aport/
          tokens << Token.new(:in,$&)
        when /\Aarchitecture/
          tokens << Token.new(:architecture,$&)
        when /\A[a-z]+\w*/
          tokens << Token.new(:ident,$&)
        when /\A\;/
          tokens << Token.new(:semicolon,$&)
        else
          raise "lexical error : #{txt}"
        end
        txt=txt.delete_prefix!($&)
      end
      tokens
    end
  end
end

# src=IO.read(ARGV.first)
# pp VHDL::Lexer.new.tokenize src
