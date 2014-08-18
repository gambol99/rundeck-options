#
#   Author: Rohith
#   Date: 2014-08-16 15:34:46 +0100 (Sat, 16 Aug 2014)
#
#  vim:ts=4:sw=4:et
#
require 'fog'

module RundeckOptions
  module Plugins
    class Plugin
      def unsupported
        %w(unsupported)
      end
    end
  end
end
