require "speak_slow/version"
require "rubygems"
require "progressbar"

module SpeakSlow
  DATA_DIR = File.expand_path(File.dirname(__FILE__) + "/../data")
  class Converter
    def initialize(in_filepath, out_filepath)
      if /([^\/]+)\.([^\.]+)\z/ =~ in_filepath
        @in_filepath = in_filepath
        @basename = File.basename(in_filepath, ".*")
        @in_format = $2
      else
        puts "The filename does not have a valid format"
        exit
      end
      
      if /([^\/]+)\.([^\.]+)\z/ =~ out_filepath
        @out_filepath = out_filepath
        @out_format = $2
        @outdir = File.dirname(out_filepath)        
      else
        puts "The filename does not have a valid format"
        exit
      end

      unless File.exists?(@outdir) && File::ftype(@outdir) == "directory"
        puts "The output directory does not exist"
        exit
      end
            
      if ["wav", "mp3"].index out_format
        @out_format = out_format
      else
        puts "The output format specified is not available"
        exit
      end
    end
    
    def execute(speed = 1, silence = 0)
      @silence = silence
      @speed = speed
      temp_wav_original = @outdir + "/" + @basename + "-temp-original.wav"
      temp_wav_result = @outdir + "/" + @basename + "-temp-result.wav"
      if @in_format != "wav" # @in_format == "mp3"
        convert_to_wav(@in_filepath, temp_wav_original)
      elsif @in_format == "wav"
        `cp #{@in_filepath} #{temp_wav_original}`        
      end
      split_wav(temp_wav_original)
      merge_wav(temp_wav_result)
      if @out_format == "mp3"
        convert_to_mp3(temp_wav_result, @out_filepath)
        `rm #{temp_wav_original} #{temp_wav_result}`
      elsif @out_format == "wav"
        `mv #{temp_wav_result} #{@out_filepath}; rm #{temp_wav_original}`   
      end
    end
    
    def split_wav(in_filepath)
      puts "Splitting WAV to segments"
      result = `/usr/local/bin/sox #{in_filepath} #{@outdir}/split-.wav silence 0 1 0.3 -32d : newfile : restart`
    end

    def merge_wav(out_filepath)
      temp_filepath = @outdir + "/temp.wav"
      files = []
      Dir.foreach(@outdir) do |file|
        next unless /^split\-\d+\.wav$/ =~ file
        files << @outdir + "/" + file      
      end
      index = 0
      puts "Merging segments back to one WAV file"
      bar = ProgressBar.new(@basename, files.size)        
      files.sort.each do |filepath|
        length = `/usr/local/bin/soxi -D #{filepath}`.to_f
        num_seconds = @silence == "auto" ? length.to_i + 1 : @silence.to_i
        index += 1      
        bar.inc(1)
        if index == 1
          File.rename(filepath, out_filepath)
          next
        end

        if length == 0 or @silence.to_f == 0
          `/usr/local/bin/sox #{out_filepath} #{filepath} #{temp_filepath} ; mv #{temp_filepath} #{out_filepath} ; rm #{filepath}`          
        else
          if @silence == "auto"
            silence_length =  length
          elsif @speed and @speed != 1
            silence_length = @silence.to_f / @speed * 1
          else 
            silence_length = @silence
          end
          `/usr/local/bin/sox #{out_filepath} -p pad 0 #{silence_length} | /usr/local/bin/sox - #{filepath} #{temp_filepath} ; mv #{temp_filepath} #{out_filepath} ; rm #{filepath}`
        end
      end
      print "\n"
      puts "Changing speed of the resulting WAV"
      if @speed and @speed.to_f != 1.0
        `/usr/local/bin/sox #{out_filepath} #{temp_filepath} tempo -s #{@speed}`
        `mv #{temp_filepath} #{out_filepath}`
      end      
    end

    def convert_to_wav(in_filepath, out_filepath)
      basename = File.basename(in_filepath  )
      puts "Converting to WAV: #{basename}"      
      `/usr/local/bin/sox #{in_filepath} #{out_filepath}`
    end
    
    def convert_to_mp3(in_filepath, out_filepath)
      basename = File.basename(out_filepath)
      puts "Converting WAV to MP3: #{basename}"
      `/usr/local/bin/sox #{in_filepath} #{out_filepath}`
    end    
  end
end
