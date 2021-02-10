require 'oystercard'

describe Oystercard do
  let(:station) {double :station}
  
  it 'has a balance of 0 by default' do
    expect(subject.balance).to eq(0)
  end
  it 'has a limit' do
    expect(Oystercard::LIMIT).to eq(90)
  end
  it 'has a minimum fare' do
    expect(Oystercard::MINIMUM_FARE).to eq(1)
  end

  describe '#top_up' do
    before do 
      subject.top_up(Oystercard::LIMIT)
    end
    it 'should take a top-up value and add it to the card balance' do
      expect(subject.balance).to eq(Oystercard::LIMIT)
    end
    it 'should raise an error if top_up returns more than 90' do
      expect { subject.top_up(Oystercard::MINIMUM_FARE) }.to raise_error("top up limit of #{Oystercard::LIMIT} exceeded")
    end
  end


  describe '#touch_in' do
    #before do 
      
    #end 
    it 'responds to a touch_in method' do
      expect(subject).to respond_to(:touch_in)
    end
    it 'changes in_journey status to true' do
      subject.top_up(Oystercard::LIMIT)
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end
    it 'should raise an error if the balance is less than the minimum fare' do
      expect { subject.touch_in(station) }.to raise_error("balance too low")  
    end
  end

  describe '#in_journey' do
    it 'responds to a in_journey method' do
      expect(subject).to respond_to(:in_journey?)
    end
  end

  describe '#touch_out' do
    before do 
      subject.top_up(Oystercard::LIMIT)
      subject.touch_in(station)
    end 
    it 'responds to a touch_out method' do
      expect(subject).to respond_to(:touch_out)
    end
    it 'changes in_journey status to false' do
      subject.touch_out
      expect(subject).not_to be_in_journey
    end
    it "deducts the fare from the balance of touch out" do
      expect { subject.touch_out }.to change{subject.balance}.by(-Oystercard::MINIMUM_FARE)
    end  
  end
  
  describe '#entry_station?' do 
    before do 
      subject.top_up(Oystercard::LIMIT)
    end
    it "remembers the entry station" do 
      subject.touch_in(station)
      expect(subject.entry_station).to eq(station)
    end 
  end
end
