def show_midi_info sequence
  print "the file has #{sequence.tracks.count} tracks\n"
  sequence.tracks.count.times do |track_index|
    sequence.tracks[track_index].events.each do |event|
      if event.respond_to? "program"
        print "track #{track_index} has instrument of #{GM_PATCH_NAMES[event.program]}\n"
      end
    end
  end
end

def get_midi_note_data sequence
  note_array = []
  sequence.tracks.each do |track|
    track.events.each do |event|
      if event.class == MIDI::NoteOn
        note_array[event.note] = [] if note_array[event.note].nil?
        note_array[event.note][0] = MIDI::Utils.note_to_s(event.note)
        event.delta_time.times do |milisecond|
          note_array[event.note][(event.time_from_start + milisecond + 1)/200] = 'x'
        end
      end
    end
  end
  return note_array
end

def print_note_array note_array
  song_length = note_array.map{|m| begin m.length rescue nil end}.compact.max
  song_length.times do |index|
    note_array.each do |note|
      if note.nil?
      elsif note[index].nil?
        print note[0].gsub(/./," ") + " "
      else
        print note[0] + " "
      end
    end
    print "\n"
  end
end

def get_midi_note_coordinates sequence
  note_hash = {:end_time => 0}
  sequence.tracks.each do |track|
    track.events.each do |event|
      if event.class == MIDI::NoteOn
        note_letter = MIDI::Utils.note_to_s(event.note)
        note_hash[note_letter] ||= []
        note_hash[note_letter].push((event.time_from_start)..(event.off.time_from_start))
        note_hash[:end_time] = event.off.time_from_start if event.off.time_from_start > note_hash[:end_time]
      end
    end
  end
  return note_hash
end
