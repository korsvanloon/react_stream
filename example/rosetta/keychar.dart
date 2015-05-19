library keychar;

abstract class KeyBoardChar {
  String char;
  String keyChar;
  String letter;
}

class LatinChar implements KeyBoardChar {
  String char, keyChar, letter;
  LatinChar(char) : this.keyChar = char, this.char = char, this.letter = char;
}

class Rune implements KeyBoardChar{
  String letter;
  String char;
  String keyChar;
  String name;
  String nameTranslation;
  String meaning;
  Rune(this.letter, this.char, this.keyChar, [this.name, this.nameTranslation, this.meaning]);
}

var staves = "ᚪᚫᛉᚨᛒᛍᛣᛤᚳᛢᛑᛞᛛᛀᛔᛂᛠᛖᚶᚧᚠᚵᚸᚷᛄᚻᚺᛨᛝᛜᛡᛁᛇᛃᚴᚲᛚᛅᚼᛘᚬᛦᛗᚾᚮᚯᚰᛕᚩᛟᛈᛩᚱᛆᛓᚽᛙᚿᚭᛌᛐᛧᛋᛊᛥᚦᛏᚢᚡᚥᚹᛪᚤᚣᛎ᛬᛫ᛮᛯᛰ᛭";
var keyboardCharacters = r"qwertyuiop[]asdfghjkl;'\`zxcvbnm,./";

