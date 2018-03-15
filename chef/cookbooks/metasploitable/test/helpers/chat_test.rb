require 'nokogiri'
require 'net/http'

class ChatTest

  attr_accessor :url

  BOTTESTERS = [ 'l0bsteryumyum1', 'bottyp0', 'popo0', 'pdiddy1', 'thatsinn3rguy', 'viper2000', 'the1jboss', '1337hackerizme' ]

  def check_chat_bot
    #print_status("Checking chat bot as #{bot_tester}...")
    rv = false
    begin
      php_sid = login_chat
    rescue Exception => e
      raise e.message
    end

    # Check to make sure the bot responds to greetings
    (1..5).each do |i|
      greeting = ['hi', 'hello', 'yo', 'hey', 'hola', 'sup', 'howdy', 'hiya'].sample
      res = message_bot(php_sid, greeting)

      if res.match(/aloha\!/)
        rv = true
        break
      else
        if i == 5
          rv = false
          break
        end
      end

      # Wait before we try to talk to the bot again
      sleep(2)
    end

    # Check to make sure the bot is outputting the correct Base64 encoded flag
    flag_file = File.open(File.join(File.expand_path(File.dirname(__FILE__)),'..','..','files','flags','ace_of_clubs_b64.txt'), 'r')
    b64_string = flag_file.readline()

    (1..3).each do |i|
      message = 'ace of clubs'
      res = message_bot(php_sid, message)
      if res.match(/#{b64_string}/)
        rv = true
        break
      else
        if i == 5
          rv = false
          break
        end
      end

      # Wait before we try to talk to the bot again
      sleep(2)
    end
    rv
  end

  def send_get_request(url, vars_get={})
    uri = URI(url)
    uri.query = URI.encode_www_form(vars_get)
    Net::HTTP.get_response(uri)
  end

  def send_post_request(url, cookie, vars_post={})
    uri = URI(url)
    req = Net::HTTP::Post.new(uri)
    req['Cookie'] = cookie
    req.set_form_data(vars_post)
    http = Net::HTTP.new(uri.host, uri.port)
    http.request(req)
  end

  def login_chat
    begin
      res = send_get_request(@url)
    rescue Exception => e
      raise e.message
    end

    if res && res.body !~ /<title>Metasploitable3 Chatroom/i
      raise 'Chatroom not found'
    end

    unless res.header['Set-Cookie']
      raise 'No Cookie found from the chat app'
    end

    php_sid = res.header['Set-Cookie'].scan(/PHPSESSID=(\w+)/).flatten.first || ''

    if php_sid.empty?
      raise 'No PHP session ID found from the chat app'
    end

    res = send_post_request("#{@url}index.php", "PHPSESSID=#{php_sid}", {'name'=>bot_tester, 'enter'=>'Enter'})

    unless res.header['Set-Cookie']
      raise 'Chatroom did not set name while logging in'
    end

    php_sid
  end

  def bot_tester
    @tester ||= BOTTESTERS.sample
  end

  def get_last_bot_response
    res = send_get_request("#{@url}/read_log.php")
    html = Nokogiri::HTML(res.body)
    res = html.search('div[@class="msgln"]').select { |e| e.children[1].text =~ /Papa Smurf/ }.reverse.first

    raise 'No response from bot' unless res
    raise 'No conversation yet' if res.previous.nil?
    previous_message_handle = res.previous.children[1].text

    if previous_message_handle == bot_tester
      msg = res.children[2].text.scan(/: (.+)/).flatten.first || ''
      #print_status("Chat bot replies with: \"#{msg}\"")
      return msg
    end

    raise 'Empty response from bot'
  end

  def message_bot(php_sid, message)

    #print_status("Greeting bot with \"#{greeting}\"")
    res = send_post_request("#{@url}post.php", "name=#{bot_tester}; PHPSESSID=#{php_sid}", {'text'=>message})

    attempts = 0
    res = ''
    begin
      res = get_last_bot_response
      return res
    rescue Exception => e
      if res.empty? && attempts < 5
        attempts += 1
        sleep(2)
        retry
      end
    end

    res
  end

  def initialize(ip)
    @url = "http://#{ip}/chat/"
  end
end
