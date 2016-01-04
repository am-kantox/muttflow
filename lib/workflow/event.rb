require 'mutations'

module Workflow
  class Event

    attr_accessor :name, :transitions_to, :meta, :action, :condition
    attr_reader :mutation

    def initialize(name, transitions_to, mutation = nil, condition = nil, meta = {}, &action)
      @name = name
      @transitions_to = transitions_to.to_sym
      self.mutation = mutation # use setter to accept string, symbol and class as param
      @meta = meta
      @action = action
      @condition = if condition.nil? || condition.is_a?(Symbol) || condition.respond_to?(:call)
                     condition
                   else
                     raise TypeError, 'condition must be nil, an instance method name symbol or a callable (eg. a proc or lambda)'
                   end
    end

    def mutation= neu
      m = case neu
          when Symbol, String
            Kernel.const_defined?(neu.to_s) && Kernel.const_get(neu.to_s)
          when Class then neu
          else NilClass
          end

      @mutation = m <= ::Mutations::Command ? m : nil
    end

    def condition_applicable?(object)
      if condition
        if condition.is_a?(Symbol)
          object.send(condition)
        else
          condition.call(object)
        end
      else
        true
      end
    end

    def draw(graph, from_state)
      graph.add_edges(from_state.name.to_s, transitions_to.to_s, meta.merge(:label => to_s))
    end

    def to_s
      @name.to_s
    end
  end
end
