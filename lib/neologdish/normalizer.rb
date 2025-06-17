# frozen_string_literal: true

require_relative 'normalizer/version'

module Neologdish
  # A Japanese text normalizer module according to the neologd convention.
  module Normalizer
    NORMALIZED_HYPHEN = "\u002d" # -
    NORMALIZED_VOWEL = "\u30fc" # ー

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
      "\u02d7" => NORMALIZED_HYPHEN, # ˗
      "\u058a" => NORMALIZED_HYPHEN, # ֊
      "\u2010" => NORMALIZED_HYPHEN, # ‐
      "\u2011" => NORMALIZED_HYPHEN, # ‑
      "\u2012" => NORMALIZED_HYPHEN, # ‒
      "\u2013" => NORMALIZED_HYPHEN, # –
      "\u2043" => NORMALIZED_HYPHEN, # ⁃
      "\u207b" => NORMALIZED_HYPHEN, # ⁻
      "\u208b" => NORMALIZED_HYPHEN, # ₋
      "\u2212" => NORMALIZED_HYPHEN, # −
      # normalize the long-vowel mark-ish characters to 'ー'
      "\u2014" => NORMALIZED_VOWEL, # —
      "\u2015" => NORMALIZED_VOWEL, # ―
      "\u2500" => NORMALIZED_VOWEL, # ─
      "\u2501" => NORMALIZED_VOWEL, # ━
      "\ufe63" => NORMALIZED_VOWEL, # ﹣
      "\uff0d" => NORMALIZED_VOWEL, # －
      "\uff70" => NORMALIZED_VOWEL, # ｰ
      # remove the tilde-ish characters
      "\u007e" => '', # ~
      "\u223c" => '', # ∼
      "\u223e" => '', # ∾
      "\u301c" => '', # 〜
      "\u3030" => '', # 〰
      "\uff5e" => '', # ～
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

    DAKUON_HANDAKUON_POSSIBLES = {
      'ウ' => true,
      'カ' => true, 'キ' => true, 'ク' => true, 'ケ' => true, 'コ' => true,
      'サ' => true, 'シ' => true, 'ス' => true, 'セ' => true, 'ソ' => true,
      'タ' => true, 'チ' => true, 'ツ' => true, 'テ' => true, 'ト' => true,
      'ハ' => true, 'ヒ' => true, 'フ' => true, 'ヘ' => true, 'ホ' => true,
      'う' => true,
      'か' => true, 'き' => true, 'く' => true, 'け' => true, 'こ' => true,
      'さ' => true, 'し' => true, 'す' => true, 'せ' => true, 'そ' => true,
      'た' => true, 'ち' => true, 'つ' => true, 'て' => true, 'と' => true,
      'は' => true, 'ひ' => true, 'ふ' => true, 'へ' => true, 'ほ' => true
    }.freeze #: Hash[String, bool]

    DAKUON_KANA_MAP = {
      'ウ' => 'ヴ',
      'カ' => 'ガ', 'キ' => 'ギ', 'ク' => 'グ', 'ケ' => 'ゲ', 'コ' => 'ゴ',
      'サ' => 'ザ', 'シ' => 'ジ', 'ス' => 'ズ', 'セ' => 'ゼ', 'ソ' => 'ゾ',
      'タ' => 'ダ', 'チ' => 'ヂ', 'ツ' => 'ヅ', 'テ' => 'デ', 'ト' => 'ド',
      'ハ' => 'バ', 'ヒ' => 'ビ', 'フ' => 'ブ', 'ヘ' => 'ベ', 'ホ' => 'ボ',
      'う' => 'ゔ',
      'か' => 'が', 'き' => 'ぎ', 'く' => 'ぐ', 'け' => 'げ', 'こ' => 'ご',
      'さ' => 'ざ', 'し' => 'じ', 'す' => 'ず', 'せ' => 'ぜ', 'そ' => 'ぞ',
      'た' => 'だ', 'ち' => 'ぢ', 'つ' => 'づ', 'て' => 'で', 'と' => 'ど',
      'は' => 'ば', 'ひ' => 'び', 'ふ' => 'ぶ', 'へ' => 'べ', 'ほ' => 'ぼ'
    }.freeze #: Hash[String, String]

    HANDAKUON_KANA_MAP = {
      'ハ' => 'パ', 'ヒ' => 'ピ', 'フ' => 'プ', 'ヘ' => 'ペ', 'ホ' => 'ポ',
      'は' => 'ぱ', 'ひ' => 'ぴ', 'ふ' => 'ぷ', 'へ' => 'ぺ', 'ほ' => 'ぽ'
    }.freeze #: Hash[String, String]

    private_constant :CONVERSION_MAP, :LATIN_MAP, :HALF_WIDTH_KANA_MAP, :DAKUON_KANA_MAP, :HANDAKUON_KANA_MAP, :DAKUON_HANDAKUON_POSSIBLES,
                     :NORMALIZED_HYPHEN, :NORMALIZED_VOWEL

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
      dakuon_handakuon_possible = nil
      normalized = str.chars.map do |c|
        prefix = ''
        c = conversion_map[c] || c

        # normalize the Half-width kana to full-width
        if dakuon_handakuon_possible
          if (["\u309b", "\u3099", "\uff9e"].include?(c) && (k = DAKUON_KANA_MAP[dakuon_handakuon_possible])) ||
             (["\u309c", "\u309a", "\uff9f"].include?(c) && (k = HANDAKUON_KANA_MAP[dakuon_handakuon_possible]))
            c = ''
            prefix = k
          else
            prefix = dakuon_handakuon_possible
          end
        end

        if (encountered_half_width_kana = HALF_WIDTH_KANA_MAP[c])
          c = encountered_half_width_kana
        end

        dakuon_handakuon_possible = nil
        if DAKUON_HANDAKUON_POSSIBLES[c]
          dakuon_handakuon_possible = c
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
      end.join + (dakuon_handakuon_possible || '')

      normalized.strip
    end

    module_function :normalize
  end
end
