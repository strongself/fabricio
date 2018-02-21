module Helpers
  class CliExecutor
    def self.json_capture(stream)
      begin
        stream = stream.to_s
        eval "$#{stream} = StringIO.new"
        yield
        result = eval("$#{stream}").string
      ensure
        eval("$#{stream} = #{stream.upcase}")
      end
      JSON.parse(result)
    end

    def self.capture(stream)
      begin
        stream = stream.to_s
        eval "$#{stream} = StringIO.new"
        yield
        result = eval("$#{stream}").string
      ensure
        eval("$#{stream} = #{stream.upcase}")
      end
      result.chop
    end
  end
end
