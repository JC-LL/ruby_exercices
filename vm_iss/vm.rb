require 'sxp'

Reg      = Struct.new(:name,:val)

Program  = Struct.new(:name,:instructions)
Label    = Struct.new(:name)
Add      = Struct.new(:src1,:src2,:dest)
Sub      = Struct.new(:src1,:src2,:dest)
Mul      = Struct.new(:src1,:src2,:dest)
Div      = Struct.new(:src1,:src2,:dest)

class VM

  attr_accessor :ast

  def initialize nb_regs=10
    init_regs(nb_regs)
  end

  def init_regs nb_regs
    @reg=(0..nb_regs-1).map{|i| ["r#{i}".to_sym,0]}.to_h
  end

  def show_regs
    puts @reg.map{|r,v| "#{r.to_s.rjust(3)}:#{v.to_s(16).rjust(8,'0')}"}.join(" ")
  end

  def load source
    sxp=SXP.read(source)
    pp @program=compile(sxp)
  end

  def compile sxp
    case sxp
    in [:comment,str]
    in [:program,name,*instrs]
      instructions=instrs.map{|instr| compile(instr)}
      instructions.compact! #suppress nil arising from comments
      Program.new(name,instructions)
    in [:label,str]
      Label.new(str)
    in [:add,src1,src2,dest]
      Add.new(src1,src2,dest)
    in [:sub,src1,src2,dest]
      Sub.new(src1,src2,dest)
    in [:mul,src1,src2,dest]
      Mul.new(src1,src2,dest)
    in [:div,src1,src2,dest]
      Div.new(src1,src2,dest)
    end
  end

  def run
    puts "running program '#{@program.name}'"
    @program.instructions.each do |instr|
      case instr
      when Add,Sub,Mul
        src1=value_of(instr.src1)
        src2=value_of(instr.src2)
        case instr
        when Add
          @reg[instr.dest] = (src1 + src2) & 0xffffffff
        when Sub
          @reg[instr.dest] = (src1 - src2) & 0xffffffff
        when Mul
          @reg[instr.dest] = (src1 * src2) & 0xffffffff
        when Div
          raise "division by zero" if src2==0
          @reg[instr.dest] = (src1 % src2) & 0xffffffff
        end
      end
      @reg[:r0]=0
      show_regs
    end
  end

  def value_of src
    case src
    when Symbol
      @reg[src]
    when Integer
      src
    end
  end
end

source=%{
  (program test
    (add r0 3 r1) (comment "placer 3 dans R1")
    (add r0 3 r2)
    (sub r2 1 r2)
    (mul r1 r2 r1)
    (add r1 -4 r1)
    (add r1 -5 r1)

    (comment "on teste maintenant la division entiere 5/4=1")
    (add r0 5 r1)
    (add r0 4 r2)
    (div r1 r2 r1)

    (comment "on teste les labels")
    (comment "attention ! pas de basic blocs constitues")

    (label L1)
      (add r0 15 r1)
      (add r0 12 r2)

  )
}

vm=VM.new
vm.load source
vm.run
