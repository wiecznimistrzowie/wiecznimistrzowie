# frozen_string_literal: true

module Infra
  Stream = Data.define(:name, :tags) do
    def build(command)
      suffix = tags.sort.map { "#{it}:#{command.send(it)}" }.join(";")

      "#{name}$#{suffix}"
    end
  end
end
