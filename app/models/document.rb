require 'lingua/en/readability'
require 'digest/md5'
require 'url_grabbing'

class Document < ActiveRecord::Base
  include UrlGrabbing
  before_validation :check_for_just_a_url, :recreate_hash

  validates :checksum, :presence => true
  validates :original, :presence => true#, :length => {:maximum => 1200, :minimum => 1}

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

  scope :public, where(:is_public => true).order('created_at desc')

  def to_param
    checksum
  end

  private
  def recreate_hash
    self.checksum = Digest::MD5.hexdigest(self.original)
  end

  def check_for_just_a_url
    url = self.original.downcase.strip
    url_regex = /^((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
    if url =~ url_regex
      begin
        if (contents = grab_url_contents(url)).present?
          self.original = contents
        else
          self.errors.add_to_base('Nothing found in url!')
        end
      rescue SocketError, Errno::ECONNREFUSED
        self.errors.add_to_base('Nothing found in url!')
      end
    end
  end


end
