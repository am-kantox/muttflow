require File.join(File.dirname(__FILE__), 'test_helper')

$VERBOSE = false
require 'active_record'
require 'sqlite3'
require 'workflow'
require 'workflow/draw'
require 'mocha/setup'
require 'stringio'

require 'pry'

ActiveRecord::Migration.verbose = false

class Producer < MutationBase
  def execute
    puts "IN PRODUCER: #{self.inputs}"
  end
end

class Sailor < MutationBase
  def execute
    puts "IN SAILOR: #{self.inputs}"
  end
end

class Thing < ActiveRecord::Base
  include Workflow
  workflow do
    state :invented do
      event :produce, :mutation => :Producer, :transitions_to => :produced, :meta => { :patent => 'MIT' }
    end
    state :produced do
      event :ship, :mutation => :Sailor, :transitions_to => :shipped
    end
    state :shipped
  end
end

class MutationsTest < ActiveRecordTestCase

  def setup
    super

    ActiveRecord::Schema.define do
      create_table :things do |t|
        t.string :title, :null => false
        t.string :person
        t.string :workflow_state
      end
    end

    exec "INSERT INTO things(title, person, workflow_state) VALUES('Ruby', 'Matz', 'invented')"
  end

  def assert_state(title, expected_state, klass = Thing)
    o = klass.find_by_title(title)
    assert_equal expected_state, o.read_attribute(klass.workflow_column)
    o
  end

  test 'immediately save the new workflow_state on state machine transition' do
    o = assert_state 'Ruby', 'invented'
    assert o.produce!
    assert_state 'Ruby', 'produced'
  end

  test 'persist workflow_state in the db and reload' do
    o = assert_state 'Ruby', 'invented'
    assert_equal :invented, o.current_state.name
    o.produce!(a: 1, b: 2)
    assert_state 'Ruby', 'produced'
    o.ship!
    assert_state 'Ruby', 'shipped'
    o.save!

    assert_state 'Ruby', 'shipped'

    o.reload
    assert_equal 'shipped', o.read_attribute(:workflow_state)
  end

end
