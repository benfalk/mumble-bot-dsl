module Commander
  
  def self.included(klass)
    klass.send(:extend, Commander::ClassMethods)
  end
  
  module ClassMethods
    def with_command(cmd,&block)
      @commands ||= {}
      @commands[cmd]= block
    end

    def commands
      @commands
    end
  end
  
  def commands
    self.class.commands
  end

  def has_command?(cmd)
    commands[cmd].present?
  end

  def run_command(cmd,*args)
    self.instance_exec(*args, &commands[cmd])
  end

end
