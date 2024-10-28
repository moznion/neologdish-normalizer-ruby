# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/neologdish/normalizer'

module Neologdish
  module Normalizer
    class NormalizerTest < Minitest::Test
      def test_normalize
        assert_equal '0123456789', Neologdish::Normalizer.normalize('０１２３４５６７８９')
        assert_equal 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', Neologdish::Normalizer.normalize('ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ')
        assert_equal 'abcdefghijklmnopqrstuvwxyz', Neologdish::Normalizer.normalize('ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ')
        assert_equal "!\"\#$%&'()*+,-./:;<>?@[¥]^_`{|}",
                     Neologdish::Normalizer.normalize('！”＃＄％＆’（）＊＋，−．／：；＜＞？＠［￥］＾＿｀｛｜｝')
        assert_equal '＝。、・「」', Neologdish::Normalizer.normalize('＝。、・「」')
        assert_equal 'ハンカクダヨ', Neologdish::Normalizer.normalize('ﾊﾝｶｸﾀﾞﾖ')
        assert_equal 'o-o', Neologdish::Normalizer.normalize('o₋o')
        assert_equal 'majikaー', Neologdish::Normalizer.normalize('majika━')
        assert_equal 'わい', Neologdish::Normalizer.normalize('わ〰い')
        assert_equal 'スーパー', Neologdish::Normalizer.normalize('スーパーーーー')
        assert_equal '!#', Neologdish::Normalizer.normalize('!#')
        assert_equal 'ゼンカクスペース', Neologdish::Normalizer.normalize('ゼンカク　スペース')
        assert_equal 'おお', Neologdish::Normalizer.normalize('お             お')
        assert_equal 'おお', Neologdish::Normalizer.normalize('      おお')
        assert_equal 'おお', Neologdish::Normalizer.normalize('おお      ')
        assert_equal '検索エンジン自作入門を買いました!!!', Neologdish::Normalizer.normalize('検索 エンジン 自作 入門 を 買い ました!!!')
        assert_equal 'アルゴリズムC', Neologdish::Normalizer.normalize('アルゴリズム C')
        assert_equal 'PRML副読本', Neologdish::Normalizer.normalize('　　　ＰＲＭＬ　　副　読　本　　　')
        assert_equal 'Coding the Matrix', Neologdish::Normalizer.normalize('Coding the Matrix')
        assert_equal '南アルプスの天然水Sparking Lemonレモン一絞り',
                     Neologdish::Normalizer.normalize('南アルプスの　天然水　Ｓｐａｒｋｉｎｇ　Ｌｅｍｏｎ　レモン一絞り')
        assert_equal '南アルプスの天然水-Sparking*Lemon+レモン一絞り',
                     Neologdish::Normalizer.normalize('南アルプスの　天然水-　Ｓｐａｒｋｉｎｇ*　Ｌｅｍｏｎ+　レモン一絞り')
      end
    end
  end
end
