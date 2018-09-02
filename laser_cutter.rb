#TODO interface to select which instrument config to use
require_relative 'helpers/example_note_layout_data.rb'

NOTE_ORDER = []
8.times do |i|
  "A#{i} A##{i} B#{i} C#{i} C##{i} D#{i} D##{i} E#{i} F#{i} F##{i} G#{i} G##{i}".split(' ').each do |note|
    NOTE_ORDER.push(note)
  end
end

def generate_gcode(note_data)
  gcode = "G90\n"
  y_spacer_offset = 400
  tempo_multiplier = 10

  note_data = validate_note_data(note_data)

  note_data.each do |note|
    y_start = y_spacer_offset + (note.first[1].first / tempo_multiplier)
    y_end = y_spacer_offset + (note.first[1].last / tempo_multiplier)
    begin
    x_start = ORGAN_CONFIG[note.first[0]][:x]
    rescue => e
      require 'pry';binding.pry
      end
    x_end = x_start + ORGAN_CONFIG[note.first[0]][:w]

    gcode += "G0 Y#{y_start} X#{x_start}\n"
    laser_on
    gcode += "G1 Y#{y_start} X#{x_end}\n"
    gcode += "G1 Y#{y_end} X#{x_end}\n"
    gcode += "G1 Y#{y_end} X#{x_start}\n"
    gcode += "G1 Y#{y_start} X#{x_start}\n"
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

def validate_note_data note_data
  note_data = remove_out_of_range_notes(note_data)
  note_data = ordered_note_data(note_data)
  note_data = remove_duplicate_notes(note_data)
  note_data
end

def remove_out_of_range_notes note_data
  uniq_midi_notes = note_data.keys.uniq
  config_notes = ORGAN_CONFIG.keys
  out_of_range_notes = uniq_midi_notes - config_notes

  if out_of_range_notes.any?
    print "the following notes in the midi file are out of the range for this instrument and were removed:\n#{out_of_range_notes}\n"
  end

  out_of_range_notes.each { |note| note_data.delete(note) }
  note_data
end

def remove_duplicate_notes(note_data)
  note_data.uniq
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

  sortable_note_data.sort_by do |note|
      [note.first[1].first, NOTE_ORDER.index(note.first[0])]
  end
end


