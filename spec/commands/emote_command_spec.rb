require "spec/spec_helper"

describe EmoteCommand do
  context "When parsing input a valid input" do
    it "should create a new emote command" do
      cmd = EmoteCommand.parse("emote licks her finger")

      cmd.class.should == EmoteCommand
      cmd.args.should == ["licks her finger"]
    end

    it "should ignore case of command" do
      cmd = EmoteCommand.parse("EMOTE licks her finger")

      cmd.class.should == EmoteCommand
      cmd.args.should == ["licks her finger"]
    end
  end

  context "When executing a command" do
    before :each do
      @character = Build.a_character
      @message = "licks her finger"
      @cmd = EmoteCommand.new(@message)
      @event_handler = mock.as_null_object
    end

    it "should add an emote event to the room" do
      @event_handler.should_receive(:add_event).
          with(Event.new(@character, @character.current_location, :emote, :message => @message))

      @cmd.execute_as(@character, @event_handler)
    end

    it "should notify character of his emote" do
      @character.should_receive(:notification).with("You emote: #{@character.name} #{@message}")
      
      @cmd.execute_as(@character, @event_handler)
    end
  end
end