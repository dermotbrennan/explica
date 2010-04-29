require 'lingua/en/readability'
require 'digest/md5'

class Document < ActiveRecord::Base
  before_validation :recreate_hash

  validates :checksum, :presence => true
  validates :original, :presence => true, :length => {:maximum => 1200, :minimum => 1}

  def complex_words
    @complex_words ||= self.original.
      split(/\W+/).
      map(&:downcase).
      uniq.
      reject {|w| STOP_WORDS.include?(w)}.
      reject {|w| w =~ /\d+/}
  end

  def complex_words_sorted_by_syllables
    @complex_words_sorted_by_syllables ||= complex_words.
      map {|w| [w, Lingua::EN::Syllable.syllables(w)] }.
      sort_by {|word, num_syllables| num_syllables }.
      reverse
  end


  private
  def recreate_hash
    self.checksum = Digest::MD5.hexdigest(self.original)
  end


end
