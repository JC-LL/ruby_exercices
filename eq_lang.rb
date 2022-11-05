require 'sxp'

module EqLang
  System=Struct.new(:name,:equations)
  Equation=Struct.new(:id,:lhs,:rhs)
  Binary= Struct.new(:lhs,:op,:rhs)

  Var=Struct.new(:name)
  Int=Struct.new(:val)
  Real=Struct.new(:val)

  class Compiler

    def parse code
      sxp=SXP.read(code)
      ast=objectify(sxp)
    end

    def objectify sxp
      case sxp
      in [:system,name,*equations]
        System.new(name,equations.map{|eq| objectify(eq)})
      in [:equation,id,lhs,rhs]
        Equation.new(id.to_i,objectify(lhs),objectify(rhs))
      in [:add,lhs,rhs]
        Binary.new(objectify(lhs),:add,objectify(rhs))
      in [:sub,lhs,rhs]
        Binary.new(objectify(lhs),:sub,objectify(rhs))
      in [:mul,lhs,rhs]
        Binary.new(objectify(lhs),:mul,objectify(rhs))
      in [:div,lhs,rhs]
        Binary.new(objectify(lhs),:div,objectify(rhs))
      in Integer
        Int.new(sxp)
      in Float
        Real.new(sxp)
      in Symbol
        Var.new(sxp)
      end
    end
  end
end

code=%{
  (system test
    (equation 1 y (add 1 x))
    (equation 2 (div z 3.14) (sub y (mul a b)))
  )
}

compiler=EqLang::Compiler.new
pp compiler.parse code
