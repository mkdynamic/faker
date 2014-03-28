class Array
  unless self.method_defined? :sample
    def sample(*args)
      n = args[0] if Fixnum === args[0]
      #based on code from https://github.com/marcandre/backports
      size = self.length
      return self[Faker::Config.prng.rand(size)] if n.nil?

      n = n.to_int
      raise ArgumentError, "negative array size" if n < 0

      n = size if n > size

      result = Array.new(self)
      n.times do |i|
        r = i + Faker::Config.prng.rand(size - i)
        result[i], result[r] = result[r], result[i]
      end
      result[n..size] = []
      result
    end
  end
end
