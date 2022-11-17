module VHDL #=== 'metamodele'
  Root   = Struct.new(:elements)
  Entity = Struct.new(:name,:ports)
  Archi  = Struct.new(:name,:entity)
  Ports  = Struct.new(:elements)
end
