#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
require "rails_erd/diagram/graphviz"

config = {
  title: "Canadian Museum of Nature :: MIMSY XG",
  attributes: ['primary_keys', 'foreign_keys', 'content', 'timestamps'],
  direct: true,
  only: "Catalog",
  exclude: nil
}

RailsERD::Diagram::Graphviz.create(config)