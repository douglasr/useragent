class UserAgent
  module Browsers
    module All
      include Comparable

      CRAWLER_USER_AGENTS = [
        'AdsBot-Google', 'Baiduspider', 'Bloglines', 'Charlotte', 'DotBot', 'eCairn Grabber', 'FeedFetcher-Google',
        'Googlebot', 'Java VM', 'LinkWalker', 'LiteFinder', 'Mediapartners-Google', 'msnbot', 'msnbot-media',
        'QihooBot', 'Sogou head spider', 'Sogou web spider', 'Sosoimagespider', 'Sosospider', 'Speedy Spider',
        'Superdownloads Spiderman', 'WebAlta Crawler', 'Yahoo! Slurp', 'Yeti', 'YodaoBot', 'YoudaoBot'
      ].freeze


      def <=>(other)
        if respond_to?(:browser) && other.respond_to?(:browser) &&
            browser == other.browser
          version <=> other.version
        else
          false
        end
      end

      def eql?(other)
        self == other
      end

      def to_s
        to_str
      end

      def to_str
        join(" ")
      end

      def application
        first
      end

      def browser
        application.product
      end

      def version
        application.version
      end

      def platform
        nil
      end

      def os
        nil
      end

      def respond_to?(symbol)
        detect_product(symbol) ? true : super
      end

      def method_missing(method, *args, &block)
        detect_product(method) || super
      end

      def webkit?
        false
      end

      def mobile?
        if browser == 'webOS'
          true
        elsif platform == 'Symbian'
          true
        elsif detect_product('Mobile')
          true
        elsif application.comment &&
            application.comment.detect { |k, v| k =~ /^IEMobile/ }
          true
        else
          false
        end
      end

      def bot?
        # Match common case when bots refer to themselves as bots in
        # the application comment. There are no standards for how bots
        # should call themselves so its not an exhaustive method.
        #
        # If you want to expand the scope, override the method and
        # provide your own regexp. Any patches to future extend this
        # list will be rejected.
        if comment = application.comment
          comments = comment.join('; ') if (comment.respond_to?(:join))
          if (CRAWLER_USER_AGENTS.detect { |a| comments.index(a) })
            true
          else
            comment.any? { |c| c =~ /bot/i }
          end
        else
          false
        end
      end

      private
        def detect_product(product)
          detect { |useragent| useragent.product.to_s.downcase == product.to_s.downcase }
        end
    end
  end
end
