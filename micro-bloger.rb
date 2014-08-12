require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts 'Starting Service'
    @client = JumpstartAuth.twitter
  end

  def run
    puts """
    Welcome to Adrian's Twitter Client
    Commands are added before your message with a space char after
    Valid Commands are: q -- Quit;
                        t -- tweet;
                        m -- message to friend(needs to have the friend name with a space after the command)
                        s -- Spamm your followers (need msg after command)
                        l -- List all your followers
"""
    command = ''
    while command != 'q'
      printf 'Enter Command: '
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
        when 'q' then puts "Goodbye!"
        when 't' then tweet(parts[1..-1].join(" "))
        when 'm' then dm(parts[1], parts[2..-1].join(' '))
        when 's' then spam_my_followers(parts[1..-1].join(' '))
        when 'l' then puts follower_list
        else
          puts "Sorry, I don't know how to #{command}"
      end
    end
  end

  def follower_list
    @client.followers.collect {|follower| follower.screen_name}
  end

  def spam_my_followers(spam)
    spam_list = follower_list
    spam_list.each { |target| dm(target, spam)}
  end

  def evryones_last_tweet
    friends= @client.friends
    friends.each do |friend|
      puts friend.name
      puts friend.screen_name
      puts friend.status.source
      puts ''
    end
  end

  def tweet(message)
    if message.length > 140
      puts "Sorry but your tweet can't be longer than 140 chars"
    else
      @client.update(message)
    end
  end

  def dm(target, message)
    puts "Trying to send #{target} this message: \n #{message}"
    screen_names = follower_list
    if screen_names.include?(target)
      message = "d @#{target} #{message}"
      tweet(message)
    else
      puts "you can only dm people that follow you"
    end

  end
end

blogger = MicroBlogger.new
blogger.run