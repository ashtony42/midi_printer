require 'gcodify'

def generate_gcode(note_data)
  program = Gcodify.program do

    for x in 0..note_data[:end_time] do
      note_data.each_pair do |note, ranges|
        if ranges.kind_of?(Array)
          ranges.each do |range|
            if range.include?(x) && ORGAN_CONFIG[note]
              hole :at => [x, ORGAN_CONFIG[note]], :depth => -5, :r_position => 0
            end
          end
        end
      end
    end

  end
  File.write("midi_gcode.gcode" , "%\n#{program.to_gcode}\n%") # output the program's gcode to stdout
end


ORGAN_CONFIG =
    {
        'A1' => 20,
        'A#1' => 22,
        'B1' => 25,
        'C1' => 30,
        'C#1' => 32,
        'D1' => 35,
        'D#1' => 37,
        'E1' => 40,
        'F1' => 45,
        'F#1' => 47,
        'G1' => 50,
        'G#1' => 52,

        'A2' => 55,
        'A#2' => 57,
        'B2' => 60,
        'C2' => 65,
        'C#2' => 67,
        'D2' => 70,
        'D#2' => 72,
        'E2' => 75,
        'F2' => 80,
        'F#2' => 82,
        'G2' => 85,
        'G#2' => 87,


        'B3' => 95,
        'C3' => 100,
        'C#3' => 102,
        'D3' => 105,
        'D#3' => 107,
        'E3' => 110,
        'F3' => 115,
        'F#3' => 117,
        'G3' => 120,
        'G#3' => 122,
        'A3' => 123,
        'A#3' => 124,


        'B4' => 130,
        'C4' => 135,
        'C#4' => 137,
        'D4' => 140,
        'D#4' => 142,
        'E4' => 145,
        'F4' => 150,
        'F#4' => 152,
        'G4' => 155,
        'G#4' => 157,
        'A4' => 158,
        'A#4' => 159,


        'B5' => 165,
        'C5' => 170,
        'C#5' => 172,
        'D5' => 175,
        'D#5' => 177,
        'E5' => 180,
        'F5' => 185,
        'F#5' => 187,
        'G5' => 190,
        'G#5' => 192,
        'A5' => 193,
        'A#5' => 194,

        'A6' => 195,
        'A#6' => 197,
        'B6' => 200,
        'C6' => 205,
        'C#6' => 207,
        'D6' => 210,
        'D#6' => 212,
        'E6' => 215,
        'F6' => 220,
        'F#6' => 222,
        'G6' => 225,
        'G#6' => 227,
    }
