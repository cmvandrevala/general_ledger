require_relative './model'

class SnapshotAccess

  def self.all
    Snapshot.all
  end

  def self.create(params)
    Snapshot.create(params)
  end

  def self.first
    Snapshot.first
  end

end
