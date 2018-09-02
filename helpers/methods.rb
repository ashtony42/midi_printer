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

def get_midi_note_coordinates sequence
  note_hash = {}
  sequence.tracks.each do |track|
    track.events.each do |event|
      if event.class == MIDI::NoteOn
        note_letter = MIDI::Utils.note_to_s(event.note)
        note_hash[note_letter] ||= []
        note_hash[note_letter].push((event.time_from_start)..(event.off.time_from_start))
      end
    end
  end
  return note_hash
end
