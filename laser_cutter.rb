#TODO interface to select which instrument config to use
require_relative 'helpers/example_note_layout_data.rb'

NOTE_ORDER = []
8.times do |i|
  "A#{i} A##{i} B#{i} C#{i} C##{i} D#{i} D##{i} E#{i} F#{i} F##{i} G#{i} G#{i}".split(' ').each do |note|
    NOTE_ORDER.push(note)
  end
end

def generate_gcode(note_data)
  gcode = ""
  y_spacer_offset = 400

  require 'pry';binding.pry

  ordered_note_data.each do |note|

  end

  for x in 0..note_data[:end_time] do
    note_data.each_pair do |note, ranges|
      if ranges.kind_of?(Array)
        ranges.each do |range|
          if range.include?(x) && ORGAN_CONFIG[note]
            #TODO steps
            #speed to beginning of hole
            laser_on
            #side 1
            #side 2
            #side 3
            #side 4
            laser_off

          end
        end
      end
    end
  end

  File.write("midi_gcode.gcode", "%\n#{gcode}\n%") # output the program's gcode to stdout
end

def laser_on
  #TODO turn the laser on!
end

def laser_off
  #TODO turn the laser off!
end

def ordered_note_data note_data
  sortable_note_data = []
  note_data.each do |note,ranges|
    if ranges.class == Array
      ranges.map{|range| {note => range} }.each do |note_range|
        sortable_note_data.push note_range
      end
    end
  end

  sortable_note_data.sort_by{|note| [note.first[1].first, NOTE_ORDER.index(note.first[0])] }
end


