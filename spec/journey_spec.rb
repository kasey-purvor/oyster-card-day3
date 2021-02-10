require 'journey'

describe Journey do 
  let(:station) { double :station, zone: 1}

  it 'knows when it not complete' do 
    expect(subject).not_to be_complete
  end

  it 'has a penalty fare by default' do 
    expect(subject.fare).to eq JOURNEY::PENALTY_FARE
  end

  it 'returns itself when journey is finished' do
    expect(subject.finish(station)).to eg(subject)
  end

  

  it 'calculates the fare' do 
    expect(subject.fare).to eq(OYSTERCARD::MINIMUM_FARE)
  end 

  # it 'knows if a journey is complete' do 
  #   expect(subject).to be complete
  # end
end