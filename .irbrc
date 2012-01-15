class Object
	def grep_method(str)
		self.methods.grep(/#{str}/).sort
	end

	alias :g :grep_method
end
