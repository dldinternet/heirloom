require 'spec_helper'
require 'heirloom/cli'

describe Heirloom do

  before do

    @catalog = { 'heirloom_test1' =>
                   { 'regions'       => ['us-west-1', 'us-east-1'],
                     'bucket_prefix' => ['bp1'] },
                 'heirloom_test2' =>
                   { 'regions'       => ['us-west-2'],
                     'bucket_prefix' => ['bp2'] }
               } 
    @formatter = Heirloom::CLI::Formatter::Catalog.new :catalog => @catalog


  end

  context "unfiltered" do
    it "should return the summary formatted list" do

      @formatter.summary_format(:region  => 'us-west-1',
                        :details => nil,
                        :name    => nil ).should == "us-west-1\n  test1\n  test2"
    end
  end

  context "filtered" do
    it "should return the name with details when passed in the name and region" do
      format = "test1\n" +
          "  metadata_region  : us-west-1\n" +
          "  regions          : us-east-1, us-west-1\n" +
          "  bucket_prefix    : bp1\n" +
          "  us-east-1-s3-url : s3://bp1-us-east-1/test1\n" +
          "  us-west-1-s3-url : s3://bp1-us-west-1/test1"

      @formatter.detailed_format(:region  => 'us-west-1',
                        :details => nil,
                        :name    => 'test1').should == format

    end
  end

end
