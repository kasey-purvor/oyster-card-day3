require 'journey'
class Oystercard
  attr_reader :balance, :limit, :entry_station, :exit_station, :journeys

  LIMIT = 90
  MINIMUM_FARE = 1

  def initialize
    @balance = 0
    @in_journey = false
    @entry_station = nil
    @exit_station = nil
    @journeys = []
  end

  def top_up(value)
    raise "top up limit of #{LIMIT} exceeded" if @balance + value > LIMIT
    @balance += value
  end
  
  def touch_in(entry_station)
    raise "balance too low" if @balance < MINIMUM_FARE
    @in_journey = true
    @entry_station = entry_station
  end

  def in_journey?
    return true if !@entry_station.nil? 
    return false if @entry_station.nil? 
  end

  def touch_out(exit_station)
    @in_journey = false
    deduct(MINIMUM_FARE)
    @exit_station = exit_station
    journey = {entry_station: entry_station, exit_station: exit_station} 
    journeys << journey
    @entry_station = nil
  end
  
  private
  def deduct(value)
    @balance -= value
  end

end
