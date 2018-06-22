module Exceptions
  class Error < StandardError; end
  class PasswordNotFound < Error; end
  class EmailDoesntExist < Error; end
end
