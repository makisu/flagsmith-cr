class Flagsmith::Flag::FlagList::Trait
  include JSON::Serializable
  include Enumerable(::Flagsmith::Flag)

  getter flags : Array(::Flagsmith::Flag)
  getter traits : Array(::Flagsmith::Trait)

  def each(&block)
    flags.each do |i|
      yield i
    end
  end
end
