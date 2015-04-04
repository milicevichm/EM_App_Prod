class PowerForm < ActiveRecord::Base

  validate :date_range_correct?

  def date_range_correct?

    if tstart < DateTime.strptime('2011-04-18T09:22:00', '%Y-%m-%dT%H:%M:%S') or tstart > DateTime.strptime('2011-05-24T15:57:00', '%Y-%m-%dT%H:%M:%S')
      errors.add(:tstart, 'Please enter a start date within a valid range.')
    end

    if tend < DateTime.strptime('2011-04-18T09:22:00', '%Y-%m-%dT%H:%M:%S') or tend > DateTime.strptime('2011-05-24T15:57:00', '%Y-%m-%dT%H:%M:%S')
      errors.add(:tend, 'Please enter a end date within a valid range.')
    end

    if tstart > tend
      errors.add(:tstart, 'Please ensure that your start date comes before your end date.')
    end

  end

end
