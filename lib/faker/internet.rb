# encoding: utf-8
module Faker
  class Internet < Base
    class << self
      def email(name = nil)
        [ user_name(name), domain_name ].join('@')
      end
      
      def free_email(name = nil)
        [ user_name(name), fetch('internet.free_email') ].join('@')
      end
      
      def safe_email(name = nil)
        [user_name(name), 'example.'+ %w[org com net].shuffle(random: Faker::Config.prng).first].join('@')
      end
      
      def user_name(name = nil)
        return name.scan(/\w+/).shuffle(random: Faker::Config.prng).join(%w(. _).sample(random: Faker::Config.prng)).downcase if name
        
        fix_umlauts([ 
          Proc.new { Name.first_name.gsub(/\W/, '').downcase },
          Proc.new { 
            [ Name.first_name, Name.last_name ].map {|n| 
              n.gsub(/\W/, '')
            }.join(%w(. _).sample(random: Faker::Config.prng)).downcase }
        ].sample(random: Faker::Config.prng).call)
      end
      
      def domain_name
        [ fix_umlauts(domain_word), domain_suffix ].join('.')
      end
      
      def fix_umlauts(string)
        string.gsub(/[äöüß]/i) do |match|
            case match.downcase
                when "ä" 'ae'
                when "ö" 'oe'
                when "ü" 'ue'
                when "ß" 'ss'
            end
        end
      end
      
      def domain_word
        Company.name.split(' ').first.gsub(/\W/, '').downcase
      end
      
      def domain_suffix
        fetch('internet.domain_suffix')
      end
      
      def ip_v4_address
        ary = (2..254).to_a
        [ary.sample(random: Faker::Config.prng),
        ary.sample(random: Faker::Config.prng),
        ary.sample(random: Faker::Config.prng),
        ary.sample(random: Faker::Config.prng)].join('.')
      end

      def ip_v6_address
        @@ip_v6_space ||= (0..65535).to_a
        container = (1..8).map{ |_| @@ip_v6_space.sample(random: Faker::Config.prng) }
        container.map{ |n| n.to_s(16) }.join(':')
      end
      
      def url
        "http://#{domain_name}/#{user_name}"
      end

      def slug(words = nil, glue = nil)
        glue ||= %w[- _ .].sample(random: Faker::Config.prng)
        (words || Faker::Lorem::words(2).join(' ')).gsub(' ', glue).downcase
      end
    end
  end
end
