require 'benchmark'

require 'moji'
require_relative '../lib/neologd/normalizer'

# original implementation came from https://github.com/neologd/mecab-ipadic-neologd/wiki/Regexp.ja
def original_normalize_neologd(norm)
  norm.tr!("０-９Ａ-Ｚａ-ｚ", "0-9A-Za-z")
  norm = Moji.han_to_zen(norm, Moji::HAN_KATA)
  hypon_reg = /(?:˗|֊|‐|‑|‒|–|⁃|⁻|₋|−)/
  norm.gsub!(hypon_reg, "-")
  choon_reg = /(?:﹣|－|ｰ|—|―|─|━)/
  norm.gsub!(choon_reg, "ー")
  chil_reg = /(?:~|∼|∾|〜|〰|～)/
  norm.gsub!(chil_reg, '')
  norm.gsub!(/[ー]+/, "ー")
  norm.tr!(%q{!"#$%&'()*+,-.\/:;<=>?@[¥]^_`{|}~｡､･｢｣"}, %q{！”＃＄％＆’（）＊＋，－．／：；＜＝＞？＠［￥］＾＿｀｛｜｝〜。、・「」})
  norm.gsub!(/　/, " ")
  norm.gsub!(/ {1,}/, " ")
  norm.gsub!(/^[ ]+(.+?)$/, "\\1")
  norm.gsub!(/^(.+?)[ ]+$/, "\\1")
  while norm =~ %r{([\p{InCjkUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)[ ]{1}([\p{InCjkUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)}
    norm.gsub!( %r{([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)}, "\\1\\2")
  end
  while norm =~ %r{([\p{InBasicLatin}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)}
    norm.gsub!(%r{([\p{InBasicLatin}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)}, "\\1\\2")
  end
  while norm =~ %r{([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InBasicLatin}]+)}
    norm.gsub!(%r{([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InBasicLatin}]+)}, "\\1\\2")
  end
  norm.tr!(
    %q{！”＃＄％＆’（）＊＋，－．／：；＜＞？＠［￥］＾＿｀｛｜｝〜},
    %q{!"#$%&'()*+,-.\/:;<>?@[¥]^_`{|}~}
  )
  norm
end

targets = ["０１２３４５６７８９",
 "ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ",
 "ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ",
 "！”＃＄％＆’（）＊＋，−．／：；＜＞？＠［￥］＾＿｀｛｜｝",
 "＝。、・「」",
 "ﾊﾝｶｸﾀﾞﾖ",
 "o₋o",
 "majika━",
 "わ〰い",
 "スーパーーーー",
 "!#",
 "ゼンカク　スペース",
 "お             お",
 "      おお",
 "おお      ",
 "検索 エンジン 自作 入門 を 買い ました!!!",
 "アルゴリズム C",
 "　　　ＰＲＭＬ　　副　読　本　　　",
 "Coding the Matrix",
 "南アルプスの　天然水　Ｓｐａｒｋｉｎｇ　Ｌｅｍｏｎ　レモン一絞り",
 "南アルプスの　天然水-　Ｓｐａｒｋｉｎｇ*　Ｌｅｍｏｎ+　レモン一絞り",]

n = 10000
Benchmark.bm(20) do |x|
  x.report("original normalizer:") do
    n.times do
      targets.each do |target|
        original_normalize_neologd(target)
      end
    end
  end

  x.report("this library:") do
    n.times do
      targets.each do |target|
        Neologd::Normalizer.normalize(target)
      end
    end
  end
end
