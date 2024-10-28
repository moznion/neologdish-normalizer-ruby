# frozen_string_literal: true

require_relative "normalizer/version"
require "moji"

module Neologd
  module Normalizer
    CONVERSION_MAP = {
      # Normalize [0-9a-zA-Z] to half-width
      "０" => "0", "１" => "1", "２" => "2", "３" => "3", "４" => "4", "５" => "5", "６" => "6", "７" => "7", "８" => "8", "９" => "9",
      "Ａ" => "A", "Ｂ" => "B", "Ｃ" => "C", "Ｄ" => "D", "Ｅ" => "E", "Ｆ" => "F", "Ｇ" => "G", "Ｈ" => "H", "Ｉ" => "I", "Ｊ" => "J",
      "Ｋ" => "K", "Ｌ" => "L", "Ｍ" => "M", "Ｎ" => "N", "Ｏ" => "O", "Ｐ" => "P", "Ｑ" => "Q", "Ｒ" => "R", "Ｓ" => "S", "Ｔ" => "T",
      "Ｕ" => "U", "Ｖ" => "V", "Ｗ" => "W", "Ｘ" => "X", "Ｙ" => "Y", "Ｚ" => "Z",
      "ａ" => "a", "ｂ" => "b", "ｃ" => "c", "ｄ" => "d", "ｅ" => "e", "ｆ" => "f", "ｇ" => "g", "ｈ" => "h", "ｉ" => "i", "ｊ" => "j",
      "ｋ" => "k", "ｌ" => "l", "ｍ" => "m", "ｎ" => "n", "ｏ" => "o", "ｐ" => "p", "ｑ" => "q", "ｒ" => "r", "ｓ" => "s", "ｔ" => "t",
      "ｕ" => "u", "ｖ" => "v", "ｗ" => "w", "ｘ" => "x", "ｙ" => "y", "ｚ" => "z",
      # normalize the hyphen/minus-ish characters to '-'
      "˗" => "-", "֊" => "-", "‐" => "-", "‑" => "-", "‒" => "-", "–" => "-", "⁃" => "-", "⁻" => "-", "₋" => "-", "−" => "-",
      # normalize the long-vowel mark-ish characters to 'ー'
      "﹣" => "ー", "－" => "ー", "ｰ" => "ー", "—" => "ー", "―" => "ー", "─" => "ー", "━" => "ー",
      # remove the tilde-ish characters
      "~" => "", "∼" => "", "∾" => "", "〜" => "", "〰" => "", "～" => "",
      # normalize the full-width special symbol characters (/！”＃＄％＆’（）＊＋，−．／：；＜＞？＠［￥］＾＿｀｛｜｝) and space characters to half-width
      "　" => " ", "！" => "!", "”" => "\"", "＃" => "#", "＄" => "$", "％" => "%", "＆" => "&", "’" => "'", "（" => "(", "）" => ")",
      "＊" => "*", "＋" => "+", "，" => ",", "．" => ".", "／" => "/", "：" => ":", "；" => ";", "＜" => "<", "＞" => ">", "？" => "?",
      "＠" => "@", "［" => "[", "￥" => "¥", "］" => "]", "＾" => "^", "＿" => "_", "｀" => "`", "｛" => "{", "｜" => "|", "｝" => "}",
      # normalize the half-width special symbol characters (｡､･=｢｣) to full-width
      "｡" => "。", "､" => "、", "･" => "・", "｢" => "「", "｣" => "」"
    } #: Hash[String, String]

    LATIN_MAP = {
      "0" => true, "1" => true, "2" => true, "3" => true, "4" => true, "5" => true, "6" => true, "7" => true, "8" => true, "9" => true,
      "A" => true, "B" => true, "C" => true, "D" => true, "E" => true, "F" => true, "G" => true, "H" => true, "I" => true, "J" => true,
      "K" => true, "L" => true, "M" => true, "N" => true, "O" => true, "P" => true, "Q" => true, "R" => true, "S" => true, "T" => true,
      "U" => true, "V" => true, "W" => true, "X" => true, "Y" => true, "Z" => true,
      "a" => true, "b" => true, "c" => true, "d" => true, "e" => true, "f" => true, "g" => true, "h" => true, "i" => true, "j" => true,
      "k" => true, "l" => true, "m" => true, "n" => true, "o" => true, "p" => true, "q" => true, "r" => true, "s" => true, "t" => true,
      "u" => true, "v" => true, "w" => true, "x" => true, "y" => true, "z" => true
    } #: Hash[String, bool]

    private_constant :CONVERSION_MAP, :LATIN_MAP

    # @rbs str: String
    # @rbs return: String
    def normalize(str)
      str = Moji.han_to_zen(str, Moji::HAN_KATA)

      squeezee = ""
      prev_latin = false
      whitespace_encountered = false
      str = str.chars.map do |c|
        c = CONVERSION_MAP[c] || c

        # squash consecutive special characters (space or long-vowel)
        if c == " " || c == "ー"
          if squeezee == c
            c = ""
          else
            squeezee = c
          end
        else
          squeezee = ""
        end

        # remove the white space character in the middle of non-latin characters
        is_latin = LATIN_MAP[c] || false
        if c == " "
          whitespace_encountered = prev_latin
          c = ""
        else
          if is_latin && whitespace_encountered
            c = " #{c}"
          end
          whitespace_encountered = false
        end
        prev_latin = is_latin

        c
      end.join

      str.strip
    end

    module_function :normalize
  end
end
