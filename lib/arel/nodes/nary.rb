module Arel

	module Nodes

		class Nary < Arel::Nodes::Node

			attr_reader :children


			def initialize children, right = nil
				super()
				unless Array === children
					warn "(#{caller.first}) #{ self.class.to_s.sub(/.*::/, '').upcase } nodes should be created with a list"
					children = [children, right]
				end
				@children = children
			end


			def initialize_copy other
				super
				@children = @children.map {|child| child.clone}
			end


			def left
				children.first
			end


			def left= child
				children[0] = child
			end


			def right
				children[1]
			end


			def right= child
				children[1] = child
			end


			def << child
				children << child
			end


			def hash
				children.hash
			end


			def eql? other
				self.class == other.class &&
				self.children == other.children
			end

			alias :== :eql?

		end

		%w{
			And
			Or
			Union
			UnionAll
			Except
			ExceptAll
			Intersect
			IntersectAll
			}.each do |name|
				const_set name, Class.new(Nary)
			end
		end

	end