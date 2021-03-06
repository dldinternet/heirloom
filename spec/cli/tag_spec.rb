require 'spec_helper'
require 'heirloom/cli'

describe Heirloom do

  before do
    options = { :name            => 'archive_name',
                :id              => '1.0.0',
                :level           => 'info',
                :attribute       => 'att',
                :value           => 'val',
                :metadata_region => 'us-west-1' }
    @logger_double = double :debug => true, :error => true
    @config_double = double_config(:logger => @logger_double)
    @archive_double = double 'archive'

    Trollop.stub(:options).and_return options
    Heirloom::HeirloomLogger.should_receive(:new).with(:log_level => 'info').
                             and_return @logger_double
    Heirloom::CLI::Tag.any_instance.should_receive(:load_config).
                       with(:logger => @logger_double,
                            :opts   => options).
                       and_return @config_double
    Heirloom::Archive.should_receive(:new).
                      with(:name => 'archive_name',
                           :config => @config_double).
                      and_return @archive_double
    Heirloom::Archive.should_receive(:new).
                      with(:name   => 'archive_name',
                           :id     => '1.0.0',
                           :config => @config_double).
                      and_return @archive_double
    @archive_double.stub :exists? => true
    @archive_double.should_receive(:domain_exists?).and_return true
    @cli_tag = Heirloom::CLI::Tag.new
  end

  it "should tag an archive attribute with a given id" do
    @archive_double.stub :exists? => true
    @archive_double.should_receive(:update).
                    with(:attribute => 'att',
                         :value     => 'val')
    @cli_tag.tag
  end

  it "should exit if the archive does not exist" do
    @archive_double.stub :exists? => false
    lambda { @cli_tag.tag }.should raise_error SystemExit
  end

end
