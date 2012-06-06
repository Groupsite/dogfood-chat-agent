require "pivotal_activity"

describe PivotalActivity do
  context "from the docs" do
    subject do
      PivotalActivity.from_xml <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
        <activity>
          <id type="integer">1031</id>
          <version type="integer">175</version>
          <event_type>story_update</event_type>
          <occurred_at type="datetime">2009/12/14 14:12:09 PST</occurred_at>
          <author>James Kirk</author>
          <project_id type="integer">26</project_id>
          <description>James Kirk accepted &quot;More power to shields&quot;</description>
          <stories>
            <story>
              <id type="integer">109</id>
              <url>https:///projects/26/stories/109</url>
              <accepted_at type="datetime">2009/12/14 22:12:09 UTC</accepted_at>
              <current_state>accepted</current_state>
            </story>
          </stories>
        </activity>
      XML
    end

    specify { subject.id.should == 1031 }
    specify { subject.version.should == 175 }
    specify { subject.event_type.should == "story_update" }
    specify { subject.occurred_at.should == DateTime.new(2009, 12, 14, 22, 12, 9) }
    specify { subject.author.should == "James Kirk" }
    specify { subject.project_id.should == 26 }
    specify { subject.description.should == "James Kirk accepted More power to shields" }
    specify { subject.should have(1).story }
    specify { subject.stories.first.id.should == 109 }
    specify { subject.stories.first.url.should == "https:///projects/26/stories/109" }
    specify { subject.stories.first.accepted_at.should ==  DateTime.new(2009, 12, 14, 22, 12, 9)}
    specify { subject.stories.first.current_state.should == "accepted" }
  end
end
