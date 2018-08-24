require_relative 'helpers/env'
#require_relative 'hole_puncher'
require_relative 'laser_cutter'

file = STILL_ALIVE

original_seq = Sequence.new()
new_seq = Sequence.new()

File.open("#{Dir.pwd}/midi_files/#{file}", 'rb') do |file|
  original_seq.read(file)
end

show_midi_info(original_seq)


#midi_note_data = get_midi_note_data(original_seq)
midi_note_data = get_midi_note_coordinates(original_seq)
generate_gcode(midi_note_data)
#print_note_array(midi_note_data)


print "Which tracks do you want? "
chosen_tracks = gets.split(" ")
if chosen_tracks == []
  new_seq = original_seq.dup
else
  new_seq = original_seq.dup
  new_seq.tracks = []
  chosen_tracks.each do |track_to_keep|
    new_seq.tracks << original_seq.tracks[track_to_keep.to_i]
  end
end

new_seq.tracks.count.times do |track_index|
  new_seq.tracks[track_index].count.times do |event_index|
    if new_seq.tracks[track_index].events[event_index].respond_to? "program="
      new_seq.tracks[track_index].events[event_index].program = 75  # 75 = pan flute
    end
  end
end



File.open('coverted.mid', 'wb') { |file| new_seq.write(file) }

#seq = Sequence.new()


# Create a first track for the sequence. This holds tempo events and stuff
# like that.
#track = Track.new(seq)
#seq.tracks << track
#track.events << Tempo.new(Tempo.bpm_to_mpq(120))
#track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')

# Create a track to hold the notes. Add it to the sequence.
#track = Track.new(seq)
#seq.tracks << track

# Give the track a name and an instrument name (optional).
#track.name = 'My New Track'
#track.instrument = GM_PATCH_NAMES[0]
#puts "pan flute is " + GM_PATCH_NAMES.find_index('Pan Flute').to_s


# Add a volume controller event (optional).
#seq.tracks[0].events << Controller.new(0, CC_VOLUME, 127)

# Add events to the track: a major scale. Arguments for note on and note off
# constructors are channel, note, velocity, and delta_time. Channel numbers
# start at zero. We use the new Sequence#note_to_delta method to get the
# delta time length of a single quarter note.
#original_seq.tracks[1].events << ProgramChange.new(0, 75, 0)

#seq.tracks[0].events << original_seq.tracks[2].events
#original_seq.tracks[1].recalc_times
#quarter_note_length = seq.note_to_delta('quarter')
#[0, 2, 4, 5, 7, 9, 11, 12].each do |offset|
#  track.events << NoteOn.new(0, 64 + offset, 127, 0)
#  track.events << NoteOff.new(0, 64 + offset, 127, quarter_note_length)
#end

# Calling recalc_times is not necessary, because that only sets the events'
# start times, which are not written out to the MIDI file. The delta times are
# what get written out.

# track.recalc_times



