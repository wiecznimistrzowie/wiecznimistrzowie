# frozen_string_literal: true

module Infra::EventStore
  class ExampleWasInitialized < DomainEvent
    prop :foo_id, Types::Integer
  end

  class ExampleWasPopulated < DomainEvent
    prop :foo_id, Types::Integer
    prop :bar, Types::String
  end

  ExampleView = Decider::View.define do
    initial_state ExampleState.new

    evolve ExampleWasInitialized do
      state.id = event.foo_id
    end

    evolve ExampleWasPopulated do
      state.bar = event.bar
    end
  end

  class ExampleState < Sequel::Model
    def self.fetch_state(event)
      where(id: event.foo_id).first
    end
  end

  class TestMaterializedView < Minitest::Test
    def test_empty_state
      materialized_view = MaterializedView.new(
        state_repository: ExampleState,
        view: ExampleView
      )

      materialized_view.call(ExampleWasInitialized.new(foo_id: 1))

      record = ExampleState.first

      assert_equal 1, record.id
      assert_nil record.bar
    end

    def test_evolve_state
      materialized_view = MaterializedView.new(
        state_repository: ExampleState,
        view: ExampleView
      )

      ExampleState.create(id: 1, bar: "FOO")

      materialized_view.call(ExampleWasPopulated.new(foo_id: 1, bar: "baz"))

      record = ExampleState.first

      assert_equal 1, record.id
      assert_equal "baz", record.bar
    end
  end
end
