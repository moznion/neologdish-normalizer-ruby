# frozen_string_literal: true

require_relative "normalizer/version"
require "moji"

module Neologd
  module Normalizer
    # @rbs str: String
    # @rbs return: String
    def normalize(str)
      str = str.dup

      # 全角英数字を半角に変換
      str.tr!("０-９Ａ-Ｚａ-ｚ", "0-9A-Za-z")

      # 半角カタカナを全角カタカナに変換
      str = Moji.han_to_zen(str, Moji::HAN_KATA)

      # 特定の文字の統一変換
      str.gsub!(/(?:˗|֊|‐|‑|‒|–|⁃|⁻|₋|−)/, "-")
      str.gsub!(/(?:﹣|－|ｰ|—|―|─|━)/, "ー")
      str.gsub!(/(?:~|∼|∾|〜|〰|～)/, "")

      # 長音符号の連続を統一
      str.gsub!(/[ー]+/, "ー")

      # 特殊記号を全角に変換
      str.tr!(%q{!"#$%&'()*+,-.\/:;<=>?@[¥]^_`{|}~｡､･｢｣},
        "！”＃＄％＆’（）＊＋，－．／：；＜＝＞？＠［￥］＾＿｀｛｜｝〜。、・「」")

      # 全角スペースを半角スペースに変換
      str.gsub!(/　/, " ")

      # 連続するスペースを1つに
      str.squeeze!(" ")

      # 前後のスペースを除去
      str.strip!

      # 日本語と英数字の間のスペースを除去
      while str =~ %r{([\p{InCjkUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)[ ]{1}([\p{InCjkUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)}
        str.gsub!(%r{([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+?)}, "\\1\\2")
      end
      while str =~ %r{([\p{InBasicLatin}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)}
        str.gsub!(%r{([\p{InBasicLatin}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)}, "\\1\\2")
      end
      while str =~ %r{([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InBasicLatin}]+)}
        str.gsub!(%r{([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InBasicLatin}]+)}, "\\1\\2")
      end

      # 半角記号を元に戻す
      str.tr!("！”＃＄％＆’（）＊＋，－．／：；＜＞？＠［￥］＾＿｀｛｜｝〜",
        %q{!"#$%&'()*+,-.\/:;<>?@[¥]^_`{|}~})

      str
    end

    module_function :normalize
  end
end
