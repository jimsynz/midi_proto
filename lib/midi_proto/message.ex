defprotocol MidiProto.Message do
  @moduledoc """
  A handy protocol for working with MIDI messages.
  """

  @doc """
  Encode the message into a binary for sending.
  """
  @spec encode(t) :: binary
  def encode(message)

  @doc """
  Is the message a channel pressure message?
  """
  @spec channel_pressure?(t) :: boolean
  def channel_pressure?(message)

  @doc """
  Is the message a control change message?
  """
  @spec control_change?(t) :: boolean
  def control_change?(message)

  @doc """
  Is the message a note-off message?
  """
  @spec note_off?(t) :: boolean
  def note_off?(message)

  @doc """
  Is the message a note-on message?
  """
  @spec note_on?(t) :: boolean
  def note_on?(message)

  @doc """
  Is the message a pitch bend message?
  """
  @spec pitch_bend?(t) :: boolean
  def pitch_bend?(message)

  @doc """
  Is the message a polyphonic pressure message?
  """
  @spec polyphonic_pressure?(t) :: boolean
  def polyphonic_pressure?(message)

  @doc """
  Is the message a program change message?
  """
  @spec program_change?(t) :: boolean
  def program_change?(message)

  @doc """
  Is the message a system message?
  """
  @spec system?(t) :: boolean
  def system?(message)

  @doc """
  Is the message a realtime message?
  """
  @spec realtime?(t) :: boolean
  def realtime?(message)

  @doc """
  Is the message a system reset message?
  """
  @spec system_reset?(t) :: boolean
  def system_reset?(message)

  @doc """
  Is the message a timing clock message?
  """
  @spec timing_clock?(t) :: boolean
  def timing_clock?(message)

  @doc """
  Is the message a start message?
  """
  @spec start?(t) :: boolean
  def start?(message)

  @doc """
  Is the message a continue message?
  """
  @spec continue?(t) :: boolean
  def continue?(message)

  @doc """
  Is the message a stop message?
  """
  @spec stop?(t) :: boolean
  def stop?(message)

  @doc """
  Is the message a active sense message?
  """
  @spec active_sense?(t) :: boolean
  def active_sense?(message)

  @doc """
  Is the message a time code quarter frame message?
  """
  @spec time_code_quarter_frame?(t) :: boolean
  def time_code_quarter_frame?(message)

  @doc """
  Is the message a song position message?
  """
  @spec song_position?(t) :: boolean
  def song_position?(message)

  @doc """
  Is the message a song select message?
  """
  @spec song_select?(t) :: boolean
  def song_select?(message)

  @doc """
  Is the message a tune request message?
  """
  @spec tune_request?(t) :: boolean
  def tune_request?(message)
end
