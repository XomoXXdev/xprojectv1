

function pSaver(  )

local conn = exports.Pcore:getConnection()    

local pID = getElementData( source, "player:dbid" )
local pAdminLevel = getElementData( source, "player:admin" )
local pAdminNick = getElementData( source, "player:adminname" )
local x, y, z = getElementPosition( source )
local pRot = getElementRotation( source )
local pDim = getElementDimension( source )
local pInt = getElementInterior( source )
local pName = getPlayerName( source )
local pLevel = getElementData( source, "player:level" )
local pHelper = getElementData( source, "player:helper" )
local pMoney = getElementData( source, "player:money" )
local Pkaja = getElementData( source, "player:hunger" )
local Phealth = getElementData( source, "player:health" )
local Pskin = getElementModel( source )

   -- outputChatBox( ""..pName.." : Adata elmentve", getRootElement(), 255, 255, 255, true )
   -- outputChatBox( ""..pAdminLevel..", "..pAdminNick..", "..pDim..", "..pInt.."", getRootElement(), 255, 255, 255, true )
  --  outputDebugString( ""..pID..", "..pAdminLevel..", "..pAdminNick..", "..x..", "..pRot..", "..pDim..", "..pInt.." ", 3 )
    dbExec( conn, " UPDATE users SET admin = ?, helper = ?, adminname = ?, x = ?, y = ?, z = ?, rotation = ?, interior = ?, dimension = ?, level = ?, money = ?, hunger = ?, health = ? WHERE id = ? ", pAdminLevel, pHelper, pAdminNick, x, y, z, pRot, pInt, pDim, pLevel, pMoney, Pkaja, Phealth, pID )
    outputDebugString( "Elmentve: "..pName.." adata!", 3)

end 
addEventHandler( "onPlayerQuit", root, pSaver )

function getMyDatas( source )
    local Parmor = getElementData( source, "player:armor" )
    local Phealth = getElementData( source, "player:health" )
    local Ppp = getElementData( source, "player:premium" )
    local Pkaja = getElementData( source, "player:hunger" )
    local Pname = getPlayerName( source )
    local pMoney = getElementData( source, "player:money" )
    local Pskin = getElementModel( source )
    local Pvalid = getElementData( source, "player:valid" )
    outputChatBox( Pname.." pénze: "..pMoney.." ", getRootElement(), 255, 255, 255, true )
    outputChatBox( Pname.." ehessege: "..Pkaja.." ", getRootElement(), 255, 255, 255, true )
    outputChatBox( Pname.." elete: "..Phealth.." ", getRootElement(), 255, 255, 255, true )
    outputChatBox( Pname.." armora: "..Parmor.." ", getRootElement(), 255, 255, 255, true )
    outputChatBox( Pname.." skinje: "..Pskin.." ", getRootElement(), 255, 255, 255, true )
    outputChatBox( Pname.." valid: "..Pvalid.." ", getRootElement(), 255, 255, 255, true )

end
addCommandHandler( "getdata", getMyDatas )
--]]
