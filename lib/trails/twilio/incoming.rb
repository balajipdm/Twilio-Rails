module Trails
  module Twilio
    class Incoming
      attr_reader :account
      def initialize( request, opts = {} )
        @request = request
        @account = Trails::Twilio::Account.from_request( request )
      end

      def twilio_data
        request.params.slice( *INCOMING_VARS ).dup
      end

      def is_sms?
        !sms_message_sid.blank?
      end

      protected
      attr_reader :request

      INCOMING_VARS = [
                       # Always available:
        # Always available:
        'CallSid',	# A unique identifier for this call, generated by Twilio.
        'AccountSid',	# Your Twilio account id. It is 34 characters long, and always starts with the letters AC.
        'From',	# The phone number of the party that initiated the call. Formatted with a '+' and country code e.g., +16175551212 (E.164 format). If the call is inbound, then it is the caller's caller ID. If the call is outbound, i.e., initiated via a request to the REST API, then this is the phone number you specify as the caller ID.
        'To',	# The phone number of the called party. Formatted with a '+' and country code e.g., +16175551212 (E.164 format). If the call is inbound, then it's your Twilio phone number. If the call is outbound, then it's the phone number you provided to call.
        'CallStatus',	# A descriptive status for the call. The value is one of queued, ringing, in-progress, completed, busy, failed or no-answer. See the CallStatus section below for more details.
        'ApiVersion',	# The version of the Twilio API used to handle this call. For incoming calls, this is determined by the API version set on the called number. For outgoing calls, this is the API version used by the outgoing call's REST API request.
        'Direction',	# Indicates the direction of the call. In most cases this will be inbound, but if you are using <Dial> it will be outbound-dial.
        'ForwardedFrom',	# This parameter is set only when Twilio receives a forwarded call, but its value depends on the caller's carrier including information when forwarding. Not all carriers support passing this information.
        'FromCity',	# The city of the caller.
        'FromState',	# The state or province of the caller.
        'FromZip',	# The postal code of the caller.
        'FromCountry',	# The country of the caller.
        'ToCity',	# The city of the called party.
        'ToState',	# The state or province of the called party.
        'ToZip',	# The postal code of the called party.
        'ToCountry',	# The country of the called party.

        # Gather:
        'Digits',         # The digits received from the caller

        'RecordingUrl',   # The URL of the recorded audio file
        'Duration', 	# The time duration of the recorded audio file
        'Digits',         # What (if any) key was pressed to end the recording

        # SMS:
        'SmsMessageSid',  # Message SID
        'AccountSid',     # Account ID
        'From',           # 
        'To',             #
        'Body',           # 160 chars

      ].freeze
      public
      INCOMING_VARS.uniq.each do |pname|
        mname = pname.gsub( /[A-Z]/ ) { |s| "_#{s.downcase}" }.gsub( /^_/, '' )
        # some extra debugging code here:
        # ActionController::Base.logger.debug{ "defining method: #{mname} for param #{pname}" }
        define_method( mname ) do
          return request.params[ pname ] || request.env["HTTP_X_TWILIO_#{pname.upcase}"]
        end # define_method
      end # each 

    end #
  end # module Twilio
end # module Trails
