class Flagsmith::Flag::FlagList
  include JSON::Serializable
  include Enumerable(::Flagsmith::Flag)

  getter flags : Array(::Flagsmith::Flag)

  def each(&block)
    flags.each do |i|
      yield i
    end
  end
end
