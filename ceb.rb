
Problem  = Struct.new(:target,:numbers)
Solution = Struct.new(:result,:formula)

class Solver

  OPS   = [:+,:-,:*,:/]
  SIDES = [:u,:d]

  def initialize problem
    @problem=problem
    puts "#{@problem.target} with #{@problem.numbers.join(',')} "
    solve
  end

  def solve
    @best_solution=Solution.new(nil,"")
    nb_exprs=@problem.numbers.size-1 # yes.surprising ?
    @problem.numbers.permutation(@problem.numbers.size).to_a.each do |numbers|
      OPS.repeated_permutation(nb_exprs).each do |ops|
        SIDES.repeated_permutation(nb_exprs).each do |sides|
          apply(ops.clone,numbers.clone,sides.clone)
        end
      end
    end
    puts @best_solution.formula
  end

  def apply ops,numbers,sides
    @current=Solution.new(nil,"")
    @stack=numbers
    while ops.any?
      op=ops.shift
      side=sides.shift
      a=@stack.pop
      b=@stack.pop
      result=compute(a,op,b)
      next if result.nil?
      analyze(result)
      if result and result!=0
        case side
        when :u
          @stack.push result
        when :d
          @stack.unshift result
        end
      end
    end
  end

  def compute a,op,b
    str=nil
    unless a.nil? or b.nil?
      case op
      when :+
        ret=a+b
      when :-
        ret=b>a ? b-a : a-b
        str=b>a ? "#{b}#{op}#{a}=#{ret}\n" : "#{a}#{op}#{b}=#{ret}\n"
      when :*
        ret=a*b
      when :/
        div,mod=a.divmod b
        ret=div
        return nil if mod!=0
      end
      str||="#{a}#{op}#{b}=#{ret}\n"
      @current.formula+=str unless (ret.nil? or ret==0)
      return ret
    end
  end

  def analyze result
    if result==@problem.target
      puts "le compte est bon !"
      puts @current.formula
      abort
    else
      if @best_solution.result
        if (@problem.target-result).abs < (@problem.target-@best_solution.result).abs
          @best_solution = Solution.new(result,@current.formula)
        end
      else
        @best_solution = Solution.new(result,@current.formula)
      end
    end
  end
end

if ARGV.any?
  target,*nums=ARGV.map(&:to_i)
else
  nums=[(1..10).to_a,25,50,75,100].flatten.sample(6)
  target=rand(101..999)
end

problem=Problem.new(target,nums)
Solver.new problem