var latin = <LatinChar>[
  new LatinChar('q'),
  new LatinChar('w'),
  new LatinChar('e'),
  new LatinChar('r'),
  new LatinChar('t'),
  new LatinChar('y'),
  new LatinChar('u'),
  new LatinChar('i'),
  new LatinChar('o'),
  new LatinChar('p'),
  new LatinChar('['),
  new LatinChar(']'),
  new LatinChar('a'),
  new LatinChar('s'),
  new LatinChar('d'),
  new LatinChar('f'),
  new LatinChar('g'),
  new LatinChar('h'),
  new LatinChar('j'),
  new LatinChar('k'),
  new LatinChar('l'),
  new LatinChar(';'),
  new LatinChar("'"),
  new LatinChar(r'\'),
  new LatinChar('`'),
  new LatinChar('z'),
  new LatinChar('x'),
  new LatinChar('c'),
  new LatinChar('v'),
  new LatinChar('b'),
  new LatinChar('n'),
  new LatinChar('m'),
  new LatinChar(','),
  new LatinChar('.'),
  new LatinChar('/'),
];

var elderFuthark = <Rune>[
  new Rune('f', 'ᚠ', 'f', 'fehu', 'vee', 'rijkdom'),
  new Rune('u', 'ᚢ', 'u', 'uruz', 'oeros', 'wilskracht'),
  new Rune('þ', 'ᚦ', 'v', 'thurisaz', 'deurs (reus)', 'instinctieve kracht'),
  new Rune('a', 'ᚨ', 'a', 'ansuz', 'ans (god)', 'voorspoed, vitaliteit'),
  new Rune('r', 'ᚱ', 'r', 'raidho', 'rit', 'groei, beweging'),
  new Rune('k', 'ᚲ', 'k', 'kaunan', 'kanker (gezwel)', 'sterfelijkheid, pijn'),
  new Rune('g', 'ᚷ', 'g', 'gebo', 'gift', 'vrijgevigheid'),
  new Rune('w', 'ᚹ', 'w', 'wunjo', 'vreugde', 'lol, ecstase'),

  new Rune('h', 'ᚺ', 'h', 'hagalaz', 'hagel', 'vernietiging, chaos'),
  new Rune('n', 'ᚾ', 'n', 'naudhiz', 'nood', 'onvervulde wens, moeilijke situatie'),
  new Rune('i', 'ᛁ', 'i', 'isa', 'ijs', 'stagnatie, stilstand'),
  new Rune('j', 'ᛃ', 'j', 'jera', 'jaar', 'oogst, beloning'),
  new Rune('ï', 'ᛇ', 'y', 'eiwaz', 'ijf (taxus)', 'kracht, stabiliteit'),
  new Rune('p', 'ᛈ', 'p', 'perdhro', 'perenboom', ''),
  new Rune('z', 'ᛉ', 'z', 'elhaz', 'eland', 'bescherming, verdediging'),
  new Rune('s', 'ᛊ', 's', 'sowulo', 'zon', 'succes, troost'),

  new Rune('t', 'ᛏ', 't', 'tiwaz', 'Tuw (een godheid)', 'overwinning, heil, eer'),
  new Rune('b', 'ᛒ', 'b', 'berkana', 'berk', 'vruchtbaarheid, groei, voortduren'),
  new Rune('e', 'ᛖ', 'e', 'ehwaz', 'edel dier (paard)', 'vertrouwen, betrouwbaarheid, gezelschap'),
  new Rune('m', 'ᛗ', 'm', 'mannaz', 'mens', 'toename, ondersteuning'),
  new Rune('l', 'ᛚ', 'l', 'laguz', 'laak (stroom, rivier)', 'vormloosheid, potentie, chaos'),
  new Rune('ŋ', 'ᛜ', 'x', 'ingwaz', 'Ing (een godheid)', 'bevruchting, het begin, actualisatie van potentie'),
  new Rune('d', 'ᛞ', 'd', 'dagaz', 'dag', 'hoop, blijdschap'),
  new Rune('o', 'ᛟ', 'o', 'othala', 'oedel (erfgoed)', 'erfgoed, traditie, de adel'),

  new Rune('.', '᛫', '.', 'period'),
  new Rune(':', '᛬', ';', 'colon'),
  new Rune('+', '᛭', ',', 'plus'),
];

var youngerFuthark = <Rune>[
  new Rune('f', 'ᚠ', 'f', 'fe'),
  new Rune('u', 'ᚢ', 'u', 'ur'),
  new Rune('þ', 'ᚦ', 'v', 'thurs'),
  new Rune('ą', 'ᚬ', 'a', 'as'),
  new Rune('r', 'ᚱ', 'r', 'reidh'),
  new Rune('k', 'ᚴ', 'k', 'kaun'),

  new Rune('h', 'ᚼ', 'h', 'hagall'),
  new Rune('n', 'ᚾ', 'n', 'naudhr'),
  new Rune('i', 'ᛁ', 'i', 'isa'),
  new Rune('a', 'ᛅ', 'y', 'ar'),
  new Rune('s', 'ᛋ', 's', 'sol'),

  new Rune('t', 'ᛏ', 't', 'tyr'),
  new Rune('b', 'ᛒ', 'b', 'bjarken'),
  new Rune('m', 'ᛘ', 'm', 'madhr'),
  new Rune('l', 'ᛚ', 'l', 'logr'),
  new Rune('ʀ', 'ᛦ', 'x', 'yr'),

  new Rune('.', '᛫', '.', 'period'),
  new Rune(':', '᛬', ';', 'colon'),
  new Rune('+', '᛭', ',', 'plus'),
];

var angloFuthorc = <Rune>[
  new Rune('f', 'ᚠ', 'f', 'feoh'),
  new Rune('u', 'ᚢ', 'u', 'ur'),
  new Rune('þ', 'ᚦ', 'v', 'thorn'),
  new Rune('o', 'ᚩ', 'o', 'os'),
  new Rune('r', 'ᚱ', 'r', 'rad'),
  new Rune('k', 'ᚳ', 'k', 'cen'),
  new Rune('g', 'ᚷ', 'g', 'gyfu'),
  new Rune('w', 'ᚹ', 'w', 'wyn'),

  new Rune('h', 'ᚻ', 'h', 'haegl'),
  new Rune('n', 'ᚾ', 'n', 'nyd'),
  new Rune('i', 'ᛁ', 'i', 'is'),
  new Rune('j', 'ᛄ', 'j', 'ger'),
  new Rune('eo', 'ᛇ', 'z', 'eoh'),
  new Rune('p', 'ᛈ', 'p', 'peordh'),
  new Rune('x', 'ᛉ', 'x', 'eolh'),
  new Rune('s', 'ᛋ', 's', 'sigel'),

  new Rune('t', 'ᛏ', 't', 'tir'),
  new Rune('b', 'ᛒ', 'b', 'beorc'),
  new Rune('e', 'ᛖ', 'e', 'eh'),
  new Rune('m', 'ᛗ', 'm', 'mann'),
  new Rune('l', 'ᛚ', 'l', 'lagu'),
  new Rune('ŋ', 'ᛝ', 'c', 'ing'),
  new Rune('d', 'ᛞ', 'd', 'daeg'),
  new Rune('œ', 'ᛟ', 'q', 'ethel'),

  new Rune('a', 'ᚪ', 'a', 'ac'),  //
  new Rune('æ', 'ᚫ', '[', 'aesc'), //
  new Rune('y', 'ᚣ', 'y', 'yr'),
  new Rune('ia', 'ᛡ', ']', 'ior'), //
  new Rune('ea', 'ᛠ', "'", 'ear'), //

  new Rune('.', '᛫', '.', 'period'),
  new Rune(':', '᛬', ';', 'colon'),
  new Rune('+', '᛭', ',', 'plus'),
];

//A	B	C	D	Ð	E	F	G	H	I	K	L	M	N	O	P	Q	R	S	T	U	V	W	X	Y	Z	Þ	Æ/Ä	Ø/Ö
//ᛆ	ᛒ	ᛍ	ᛑ	ᚧ	ᛂ	ᚠ	ᚵ	ᚼ	ᛁ	ᚴ	ᛚ	ᛘ	ᚿ	ᚮ	ᛔ ᛩ	ᚱ	ᛋ	ᛐ	ᚢ	ᚡ ᚥ	ᛪ	ᛦ ᛎ	ᚦ	ᛅ/ᛆ	ᚯ

var medievalRunes = <Rune>[
  new Rune('a', 'ᛆ', 'a'),
  new Rune('b', 'ᛒ', 'b'),
  new Rune('c', 'ᛍ', 'c'),
  new Rune('d', 'ᛑ', 'd'),
  new Rune('e', 'ᛂ', 'e'),
  new Rune('f', 'ᚠ', 'f'),
  new Rune('g', 'ᚵ', 'g'),
  new Rune('h', 'ᚼ', 'h'),
  new Rune('i', 'ᛁ', 'i'),
  new Rune('dh', 'ᚧ', 'j'),
  new Rune('k', 'ᚴ', 'k'),
  new Rune('l', 'ᛚ', 'l'),
  new Rune('m', 'ᛘ', 'm'),
  new Rune('n', 'ᚿ', 'n'),
  new Rune('o', 'ᚮ', 'o'),
  new Rune('p', 'ᛔ', 'p'),
  new Rune('q', 'ᛩ', 'q'),
  new Rune('r', 'ᚱ', 'r'),
  new Rune('s', 'ᛋ', 's'),
  new Rune('t', 'ᛐ', 't'),
  new Rune('u', 'ᚢ', 'u'),
  new Rune('v', 'ᚡ', 'v'),
  new Rune('w', 'ᚥ', 'w'),
  new Rune('x', 'ᛪ', 'x'),
  new Rune('y', 'ᛦ', 'y'),
  new Rune('z', 'ᛎ', 'z'),

  new Rune('þ', 'ᚦ', '['),
  new Rune('ä', 'ᛅ', ']'),
  new Rune('ö', 'ᚯ', "'"),

  new Rune('.', '᛫', '.', 'period'),
  new Rune(':', '᛬', ';', 'colon'),
  new Rune('+', '᛭', ',', 'plus'),

];

var runes = {'RUNIC LETTER AC A': 'ᚪ', 'RUNIC LETTER AESC': 'ᚫ', 'RUNIC LETTER ALGIZ EOLHX': 'ᛉ', 'RUNIC LETTER ANSUZ A': 'ᚨ', 'RUNIC LETTER BERKANAN BEORC BJARKAN B': 'ᛒ', 'RUNIC LETTER C': 'ᛍ', 'RUNIC LETTER CALC': 'ᛣ', 'RUNIC LETTER CEALC': 'ᛤ', 'RUNIC LETTER CEN': 'ᚳ', 'RUNIC LETTER CWEORTH': 'ᛢ', 'RUNIC LETTER D': 'ᛑ', 'RUNIC LETTER DAGAZ DAEG D': 'ᛞ', 'RUNIC LETTER DOTTED-L': 'ᛛ', 'RUNIC LETTER DOTTED-N': 'ᛀ', 'RUNIC LETTER DOTTED-P': 'ᛔ', 'RUNIC LETTER E': 'ᛂ', 'RUNIC LETTER EAR': 'ᛠ', 'RUNIC LETTER EHWAZ EH E': 'ᛖ', 'RUNIC LETTER ENG': 'ᚶ', 'RUNIC LETTER ETH': 'ᚧ', 'RUNIC LETTER FEHU FEOH FE F': 'ᚠ', 'RUNIC LETTER G': 'ᚵ', 'RUNIC LETTER GAR': 'ᚸ', 'RUNIC LETTER GEBO GYFU G': 'ᚷ', 'RUNIC LETTER GER': 'ᛄ', 'RUNIC LETTER HAEGL H': 'ᚻ', 'RUNIC LETTER HAGLAZ H': 'ᚺ', 'RUNIC LETTER ICELANDIC-YR': 'ᛨ', 'RUNIC LETTER ING': 'ᛝ', 'RUNIC LETTER INGWAZ': 'ᛜ', 'RUNIC LETTER IOR': 'ᛡ', 'RUNIC LETTER ISAZ IS ISS I': 'ᛁ', 'RUNIC LETTER IWAZ EOH': 'ᛇ', 'RUNIC LETTER JERAN J': 'ᛃ', 'RUNIC LETTER KAUN K': 'ᚴ', 'RUNIC LETTER KAUNA': 'ᚲ', 'RUNIC LETTER LAUKAZ LAGU LOGR L': 'ᛚ', 'RUNIC LETTER LONG-BRANCH-AR AE': 'ᛅ', 'RUNIC LETTER LONG-BRANCH-HAGALL H': 'ᚼ', 'RUNIC LETTER LONG-BRANCH-MADR M': 'ᛘ', 'RUNIC LETTER LONG-BRANCH-OSS O': 'ᚬ', 'RUNIC LETTER LONG-BRANCH-YR': 'ᛦ', 'RUNIC LETTER MANNAZ MAN M': 'ᛗ', 'RUNIC LETTER NAUDIZ NYD NAUD N': 'ᚾ', 'RUNIC LETTER O': 'ᚮ', 'RUNIC LETTER OE': 'ᚯ', 'RUNIC LETTER ON': 'ᚰ', 'RUNIC LETTER OPEN-P': 'ᛕ', 'RUNIC LETTER OS O': 'ᚩ', 'RUNIC LETTER OTHALAN ETHEL O': 'ᛟ', 'RUNIC LETTER PERTHO PEORTH P': 'ᛈ', 'RUNIC LETTER Q': 'ᛩ', 'RUNIC LETTER RAIDO RAD REID R': 'ᚱ', 'RUNIC LETTER SHORT-TWIG-AR A': 'ᛆ', 'RUNIC LETTER SHORT-TWIG-BJARKAN B': 'ᛓ', 'RUNIC LETTER SHORT-TWIG-HAGALL H': 'ᚽ', 'RUNIC LETTER SHORT-TWIG-MADR M': 'ᛙ', 'RUNIC LETTER SHORT-TWIG-NAUD N': 'ᚿ', 'RUNIC LETTER SHORT-TWIG-OSS O': 'ᚭ', 'RUNIC LETTER SHORT-TWIG-SOL S': 'ᛌ', 'RUNIC LETTER SHORT-TWIG-TYR T': 'ᛐ', 'RUNIC LETTER SHORT-TWIG-YR': 'ᛧ', 'RUNIC LETTER SIGEL LONG-BRANCH-SOL S': 'ᛋ', 'RUNIC LETTER SOWILO S': 'ᛊ', 'RUNIC LETTER STAN': 'ᛥ', 'RUNIC LETTER THURISAZ THURS THORN': 'ᚦ', 'RUNIC LETTER TIWAZ TIR TYR T': 'ᛏ', 'RUNIC LETTER URUZ UR U': 'ᚢ', 'RUNIC LETTER V': 'ᚡ', 'RUNIC LETTER W': 'ᚥ', 'RUNIC LETTER WUNJO WYNN W': 'ᚹ', 'RUNIC LETTER X': 'ᛪ', 'RUNIC LETTER Y': 'ᚤ', 'RUNIC LETTER YR': 'ᚣ', 'RUNIC LETTER Z': 'ᛎ', 'RUNIC MULTIPLE PUNCTUATION': '᛬', 'RUNIC SINGLE PUNCTUATION': '᛫', 'RUNIC ARLAUG SYMBOL (golden number 17)': 'ᛮ', 'RUNIC TVIMADUR SYMBOL (golden number 18)': 'ᛯ', 'RUNIC BELGTHOR SYMBOL (golden number 19)': 'ᛰ', 'RUNIC CROSS PUNCTUATION': '᛭'};

