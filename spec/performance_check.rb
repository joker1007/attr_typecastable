require 'benchmark/ips'
require 'attr_typecastable'

class User
  include AttrTypecastable

  typed_attr_accessor :name, String
end

user = User.new

Benchmark.ips do |x|
  x.report("writer") { user.name = 10 }
end
