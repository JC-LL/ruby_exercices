require_relative 'vhdl_ast'
require_relative 'vhdl_lexer'

module VHDL
  class Parser
    attr_accessor :tokens

    def parse filename
      puts "parsing #{filename}"
      txt=IO.read(filename)
      @tokens=Lexer.new.tokenize(txt)
      root=Root.new([])
      while @tokens.any?
        root.elements << parse_design_unit()
      end
      puts "parsing successfull ! #{@tokens.size}"
      pp root
    end

    def accept_it
      @tokens.shift
    end

    def show_next
      @tokens.first
    end

    def expect kind
      if show_next.kind!=kind
        raise "expecting '#{kind}'. Received token #{show_next.kind} '#{show_next.val}'"
      else
        accept_it
      end
    end

    def parse_design_unit
      case show_next.kind
      when :entity
        parse_entity()
      when :architecture
        parse_architecture()
      else
        raise "expecting either 'entity' or 'architecture' keyword"
      end
    end

    def parse_entity
      expect :entity
      name=expect(:ident)
      ports=nil
      expect :is
      if show_next.kind==:port
        parse_port()
      end
      expect :end
      expect :entity
      expect :semicolon
      Entity.new(name,ports)
    end

    def parse_port
      expect :port
      expect :lparen
      while show_next.kind!=:rparen
        parse_io_decl
        unless show_next.kind==:rparen
          expect :semicolon
        end
      end
      expect :rparen
      expect :semicolon
    end

    def parse_io_decl
      expect :ident
      while show_next.kind==:comma
        accept_it
        expect :ident
      end
      expect :colon
      if [:in,:out].include?(show_next.kind)
        accept_it
      end
      if [:bit,:boolean].include?(show_next.kind)
        accept_it
      end
    end


    def parse_architecture
      expect :architecture
      name=expect :ident
      expect :of
      entity_name=expect :ident
      expect :is
      expect :begin
      expect :end
      expect :ident
      expect :semicolon
      Archi.new(name,entity_name)
    end

  end
end

filename=ARGV.first
parser=VHDL::Parser.new
parser.parse filename
