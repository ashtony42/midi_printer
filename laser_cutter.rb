#TODO interface to select which instrument config to use
require_relative 'helpers/example_note_layout_data.rb'

NOTE_ORDER = []
8.times do |i|
  "A#{i} A##{i} B#{i} C#{i} C##{i} D#{i} D##{i} E#{i} F#{i} F##{i} G#{i} G#{i}".split(' ').each do |note|
    NOTE_ORDER.push(note)
  end
end

def generate_gcode(note_data)
  gcode = "G90\n"
  y_spacer_offset = 400
  tempo_multiplier = 100

  require 'pry';binding.pry
  ordered_note_data(note_data).each do |note|
    y_start = y_spacer_offset + (note.first.first[1].first / tempo_multiplier)
    y_end = y_spacer_offset + (note.first.first[1].last / tempo_multiplier)
    x_start = ORGAN_CONFIG[note.first.first[0]][:x]
    x_end = x_start + ORGAN_CONFIG[note.first.first[0]][:w]

    gcode += "G0 Y#{y_start} X#{x_start}\n"
    laser_on
    gcode += "G1 Y#{y_start} X#{x_end}\n"
    gcode += "G1 Y#{y_end} X#{x_end}\n"
    gcode += "G1 Y#{y_end} X#{x_start}\n"
    gcode += "G1 Y#{y_start} X#{x_start}"
    laser_off
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


