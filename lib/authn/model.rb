module AuthN
  module Model
    def self.included(object)
      object.extend ClassMethods
    end

    module ClassMethods
      def has_authentication(o = {})
        options = AuthN.config.table.any? ? o.merge!(AuthN.config) : o
        config.merge! options
      end

      def config=(options)
        @@config = options
      end

      def config
        @@config ||= AuthN::Config.new
      end

      def authenticate(identifiers = {})
        # Extract the password from the identifiers
        password = identifiers.delete :password

        # Find the documents that match the criteria
        criteria = where identifiers

        # Get the first document that matches the criteria
        instance = criteria.first

        # Check to see if the instance exists and if a password was given
        if instance && password
          # Check to see if the instance can authenticate with password
          if instance.authenticate password
            instance
          else
            false
          end
        end

        # Return instance if account was found and password matched
        # Return false if account was found and password didn't match
        # Return nil if account wasn't found OR password wasn't given
      end
    end
  end
end
