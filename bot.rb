require 'mumble-ruby'
require './commander'

class Bot

  include Commander

  def initialize(opts={})
    host = opts.fetch(:host){ 'localhost' }
    port = opts.fetch(:port){ 64738 }
    username = opts.fetch(:username){ 'MumbleBot' }
    password = opts.fetch(:password) { '' }
    @cli = Mumble::Client.new(host, port, username, password)
    me = self
    @cli.on_text_message do |msg|
      me.send(:handle_txt_msg, msg)
    end
  end

  def self.start!(opts={})
    new(opts).connect
    $0 = 'MumbleBot'
    sleep
  end

  # Delegate all calls this class does not handle to
  # the cli instance
  def method_missing(method, *args, &block)
    @cli.send(method, *args, &block)
  end

  private

  def handle_txt_msg(msg)
    msg = Message.new(msg[:message])
    if msg.is_command? && commands[msg.command]
      run_command(msg.command, msg.command_args) 
    end
  end

  class Message
    
    def initialize(str)
      @str = str
    end

    def is_command?
      @str =~ /^!/
    end

    def command
      @str.split.first.gsub('!','')
    end

    def command_args
      words = @str.split
      words.shift
      words.join(' ')
    end

  end
  
end
