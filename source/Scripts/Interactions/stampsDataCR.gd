class_name StampsData extends Resource

enum Families{
	Miguel, Bundasseca, Barriga, Guerra, Passos
}
enum Professions{
	Taverneiro, Doméstico, Guarda, Cozinheiro, Artista, Lojista, Estudante,
	Aposentado, Realeza
}
enum Marks{
	Ratomanocu, Boy, TrigueTriste, Mauricio, DragaoBol, Croba, Vacalo, Caba,
	Mamaco, Cock, Carrocho, Corpo
}
enum Age{
	Crianca, Adulto, Idoso
}
enum Birth{
	Primogenito, SegundoFilho, TerceiroFilho, QuartoFilho
}

@export var FamiliesSymbols:Dictionary[Families, Texture2D]
@export var ProfessionSymbols:Dictionary[Professions, Texture2D]
@export var MarkSymbols:Dictionary[Marks, Texture2D]
@export var AgeSymbols:Dictionary[Age, Texture2D]
@export var BirthSymbols:Dictionary[Birth, Texture2D]
