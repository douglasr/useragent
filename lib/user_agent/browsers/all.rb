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
        elsif detect_product('Mobile')
          true
        elsif application.comment.detect { |k, v| k =~ /^IEMobile/ }
          true
        else
          false
        end
      end

      def crawler?
        comments = application.comment
        comments = comments.join('; ') if (comments.respond_to?(:join))
        if (CRAWLER_USER_AGENTS.detect { |a| comments.index(a) })
          true
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
