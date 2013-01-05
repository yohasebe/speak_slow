require 'minitest/autorun'
require 'speak_slow'

class TestSpeakSlow < MiniTest::Unit::TestCase
  
  def setup
    @infile = SpeakSlow::DATA_DIR + "/MLK_Dream.mp3"
    @outdir  = File.expand_path(File.dirname(__FILE__)) + "/result"
    `rm -rf #{@outdir}` if File.exists? @outdir    
    `mkdir #{@outdir}` unless File.exists? @outdir        
    @outfile  = @outdir + "/result.mp3"
    @speakslow = SpeakSlow::Converter.new(@infile, @outfile)
  end
  
  def test_execution
    @speakslow.execute(speed = 1.5, silence = 2)
  end

  def teardown
    # `rm -rf #{@outdir}` if File.exists?(@outdir)
  end
end