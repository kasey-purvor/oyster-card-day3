require_relative '../lib/oystercard'
require 'station'

describe Oystercard do
  let(:entry_station) {double :station}
  let(:exit_station) {double :station}
  
  context "when initialized" do 
    it 'has a limit' do
      expect(Oystercard::LIMIT).to eq(90)
    end
    it 'has a minimum fare' do
      expect(Oystercard::MINIMUM_FARE).to eq(Oystercard::MINIMUM_FARE)
    end
    it 'has a balance of 0 by default' do
      expect(subject.balance).to eq(0)
    end
    it 'has a empty list of journey' do
      expect(subject.journeys).to be_empty
    end
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
    it 'should raise an error if the balance is less than the minimum fare' do
      expect { subject.touch_in(entry_station) }.to raise_error("balance too low")  
    end
    it "changes in_journey status to true" do 
      subject.top_up(Oystercard::LIMIT)
      subject.touch_in(entry_station)
      expect(subject).to be_in_journey
    end
  end

  describe '#touch_out' do
    before do 
      subject.top_up(Oystercard::LIMIT)
      subject.touch_in(entry_station)
    end 
    it 'changes in_journey status to false' do
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end
    it "deducts the fare from the balance of touch out" do
      expect { subject.touch_out(exit_station) }.to change{subject.balance}.by(-Oystercard::MINIMUM_FARE)
    end  
    it 'stores exit station' do
      subject.touch_out(exit_station)
      expect(subject.exit_station).to eq exit_station
    end
     let(:journey) { {entry_station: entry_station, exit_station: exit_station} }
     it 'stores a journey in journeys' do 
      subject.touch_out(exit_station)
      expect(subject.journeys).to include journey      
     end
  end
  
  describe '#entry_station?' do 
    before do 
      subject.top_up(Oystercard::LIMIT)
    end
    it "remembers the entry station" do 
      subject.touch_in(entry_station)
      expect(subject.entry_station).to eq(entry_station)
    end 
  end
    
end
