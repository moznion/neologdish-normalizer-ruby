# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../lib/neologd/normalizer"

module Neologd
  module Normalizer
    class NormalizerTest < Minitest::Test
      def test_normalize
        assert_equal "0123456789", Neologd::Normalizer.normalize("０１２３４５６７８９")
        assert_equal "ABCDEFGHIJKLMNOPQRSTUVWXYZ", Neologd::Normalizer.normalize("ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ")
        assert_equal "abcdefghijklmnopqrstuvwxyz", Neologd::Normalizer.normalize("ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ")
        assert_equal "!\"\#$%&'()*+,-./:;<>?@[¥]^_`{|}", Neologd::Normalizer.normalize("！”＃＄％＆’（）＊＋，−．／：；＜＞？＠［￥］＾＿｀｛｜｝")
        assert_equal "＝。、・「」", Neologd::Normalizer.normalize("＝。、・「」")
        assert_equal "ハンカク", Neologd::Normalizer.normalize("ﾊﾝｶｸ")
        assert_equal "o-o", Neologd::Normalizer.normalize("o₋o")
        assert_equal "majikaー", Neologd::Normalizer.normalize("majika━")
        assert_equal "わい", Neologd::Normalizer.normalize("わ〰い")
        assert_equal "スーパー", Neologd::Normalizer.normalize("スーパーーーー")
        assert_equal "!#", Neologd::Normalizer.normalize("!#")
        assert_equal "ゼンカクスペース", Neologd::Normalizer.normalize("ゼンカク　スペース")
        assert_equal "おお", Neologd::Normalizer.normalize("お             お")
        assert_equal "おお", Neologd::Normalizer.normalize("      おお")
        assert_equal "おお", Neologd::Normalizer.normalize("おお      ")
        assert_equal "検索エンジン自作入門を買いました!!!", Neologd::Normalizer.normalize("検索 エンジン 自作 入門 を 買い ました!!!")
        assert_equal "アルゴリズムC", Neologd::Normalizer.normalize("アルゴリズム C")
        assert_equal "PRML副読本", Neologd::Normalizer.normalize("　　　ＰＲＭＬ　　副　読　本　　　")
        assert_equal "Coding the Matrix", Neologd::Normalizer.normalize("Coding the Matrix")
        assert_equal "南アルプスの天然水Sparking Lemonレモン一絞り", Neologd::Normalizer.normalize("南アルプスの　天然水　Ｓｐａｒｋｉｎｇ　Ｌｅｍｏｎ　レモン一絞り")
        assert_equal "南アルプスの天然水-Sparking*Lemon+レモン一絞り", Neologd::Normalizer.normalize("南アルプスの　天然水-　Ｓｐａｒｋｉｎｇ*　Ｌｅｍｏｎ+　レモン一絞り")
      end
    end
  end
end
