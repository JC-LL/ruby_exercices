require 'sxp'

module MiniVHDL

  module AST
    Root    = Struct.new(:elements)
    Entity  = Struct.new(:name,:ports)
    Generic = Struct.new(:name,:type,:value)
    Port    = Struct.new(:direction,:name,:type)
    StdLv   = Struct.new(:size)
    Range   = Struct.new(:direction,:lhs,:rhs)
    Arch    = Struct.new(:name,:entity)
  end

  class Compiler

    def parse code
      pp sxp=SXP.read(code)
      pp ast=objectify(sxp)
    end

    def objectify sxp
      case sxp
      in [entity,arch]
        AST::Root.new [objectify(entity),objectify(arch)]
      in [:entity,name,port]
        AST::Entity.new(name,objectify(port))
      in [:port,*ports]
        ports.map{|port| objectify(port)}
      in [:in,name,type]
        AST::Port.new(:in,name,type)
      in [:out,name,type]
        AST::Port.new(:out,name,type)
      in [:stdlv,size]
        AST::StdLv.new(size.to_i)
      in [:out,name,type]
        AST::Port.new(:out,name,type)
      in [:architecture,name,entity_name]
        AST::Arch.new(name,entity_name)
      end
    end
  end
end

code=IO.read(ARGV.first)
compiler=MiniVHDL::Compiler.new
compiler.parse code
