require 'spec_helper'
require 'pact_broker/configuration'
require 'pact_broker/api/renderers/html_pact_renderer'
require 'pact_broker/config/setting'

module PactBroker
  describe Configuration do

    context "default configuration" do
      describe ".html_pact_renderer" do

        let(:pact) { double('pact') }
        let(:options) { double('options') }

        it "calls the inbuilt HtmlPactRenderer" do
          expect(PactBroker::Api::Renderers::HtmlPactRenderer).to receive(:call).with(pact, options)
          PactBroker.configuration.html_pact_renderer.call pact, options
        end

      end

      describe "SETTING_NAMES" do
        let(:configuration) { PactBroker::Configuration.new}

        Configuration::SAVABLE_SETTING_NAMES.each do | setting_name |
          describe setting_name do
            it "exists as a method on a PactBroker::Configuration instance" do
              expect(configuration).to respond_to(setting_name)
            end
          end
        end
      end

      describe "save_to_database" do
        let(:configuration) { PactBroker::Configuration.default_configuration }

        it "saves the configuration to the database" do
          expect { configuration.save_to_database }.to change { PactBroker::Config::Setting.count }.by(Configuration::SAVABLE_SETTING_NAMES.size)
        end
      end

      describe "load_from_database!" do
        let(:configuration) { PactBroker::Configuration.new }

        before do
          PactBroker::Config::Setting.create(name: 'use_case_sensitive_resource_names', type: 'string', value: 'foo')
        end

        it "loads the configurations from the database" do
          configuration.load_from_database!
          expect(configuration.use_case_sensitive_resource_names).to eq "foo"
        end
      end

      describe "add_api_error_reporter" do
        let(:configuration) { PactBroker::Configuration.new }
        let(:block) { Proc.new{ | error, options | } }

        it "should add the error notifier " do
          configuration.add_api_error_reporter(&block)
          expect(configuration.api_error_reporters.first).to eq block
        end

        context "with a proc with the wrong number of arguments" do
          let(:block) { Proc.new{ | error | } }

          it "raises an error" do
            expect { configuration.add_api_error_reporter(&block) }.to raise_error PactBroker::ConfigurationError
          end
        end
      end
    end
  end
end
