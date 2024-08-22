USE ArmyDB
GO

CREATE TABLE [MilitaryPersonnel] (
  [Id] integer PRIMARY KEY IDENTITY(1, 1),
  [Name] varchar(50),
  [OfficeUnitId] integer,
  [PlatoonId] integer NOT NULL,
  [MilitaryRankId] integer NOT NULL
)
GO

CREATE TABLE [OfficeUnit] (
  [Id] integer PRIMARY KEY IDENTITY(1, 1),
  [Name] varchar(50),
  [AddressId] integer NOT NULL
)
GO

CREATE TABLE [Address] (
  [Id] integer PRIMARY KEY IDENTITY(1, 1),
  [CityId] integer NOT NULL,
  [Street] varchar(255),
  [Appartment] varchar(100)
)
GO

CREATE TABLE [City] (
  [Id] integer PRIMARY KEY IDENTITY(1, 1),
  [Name] varchar(50)
)
GO

CREATE TABLE [Platoon] (
  [Id] integer PRIMARY KEY IDENTITY(1, 1),
  [Name] varchar(255)
)
GO

CREATE TABLE [Weapon] (
  [Id] integer PRIMARY KEY IDENTITY(1, 1),
  [Name] varchar(50)
)
GO

CREATE TABLE [WeaponIssuance] (
  [Id] integer PRIMARY KEY IDENTITY(1, 1),
  [WhoIssuedMilitaryPersonId] integer NOT NULL,
  [ToWhomIssuedMilitaryPersonId] integer NOT NULL,
  [WeaponId] integer NOT NULL,
  [RecordDate] datetime NOT NULL
)
GO

CREATE TABLE [MilitaryRank] (
  [Id] integer PRIMARY KEY,
  [Name] varchar(50)
)
GO

ALTER TABLE [MilitaryPersonnel] ADD FOREIGN KEY ([OfficeUnitId]) REFERENCES [OfficeUnit] ([Id])
GO

ALTER TABLE [OfficeUnit] ADD FOREIGN KEY ([AddressId]) REFERENCES [Address] ([Id])
GO

ALTER TABLE [Address] ADD FOREIGN KEY ([CityId]) REFERENCES [City] ([Id])
GO

ALTER TABLE [MilitaryPersonnel] ADD FOREIGN KEY ([PlatoonId]) REFERENCES [Platoon] ([Id])
GO

ALTER TABLE [WeaponIssuance] ADD FOREIGN KEY ([WhoIssuedMilitaryPersonId]) REFERENCES [MilitaryPersonnel] ([Id])
GO

ALTER TABLE [WeaponIssuance] ADD FOREIGN KEY ([ToWhomIssuedMilitaryPersonId]) REFERENCES [MilitaryPersonnel] ([Id])
GO

ALTER TABLE [WeaponIssuance] ADD FOREIGN KEY ([WeaponId]) REFERENCES [Weapon] ([Id])
GO

ALTER TABLE [MilitaryPersonnel] ADD FOREIGN KEY ([MilitaryRankId]) REFERENCES [MilitaryRank] ([Id])
GO



SET IDENTITY_INSERT City ON
INSERT INTO City (Id, [Name]) VALUES 
	(1, 'Черкаси')
SET IDENTITY_INSERT City OFF

SET IDENTITY_INSERT [Address] ON
INSERT INTO [Address] (Id, CityID, Street, Appartment) VALUES 
	(1, 1, 'Сєдова 12', 'оф. 205'),
	(2, 1, 'Сєдова 12', 'оф. 221'),
	(3, 1, 'Сєдова 12', 'оф. 201')
SET IDENTITY_INSERT [Address] OFF

SET IDENTITY_INSERT OfficeUnit ON
INSERT INTO OfficeUnit (Id, [Name], AddressID) VALUES 
	(1, 'Пост н.12', 1),
	(2, 'Пост н.15', 2),
	(3, 'Віділ кадрів', 3)
SET IDENTITY_INSERT OfficeUnit OFF

SET IDENTITY_INSERT Platoon ON
INSERT INTO Platoon (Id, [Name]) VALUES 
	(1, '222'),
	(2, '232'),
	(3, '212'),
	(4, '200')
SET IDENTITY_INSERT Platoon OFF

SET IDENTITY_INSERT Weapon ON
INSERT INTO Weapon (Id, [Name]) VALUES 
	(1, 'Ak-47'),
	(2, 'Глок20')
SET IDENTITY_INSERT Weapon OFF

INSERT INTO MilitaryRank (Id, [Name]) VALUES 
	(1, 'Солдат'),
	(2, 'Сержант'),
	(3, 'Майор'),
	(4, 'Підполковник')
	


SET IDENTITY_INSERT MilitaryPersonnel ON
INSERT INTO MilitaryPersonnel (Id, [Name], OfficeUnitId, PlatoonId, MilitaryRankId) VALUES 
	(1, 'Петров В.А.', 1, 1, 1),
	(2, 'Лодарів П.С.', 2, 2, 1),
	(3, 'Леонт''єв К.В.', 3, 3, 1),
	(4, 'Духів Р.М.', null, 4, 1),
	(5, 'Буров О.С.', null, 1, 3),
	(6, 'Рибаков Н.Г.', null, 3, 3),
	(7, 'Деребанов В.Я.', null, 2, 4)

SET IDENTITY_INSERT MilitaryPersonnel OFF

SET IDENTITY_INSERT WeaponIssuance ON
INSERT INTO WeaponIssuance (Id, WhoIssuedMilitaryPersonId, ToWhomIssuedMilitaryPersonId, WeaponId, RecordDate) VALUES 
	(1, 5, 1, 1, GETDATE()),
	(2, 6, 1, 2, GETDATE()),
	(3, 7, 2, 1, GETDATE()),
	(4, 6, 2, 2, GETDATE()),
	(5, 5, 3, 1, GETDATE()),
	(6, 6, 3, 2, GETDATE()),
	(7, 5, 4, 1, GETDATE())
SET IDENTITY_INSERT WeaponIssuance OFF


SELECT
	WhomName = case
		when ad.Appartment  IS NULL then whom.Name
		else whom.Name + ', '+ ad.Appartment
	end
	,Platoon = pl.Name
	,Weapon = wp.Name
	,WhoName = who.Name+', '+  mr.Name
	,wi.RecordDate
FROM WeaponIssuance wi
	INNER Join MilitaryPersonnel who ON wi.WhoIssuedMilitaryPersonId = who.Id
	INNER Join MilitaryPersonnel whom ON wi.ToWhomIssuedMilitaryPersonId = whom.Id
	INNER Join Platoon pl ON whom.PlatoonId = pl.Id
	INNER Join Weapon wp ON wi.WeaponId = wp.Id
	Left Join OfficeUnit ou ON whom.OfficeUnitId = ou.Id
	Left Join [Address] ad ON ou.AddressId = ad.Id
	INNER Join MilitaryRank mr ON who.MilitaryRankId = mr.Id