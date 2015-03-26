#! $MY_RUBY_HOME/bin/ruby
require 'open-uri'
require 'json'

API_URL = "http://cricscore-api.appspot.com/csa"
USAGE = "[Get all the cricket scores from your commandline]
         -h             displays this information
         -m             get all ongoing matches
         -s <match_no>  get score for a match
         -d <match_no>  keep score on screen"

class Match
  attr_accessor :team1, :team2, :id

  def initialize(t1,t2,id)
    @team1, @team2, @id = t1, t2, id
  end

  def display(index)
    puts "Match [#{index}] =>  #{team1} vs #{team2}"
  end

  def get_score
    JSON.parse(open("#{API_URL}?id=#{@id}").read)[0]["de"]
  end
end

def get_matches
  matches = []
  JSON.parse(open(API_URL).read).each do |match|
    matches << Match.new(match["t1"], match["t2"], match["id"])
  end
  matches
end

def display_matches(matches)
  matches.each {|match| match.display matches.index(match)}
end

def cli
  if ARGV.count == 0
    puts USAGE
    exit
  end

  matches = get_matches
  case ARGV[0]
    when "-m"
      #puts matches
      display_matches matches
    when "-s"
      if ARGV[1].nil?
        usage
        exit
      end
      puts matches[ARGV[1].to_i].get_score
    when "-d"
      if ARGV[1].nil?
        usage
        exit
      end
      while 
        system("clear")
        puts matches[ARGV[1].to_i].get_score
        
        sleep(20)
      end  
  end
rescue OpenURI::HTTPError
  puts "Looks like our provider API is down. :("
end

def usage
  puts USAGE
end

cli
