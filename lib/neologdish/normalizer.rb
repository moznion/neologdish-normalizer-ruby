# frozen_string_literal: true

require_relative 'normalizer/version'

module Neologdish
  # A Japanese text normalizer module according to the neologd convention.
  module Normalizer
    CONVERSION_MAP = {
      # Normalize [0-9a-zA-Z] to half-width
      '０' => '0', '１' => '1', '２' => '2', '３' => '3', '４' => '4', '５' => '5', '６' => '6', '７' => '7', '８' => '8', '９' => '9',
      'Ａ' => 'A', 'Ｂ' => 'B', 'Ｃ' => 'C', 'Ｄ' => 'D', 'Ｅ' => 'E', 'Ｆ' => 'F', 'Ｇ' => 'G', 'Ｈ' => 'H', 'Ｉ' => 'I', 'Ｊ' => 'J',
      'Ｋ' => 'K', 'Ｌ' => 'L', 'Ｍ' => 'M', 'Ｎ' => 'N', 'Ｏ' => 'O', 'Ｐ' => 'P', 'Ｑ' => 'Q', 'Ｒ' => 'R', 'Ｓ' => 'S', 'Ｔ' => 'T',
      'Ｕ' => 'U', 'Ｖ' => 'V', 'Ｗ' => 'W', 'Ｘ' => 'X', 'Ｙ' => 'Y', 'Ｚ' => 'Z',
      'ａ' => 'a', 'ｂ' => 'b', 'ｃ' => 'c', 'ｄ' => 'd', 'ｅ' => 'e', 'ｆ' => 'f', 'ｇ' => 'g', 'ｈ' => 'h', 'ｉ' => 'i', 'ｊ' => 'j',
      'ｋ' => 'k', 'ｌ' => 'l', 'ｍ' => 'm', 'ｎ' => 'n', 'ｏ' => 'o', 'ｐ' => 'p', 'ｑ' => 'q', 'ｒ' => 'r', 'ｓ' => 's', 'ｔ' => 't',
      'ｕ' => 'u', 'ｖ' => 'v', 'ｗ' => 'w', 'ｘ' => 'x', 'ｙ' => 'y', 'ｚ' => 'z',
      # normalize the hyphen/minus-ish characters to '-'
      '˗' => '-', '֊' => '-', '‐' => '-', '‑' => '-', '‒' => '-', '–' => '-', '⁃' => '-', '⁻' => '-', '₋' => '-', '−' => '-',
      # normalize the long-vowel mark-ish characters to 'ー'
      '﹣' => 'ー', '－' => 'ー', 'ｰ' => 'ー', '—' => 'ー', '―' => 'ー', '─' => 'ー', '━' => 'ー',
      # remove the tilde-ish characters
      '~' => '', '∼' => '', '∾' => '', '〜' => '', '〰' => '', '～' => '',
      # normalize the full-width special symbol characters (/！”＃＄％＆’（）＊＋，−．／：；＜＞？＠［￥］＾＿｀｛｜｝) and space characters to half-width
      '　' => ' ', '！' => '!', '”' => '"', '＃' => '#', '＄' => '$', '％' => '%', '＆' => '&', '’' => "'", '（' => '(', '）' => ')',
      '＊' => '*', '＋' => '+', '，' => ',', '．' => '.', '／' => '/', '：' => ':', '；' => ';', '＜' => '<', '＞' => '>', '？' => '?',
      '＠' => '@', '［' => '[', '￥' => '¥', '］' => ']', '＾' => '^', '＿' => '_', '｀' => '`', '｛' => '{', '｜' => '|', '｝' => '}',
      # normalize the half-width special symbol characters (｡､･=｢｣) to full-width
      '｡' => '。', '､' => '、', '･' => '・', '｢' => '「', '｣' => '」'
    }.freeze #: Hash[String, String]

    LATIN_MAP = {
      '0' => true, '1' => true, '2' => true, '3' => true, '4' => true, '5' => true, '6' => true, '7' => true, '8' => true, '9' => true,
      'A' => true, 'B' => true, 'C' => true, 'D' => true, 'E' => true, 'F' => true, 'G' => true, 'H' => true, 'I' => true, 'J' => true,
      'K' => true, 'L' => true, 'M' => true, 'N' => true, 'O' => true, 'P' => true, 'Q' => true, 'R' => true, 'S' => true, 'T' => true,
      'U' => true, 'V' => true, 'W' => true, 'X' => true, 'Y' => true, 'Z' => true,
      'a' => true, 'b' => true, 'c' => true, 'd' => true, 'e' => true, 'f' => true, 'g' => true, 'h' => true, 'i' => true, 'j' => true,
      'k' => true, 'l' => true, 'm' => true, 'n' => true, 'o' => true, 'p' => true, 'q' => true, 'r' => true, 's' => true, 't' => true,
      'u' => true, 'v' => true, 'w' => true, 'x' => true, 'y' => true, 'z' => true
    }.freeze #: Hash[String, bool]

    HALF_WIDTH_KANA_MAP = {
      'ｱ' => 'ア', 'ｲ' => 'イ', 'ｳ' => 'ウ', 'ｴ' => 'エ', 'ｵ' => 'オ',
      'ｶ' => 'カ', 'ｷ' => 'キ', 'ｸ' => 'ク', 'ｹ' => 'ケ', 'ｺ' => 'コ',
      'ｻ' => 'サ', 'ｼ' => 'シ', 'ｽ' => 'ス', 'ｾ' => 'セ', 'ｿ' => 'ソ',
      'ﾀ' => 'タ', 'ﾁ' => 'チ', 'ﾂ' => 'ツ', 'ﾃ' => 'テ', 'ﾄ' => 'ト',
      'ﾅ' => 'ナ', 'ﾆ' => 'ニ', 'ﾇ' => 'ヌ', 'ﾈ' => 'ネ', 'ﾉ' => 'ノ',
      'ﾊ' => 'ハ', 'ﾋ' => 'ヒ', 'ﾌ' => 'フ', 'ﾍ' => 'ヘ', 'ﾎ' => 'ホ',
      'ﾏ' => 'マ', 'ﾐ' => 'ミ', 'ﾑ' => 'ム', 'ﾒ' => 'メ', 'ﾓ' => 'モ',
      'ﾔ' => 'ヤ', 'ﾕ' => 'ユ', 'ﾖ' => 'ヨ',
      'ﾗ' => 'ラ', 'ﾘ' => 'リ', 'ﾙ' => 'ル', 'ﾚ' => 'レ', 'ﾛ' => 'ロ',
      'ﾜ' => 'ワ', 'ｦ' => 'ヲ', 'ﾝ' => 'ン',
      'ｧ' => 'ァ', 'ｨ' => 'ィ', 'ｩ' => 'ゥ', 'ｪ' => 'ェ', 'ｫ' => 'ォ',
      'ｯ' => 'ッ', 'ｬ' => 'ヤ', 'ｭ' => 'ユ', 'ｮ' => 'ヨ'
    }.freeze #: Hash[String, String]

    DAKUON_KANA_MAP = {
      'カ' => 'ガ', 'キ' => 'ギ', 'ク' => 'グ', 'ケ' => 'ゲ', 'コ' => 'ゴ',
      'サ' => 'ザ', 'シ' => 'ジ', 'ス' => 'ズ', 'セ' => 'ゼ', 'ソ' => 'ゾ',
      'タ' => 'ダ', 'チ' => 'ヂ', 'ツ' => 'ヅ', 'テ' => 'デ', 'ト' => 'ド',
      'ハ' => 'バ', 'ヒ' => 'ビ', 'フ' => 'ブ', 'ヘ' => 'ベ', 'ホ' => 'ボ'
    }.freeze #: Hash[String, String]

    HANDAKUON_KANA_MAP = {
      'ハ' => 'パ', 'ヒ' => 'ピ', 'フ' => 'プ', 'ヘ' => 'ペ', 'ホ' => 'ポ'
    }.freeze #: Hash[String, String]

    private_constant :CONVERSION_MAP, :LATIN_MAP, :HALF_WIDTH_KANA_MAP, :DAKUON_KANA_MAP, :HANDAKUON_KANA_MAP

    # Normalize the given text.
    #
    # @rbs str: String
    # @rbs override_conversion_map: Hash[String, String]
    # @rbs return: String
    def normalize(str, override_conversion_map = {})
      conversion_map = CONVERSION_MAP.merge(override_conversion_map)

      squeezee = ''
      prev_latin = false
      whitespace_encountered = false
      encountered_half_width_kana = nil
      normalized = str.chars.map do |c|
        prefix = ''
        c = conversion_map[c] || c

        # normalize the Half-width kana to full-width
        if encountered_half_width_kana
          if (c == 'ﾞ' && (k = DAKUON_KANA_MAP[encountered_half_width_kana])) ||
             (c == 'ﾟ' && (k = HANDAKUON_KANA_MAP[encountered_half_width_kana]))
            c = ''
            prefix = k
          else
            prefix = encountered_half_width_kana
          end
        end

        if (encountered_half_width_kana = HALF_WIDTH_KANA_MAP[c])
          c = ''
        end

        # squash consecutive special characters (space or long-vowel)
        if [' ', 'ー'].include?(c)
          if squeezee == c
            c = ''
          else
            squeezee = c
          end
        else
          squeezee = ''
        end

        # remove the white space character in the middle of non-latin characters
        is_latin = LATIN_MAP[c] || false
        if c == ' '
          whitespace_encountered = prev_latin
          c = ''
        else
          prefix = ' ' if is_latin && whitespace_encountered
          whitespace_encountered &&= c == '' # take care for consecutive spaces on the right side
        end
        prev_latin = is_latin

        prefix + c
      end.join + (encountered_half_width_kana || '')

      normalized.strip
    end

    module_function :normalize
  end
end
