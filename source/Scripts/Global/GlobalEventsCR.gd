class_name GlobalEvents extends Resource

signal OnInteractInspection3D(inspectable:Inspectable)
signal OnInspect3D(camTex:ViewportTexture)
signal OnInteract()
signal OnInteractInspectionText(texts:Array[String])
signal OnStartDialog(character:CharacterData)
signal EndInspection()
signal MapOpen()
signal MapClose()
signal MoveToObject(position:Vector2)
signal StopMoving()
signal SusOpen()
signal SusClose()
