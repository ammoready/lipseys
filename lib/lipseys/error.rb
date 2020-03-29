module Lipseys
  class Error < StandardError

    class NoContent < Lipseys::Error; end
    class NotAuthorized < Lipseys::Error; end
    class NotFound < Lipseys::Error; end
    class RequestError < Lipseys::Error; end
    class TimeoutError < Lipseys::Error; end

  end
end
