require 'mutations'

module Mutations
  class Outcome
    def * other
      @success = @success && other.success?
      @result = [*@result] << other.result
      @errors = [*@errors] << other.errors
      @inputs = (@inputs.is_a?(Hash) ? [@inputs] : @inputs) << other.inputs
      self
    end
  end
end

class MutationBase < Mutations::Command
  required do
    model :workflow
    array :args
  end

  def execute
    42
  end
end

class MutationList
  include Enumerable

  def run *args
    runner.run *args
  end

  def runner
    return @runner if @runner

    @runner = Class.new(MutationBase)
    @runner.class_eval %{
      def execute
        #{@mutations}.map do |m|
          m.new(inputs).run
        end.reduce(&:*).result
      end
    }
    @runner
  end
  private :runner

  def initialize *args
    @runner = nil
    @mutations = args.map(&method(:applicable)).compact
  end

  def each
    @mutations.each &Proc.new
  end

  def append smth
    @mutations.push(smth) if applicable(smth)
  end
  def prepend smth
    @mutations.unshift(smth) if applicable(smth)
  end

  def applicable smth
    smth = const_get(smth) unless smth.is_a?(Class) rescue nil
    if smth.is_a?(Class) && smth <= MutationBase
      @runner = nil
      smth
    end
  end
  private :applicable
end
