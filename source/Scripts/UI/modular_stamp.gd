class_name ModularStamp extends Node

@onready var age_img: TextureRect = $ageImg
@onready var mark_img: TextureRect = $MarkImg
@onready var profession_img: TextureRect = $ProfessionImg
@onready var birth_img: TextureRect = $birthImg
@onready var family_img: TextureRect = $familyImg

func SetupStamp(stamp:StampData) -> void:
	age_img.texture = GlobalResources.STAMPS_DATA.AgeSymbols.get(stamp.Age)
	mark_img.texture = GlobalResources.STAMPS_DATA.MarkSymbols.get(stamp.Mark)
	profession_img.texture = GlobalResources.STAMPS_DATA.ProfessionSymbols.get(stamp.Profession)
	birth_img.texture = GlobalResources.STAMPS_DATA.BirthSymbols.get(stamp.Birth)
	family_img.texture = GlobalResources.STAMPS_DATA.FamiliesSymbols.get(stamp.Family)
