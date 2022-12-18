--1,2,3,4,5,Fő,Sa,Tulaj,Rendszergazda,Fejlesztő

local titles = {"Admin 1","Admin 2","Admin 3","Admin 4","Admin 5","FőAdmin","SzuperAdmin","Manager","Rendszergazda","Fejlesztő","Tulajdonos"}

function getAdminTitle(rank)
	return titles[rank] or "Ismeretlen"
end