extends Node

var WeaponsDictionary = {
	"UREB" : {
		"weaponType" : "UREB",
		"weaponReloadType" : "Store",

		"bulletSpeed" : 1500,

		"baseRecoil" : 100,
		"recoil" : 0,

		"baseRotationSpeed" : 0.1,

		"bulletAmount" : 1,

		"bulletsPerShot" : 1,
		"firePerSec" : 0.1,
		"reloadTime" : 0.5,
		
		"spread" : 0
		
	},
	"StellarEngine" : {
		"weaponType" : "StellarEngine",
		"weaponReloadType" : "Store",

		"bulletSpeed" : 1000,

		"baseRecoil" : 50,
		"recoil" : 0,

		"baseRotationSpeed" : 0.5,

		"bulletAmount" : 45,

		"bulletsPerShot" : 1,
		"firePerSec" : 0,
		"reloadTime" : 3,
		
		"spread" : 45,
	},
	"Electroshotgun" : {
		"weaponType" : "Electroshotgun",
		"weaponReloadType" : "Store",

		"bulletSpeed" : 500,

		"baseRecoil" : 500,
		"recoil" : 0,

		"baseRotationSpeed" : 0.5,

		"bulletAmount" : 15,

		"bulletsPerShot" : 15,
		"firePerSec" : 0,
		"reloadTime" : 2,
		
		"spread" : 15
	}
}
