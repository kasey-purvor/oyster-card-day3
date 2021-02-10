require 'station' 

describe Station do 
  subject { described_class.new("old street", 1) } 
  it "shows the station name" do   
    expect(subject.name).to eq("old street") 
  end 
  
  it "shows the station zone" do 
    expect(subject.zone).to eq(1) 
  end 
     
      
end
  