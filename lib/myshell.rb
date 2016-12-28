require 'benchmark'

class MyShell
  class Logged
    def self.run(*args)
      self.new(*args).call
    end

    attr_reader :cmd, :args

    def initialize(cmd, *args)
      @cmd = cmd
      @args = args
    end

    def to_s
      ([cmd] + args).join(' ')
    end

    def inspect
      to_s.inspect
    end

    def call
      LOG.debug "Running #{inspect}"
      Rake.sh cmd, *args
    end

    alias :sh :call
  end

  class Benchmarked < Logged
    def self.collected
      @collected ||= []
    end

    def self.show_collected
      collected.each do |sh|
        elapsed = Time.at(sh.benchmark.real).utc.strftime("%-Hhr %-Mmin %-Ssec")
        LOG.info "#{sh.benchmark.label} took #{elapsed}"
      end
    end

    #####

    attr_reader :benchmark
    def initialize(*args)
      super
    end

    def call
      @benchmark = Benchmark.measure(inspect) { super }
      self.class.collected << self

      @benchmark
    end
  end
end
