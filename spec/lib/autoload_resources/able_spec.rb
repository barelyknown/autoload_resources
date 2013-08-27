require "spec_helper"

class ActiveRecord
  class Base; end
end

class Example < ActiveRecord::Base
  attr_accessor :id
  def self.new(id=1)
    @id = id
  end
  def self.all
    [new(1), new(2)]
  end
  def self.find(id=3)
    new(id)
  end
  def ==(value)
    id = value.id
  end
end

class ExamplesController
  include ControllerResourceClass::Able
  include AutoloadResources::Able

  def self.before_action(method)
  end

  def self.controller_name
    "examples"
  end

  def params
    { id: 3 }
  end

end

describe ExamplesController do
  let!(:model_name) do
    double(:model_name, plural: "examples", element: "example")
  end
  before do
    Example.stub(:model_name) { model_name }
    ExamplesController.autoload_resources
  end
  it "should respond to autoload_resources" do
    expect(described_class).to respond_to :autoload_resources
  end

  it "should know its base class" do
    expect(described_class.autoload_base_class).to eq Example
  end

  it "should set the default for the index action" do
    subject.autoload_resources(:index)
    expect(subject.instance_variable_get("@examples")).to eq Example.all
  end

  it "should set the default for the new action" do
    subject.autoload_resources(:new)
    expect(subject.instance_variable_get("@example")).to eq Example.new
  end

  # [:show, :edit, :update, :destroy].each do |action_name|
    it "should set the default for the :show action" do
      subject.autoload_resources(:show)
      expect(subject.instance_variable_get("@example")).to eq Example.find
    end
  # end

  it "can set a custom block for an action" do
    described_class.autoload_resources do
      described_class.for_action(:index) { [] }
    end
    subject.autoload_resources(:index)
    expect(subject.instance_variable_get("@examples")).to eq []
  end

end