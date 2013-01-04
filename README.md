# SpeakSlow

## Description

SpeakSlow modifies audio files adding pauses and/or altering speed to suit for language study

## Installation

*SpeakSlow requires [SoX - Sound eXchange](http://sox.sourceforge.net/) with LAME support installed to the system.  Then `gem install`*

    $ gem install speak_slow 

## How to Use

    Usage: speak_slow [options] <input file> <output file>
    where: <input file> and <output file> are paths to a wav or mp3 file
    
    [options]:
        --speed, -s <f>:   Speed of output file [0.1 - 100] (default: 1.0)
      --silence, -i <i>:   Length (secondes) of a pause added to each utterance [0.1 - 120]
                           (default: 1)
          --version, -v:   Print version and exit
             --help, -h:   Show this message