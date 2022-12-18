fileDelete ("sourceC.lua") 
--if getElementData(localPlayer,"player:charname") == "Paul Jhonson" then
  local sx,sy = guiGetScreenSize()
  local pedElement = nil
  local cache = {}
  
  local page = ""
  
  local hoverslot = 0
  local hoveritem = nil
  
  local maxshow = 7
  local scrolvaule = 0
  
  local maxshow2 = 15
  local scrolvaule2 = 0
  
  local maxshow3 = 10
  local scrolvaule3 = 0
  
  local text = ""
  local text2 = ""
  local text3 = ""

  local text4 = ""
  
  margin = 5
  local column = 3
  local row = nil
  
  local column3 = 3
  local row3 = nil
  local itemImage = {}
  
  cache.price = 0
  cache.roboto = dxCreateFont("files/roboto.ttf",20)
  cache.fontawsome = dxCreateFont("files/fontawsome.ttf",20)
  cache.sans = dxCreateFont("files/sansheavy.otf",20)
  cache.choosepanel = false
  cache.listpanel = false
  cache.click = false
  cache.show = false
  cache.nearby = false
  cache.clicknum = 0
  
  bindKey("backspace","down",function()
    if cache.show and page == "chooseitem" or page == "shop" or page == "ownershop" or page == "restock" then 
      if not cache.click then 
      removeEventHandler("onClientRender",root,drawPanel)
      page = ""
      pedElement = nil
      cache.show = false
      chooseditems = {}
      maxshow = 7
      scrolvaule = 0
      maxshow2 = 15
      scrolvaule2 = 0
      maxshow3 = 10
      scrolvaule3 = 0
      cache.price = 0
      sale = 0
      end 
    end 
  end)
  
  function drawPanel()
    
    if isElement(pedElement) then 
    pedItems = getElementData(pedElement,"ped:items");
    end 

    if page == "chooseitem" then
  
      dxDrawRectangle(sx*0.33,sy*0.25,sx*0.37,sy*0.45,tocolor(25,25,25,255))
      dxDrawRectangle(sx*0.6,sy*0.25,sx*0.001,sy*0.45,tocolor(129, 99, 191,255))
  
      for i = 1,5 do
        dxDrawRectangle(sx*0.601,sy*0.15 + (i*sy*0.1),sx*0.099,sy*0.05,tocolor(29, 29, 29,255))
      end
  
      if isInSlot(sx*0.33,sy*0.25,sx*0.27,sy*0.45) then
        cache.listpanel = true
      else
        cache.listpanel = false
      end
  
      if isInSlot(sx*0.601,sy*0.25,sx*0.099,sy*0.4) then
        cache.choosepanel = true
      else
        cache.choosepanel = false
      end
  
      dxDrawText("Kiválasztott Itemek",sx*0.613 - 1,sy*0.265 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
      dxDrawText("Kiválasztott Itemek",sx*0.613,sy*0.265,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
  
      for k,v in pairs(chooseditems) do
        if k <= maxshow and (k > scrolvaule) then
          if isInSlot(sx*0.605,sy*0.255 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039) then
            dxDrawRectangle(sx*0.605,sy*0.256 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039,tocolor(129, 99, 191,255))
          else
            dxDrawRectangle(sx*0.605,sy*0.256 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039,tocolor(40,40,40,255))
          end
  
          if utf8.len(exports["inventory"]:getItemName(v[1])) < 20 then
            dxDrawText(exports["inventory"]:getItemName(v[1]),sx*0.63  - 1,sy*0.258 + sy*0.05 * (k-scrolvaule) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
            dxDrawText(exports["inventory"]:getItemName(v[1]),sx*0.63 ,sy*0.258 + sy*0.05 * (k-scrolvaule),_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto)
          else
            dxDrawText("..."..utf8.sub(exports["inventory"]:getItemName(v[1]),utf8.len(exports["inventory"]:getItemName(v[1]))-10,utf8.len(exports["inventory"]:getItemName(v[1]))),sx*0.63  - 1,sy*0.258 + sy*0.05 * (k-scrolvaule) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
            dxDrawText("..."..utf8.sub(exports["inventory"]:getItemName(v[1]),utf8.len(exports["inventory"]:getItemName(v[1]))-10,utf8.len(exports["inventory"]:getItemName(v[1]))),sx*0.63 ,sy*0.258 + sy*0.05 * (k-scrolvaule),_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto)
          end
          dxDrawImage(sx*0.606,sy*0.258 + sy*0.05 * (k-scrolvaule),sx*0.021,sy*0.035,exports["inventory"]:getItemImage(v[1]))
          dxDrawText(v[2].."$",sx*0.63 - 1,sy*0.275 + sy*0.05 * (k-scrolvaule) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
          dxDrawText(v[2].."$",sx*0.63,sy*0.275 + sy*0.05 * (k-scrolvaule),_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)
        end
      end
  
      if isInSlot(sx*0.603,sy*0.65,sx*0.095,sy*0.046) then
        dxDrawRectangle(sx*0.603,sy*0.65,sx*0.095,sy*0.046,tocolor(94, 173, 94,255))
      else
        dxDrawRectangle(sx*0.603,sy*0.65,sx*0.095,sy*0.046,tocolor(94, 173, 94,200))
      end
  
      dxDrawText("Mentés",sx*0.635 - 1,sy*0.662 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
      dxDrawText("Mentés",sx*0.635,sy*0.662,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
  
      row2 = 0
      column2 = 0
      hoverslot = 0
      hoveritem = nil
  
      for i = 1,row * column do
        if i <= maxshow2 and (i > scrolvaule2) then
          height = sx*0.021
          weight = sy*0.035
          left = sx*0.355 + column2 * (height + margin + sx*0.07) + margin
          top = sy*0.265 + row2 * (weight + margin + sy*0.046) + margin
  
          if items[i] then
  
            if isInSlot(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003) then
              hoverslot = i
              hoveritem = items[i]
              dxDrawRectangle(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003,tocolor(129, 99, 191,255))
            else
              dxDrawRectangle(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003,tocolor(40,40,40,255))
            end
  
            dxDrawImage(left,top,sx*0.021,sy*0.035,exports["inventory"]:getItemImage(items[i][1]))
            dxDrawText(exports["inventory"]:getItemName(items[i][1]),left - dxGetTextWidth(exports["inventory"]:getItemName(items[i][1]),0.00032*sx,cache.roboto)/2 + sx*0.01 - 1,top + sy*0.04 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
            dxDrawText(exports["inventory"]:getItemName(items[i][1]),left - dxGetTextWidth(exports["inventory"]:getItemName(items[i][1]),0.00032*sx,cache.roboto)/2 + sx*0.01,top + sy*0.04,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
            dxDrawText(items[i][2].."$",left - dxGetTextWidth(items[i][2].."$",0.00032*sx,cache.roboto)/2 + sx*0.011 - 1,top + sy*0.06 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
            dxDrawText(items[i][2].."$",left - dxGetTextWidth(items[i][2].."$",0.00032*sx,cache.roboto)/2 + sx*0.011,top + sy*0.06,_,_,tocolor(129, 99, 191,255),0.00032*sx,cache.roboto)
  
            column2 = column2 + 1
  
            if column2 == column then
              column2 = 0
              row2 = row2 + 1
            end
          end
        end
  
      end
      
    elseif page == "choosetype" then
  
      dxDrawRectangle(sx*0.438,sy*0.4,sx*0.13,sy*0.13,tocolor(25,25,25,255))
      dxDrawText("Írd be a bolt típusát",sx*0.465,sy*0.405,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
      dxDrawRectangle(sx*0.4725,sy*0.45,sx*0.06,sy*0.03,tocolor(40,40,40,255))
      dxDrawRectangle(sx*0.438,sy*0.53,sx*0.13,sy*0.003,tocolor(129, 99, 191,255))
  
      if text == "" then
        dxDrawText("Típus",sx*0.49,sy*0.454,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
      else
        dxDrawText(text,sx*0.502 - dxGetTextWidth(text,0.00032*sx,cache.roboto)/2.1,sy*0.454,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
      end
  
      if isInSlot(sx*0.477,sy*0.5,sx*0.05,sy*0.025) then
        dxDrawRectangle(sx*0.477,sy*0.5,sx*0.05,sy*0.025,tocolor(94, 173, 94,255))
      else
        dxDrawRectangle(sx*0.477,sy*0.5,sx*0.05,sy*0.025,tocolor(94, 173, 94,200))
      end
  
      dxDrawText("Mentés",sx*0.487,sy*0.502,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
  
    elseif page == "shop" then
      dxDrawRectangle(sx*0.33,sy*0.25,sx*0.37,sy*0.45,tocolor(25,25,25,255))
      dxDrawRectangle(sx*0.6,sy*0.25,sx*0.001,sy*0.45,tocolor(129, 99, 191,255))
  
      for i = 1,5 do
        dxDrawRectangle(sx*0.601,sy*0.15 + (i*sy*0.1),sx*0.099,sy*0.05,tocolor(29, 29, 29,255))
      end
  
      if isInSlot(sx*0.33,sy*0.25,sx*0.27,sy*0.45) then
        cache.listpanel = true
      else
        cache.listpanel = false
      end
  
      if isInSlot(sx*0.601,sy*0.25,sx*0.099,sy*0.4) then
        cache.choosepanel = true
      else
        cache.choosepanel = false
      end
  
      dxDrawText("Kiválasztott Itemek",sx*0.613 - 1,sy*0.258 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
      dxDrawText("Kiválasztott Itemek",sx*0.613,sy*0.258,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
  
      dxDrawText(cache.price.."$",sx*0.649 - dxGetTextWidth(cache.price.."$",0.0003*sx,cache.roboto)/2 - 1,sy*0.276 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
      dxDrawText(cache.price.."$",sx*0.649 - dxGetTextWidth(cache.price.."$",0.0003*sx,cache.roboto)/2,sy*0.276,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)
  
      for k,v in pairs(chooseditems) do
        if k <= maxshow and (k > scrolvaule) then
          if isInSlot(sx*0.605,sy*0.255 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039) then
            dxDrawRectangle(sx*0.605,sy*0.256 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039,tocolor(129, 99, 191,255))
          else
            dxDrawRectangle(sx*0.605,sy*0.256 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039,tocolor(40,40,40,255))
          end
  
          if utf8.len(exports["inventory"]:getItemName(v[1])) < 20 then
            dxDrawText(exports["inventory"]:getItemName(v[1]).." ("..v[3]..")",sx*0.63  - 1,sy*0.258 + sy*0.05 * (k-scrolvaule) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
            dxDrawText(exports["inventory"]:getItemName(v[1]).." ##8163bf("..v[3]..")",sx*0.63 ,sy*0.258 + sy*0.05 * (k-scrolvaule),_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
          else
            dxDrawText("..."..utf8.sub(exports["inventory"]:getItemName(v[1]).." ("..v[3]..")",utf8.len(exports["inventory"]:getItemName(v[1]).."("..v[3]..")")-10,utf8.len(exports["inventory"]:getItemName(v[1]))),sx*0.63  - 1,sy*0.258 + sy*0.05 * (k-scrolvaule) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
            dxDrawText("..."..utf8.sub(exports["inventory"]:getItemName(v[1]).." ##8163bf("..v[3]..")",utf8.len(exports["inventory"]:getItemName(v[1]).."("..v[3]..")")-10,utf8.len(exports["inventory"]:getItemName(v[1]))),sx*0.63 ,sy*0.258 + sy*0.05 * (k-scrolvaule),_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
          end
          dxDrawImage(sx*0.606,sy*0.258 + sy*0.05 * (k-scrolvaule),sx*0.021,sy*0.035,exports["inventory"]:getItemImage(v[1]))
          dxDrawText(v[5].."$",sx*0.63 - 1,sy*0.275 + sy*0.05 * (k-scrolvaule) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
          dxDrawText(v[5].."$",sx*0.63,sy*0.275 + sy*0.05 * (k-scrolvaule),_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)
        end
      end
  
      if isInSlot(sx*0.603,sy*0.65,sx*0.095,sy*0.046) then
        dxDrawRectangle(sx*0.603,sy*0.65,sx*0.095,sy*0.046,tocolor(94, 173, 94,255))
      else
        dxDrawRectangle(sx*0.603,sy*0.65,sx*0.095,sy*0.046,tocolor(94, 173, 94,200))
      end
  
      dxDrawText("Vásárlás",sx*0.634 - 1,sy*0.662 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
      dxDrawText("Vásárlás",sx*0.634,sy*0.662,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
  
      row2 = 0
      column2 = 0
      hoverslot = 0
      hoveritem = nil
  
      for i = 1,row * column do
        if i <= maxshow2 and (i > scrolvaule2) then
          height = sx*0.021
          weight = sy*0.035
          left = sx*0.355 + column2 * (height + margin + sx*0.07) + margin
          top = sy*0.265 + row2 * (weight + margin + sy*0.046) + margin
  
          if pedItems[i] then
  
            if isInSlot(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003) then
              hoverslot = i
              hoveritem = pedItems[i]
              dxDrawRectangle(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003,tocolor(129, 99, 191,255))
            else
              dxDrawRectangle(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003,tocolor(40,40,40,255))
            end
  
            dxDrawImage(left,top,sx*0.021,sy*0.035,exports["inventory"]:getItemImage(pedItems[i][1]))
            dxDrawText(exports["inventory"]:getItemName(pedItems[i][1]),left - dxGetTextWidth(exports["inventory"]:getItemName(pedItems[i][1]),0.00032*sx,cache.roboto)/2 + sx*0.01 - 1,top + sy*0.04 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
            dxDrawText(exports["inventory"]:getItemName(pedItems[i][1]),left - dxGetTextWidth(exports["inventory"]:getItemName(pedItems[i][1]),0.00032*sx,cache.roboto)/2 + sx*0.01,top + sy*0.04,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
            dxDrawText(pedItems[i][5].."$",left - dxGetTextWidth(pedItems[i][5].."$",0.00032*sx,cache.roboto)/2 + sx*0.011 - 1,top + sy*0.06 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
            dxDrawText(pedItems[i][5].."$",left - dxGetTextWidth(pedItems[i][5].."$",0.00032*sx,cache.roboto)/2 + sx*0.011,top + sy*0.06,_,_,tocolor(129, 99, 191,255),0.00032*sx,cache.roboto)
  
            column2 = column2 + 1
  
            if column2 == column then
              column2 = 0
              row2 = row2 + 1
            end
          end
        end
  
      end
    elseif page == "ownershop" then 
  
      dxDrawRectangle(sx*0.33,sy*0.25,sx*0.37,sy*0.45,tocolor(25,25,25,255))
      dxDrawRectangle(sx*0.6,sy*0.25,sx*0.001,sy*0.45,tocolor(129, 99, 191,255))
      dxDrawRectangle(sx*0.33,sy*0.22,sx*0.05,sy*0.025,tocolor(40,40,40,255))
  
      if isInSlot(sx*0.33125,sy*0.2225,sx*0.047,sy*0.02) then
      dxDrawRectangle(sx*0.33125,sy*0.2225,sx*0.047,sy*0.02,tocolor(129, 99, 191,255))
      else 
      dxDrawRectangle(sx*0.33125,sy*0.2225,sx*0.047,sy*0.02,tocolor(25,25,25,255))
      end
  
      dxDrawText("Készletfeltöltés",sx*0.333 - 1,sy*0.2245 + 1,_,_,tocolor(0,0,0,255),0.00023*sx,cache.roboto)
      dxDrawText("Készletfeltöltés",sx*0.333,sy*0.2245,_,_,tocolor(255,255,255,255),0.00023*sx,cache.roboto)
  
      for i = 1,5 do
        dxDrawRectangle(sx*0.601,sy*0.15 + (i*sy*0.1),sx*0.099,sy*0.05,tocolor(29, 29, 29,255))
      end
  
      if isInSlot(sx*0.33,sy*0.25,sx*0.27,sy*0.45) then
        cache.listpanel = true
      else
        cache.listpanel = false
      end
  
      if isInSlot(sx*0.601,sy*0.25,sx*0.099,sy*0.4) then
        cache.choosepanel = true
      else
        cache.choosepanel = false
      end
  
      dxDrawText("Kiválasztott Itemek",sx*0.613 - 1,sy*0.258 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
      dxDrawText("Kiválasztott Itemek",sx*0.613,sy*0.258,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
  
      dxDrawText(cache.price.."$",sx*0.649 - dxGetTextWidth(cache.price.."$",0.0003*sx,cache.roboto)/2 - 1,sy*0.276 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
      dxDrawText(cache.price.."$",sx*0.649 - dxGetTextWidth(cache.price.."$",0.0003*sx,cache.roboto)/2,sy*0.276,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)
  
      for k,v in pairs(chooseditems) do
        if k <= maxshow and (k > scrolvaule) then
          if isInSlot(sx*0.605,sy*0.255 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039) then
            dxDrawRectangle(sx*0.605,sy*0.256 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039,tocolor(129, 99, 191,255))
          else
            dxDrawRectangle(sx*0.605,sy*0.256 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039,tocolor(40,40,40,255))
          end
  
          if utf8.len(exports["inventory"]:getItemName(v[1])) < 20 then
            dxDrawText(exports["inventory"]:getItemName(v[1]).." ("..v[3]..")",sx*0.63  - 1,sy*0.258 + sy*0.05 * (k-scrolvaule) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
            dxDrawText(exports["inventory"]:getItemName(v[1]).." ##8163bf("..v[3]..")",sx*0.63 ,sy*0.258 + sy*0.05 * (k-scrolvaule),_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
          else
            dxDrawText("..."..utf8.sub(exports["inventory"]:getItemName(v[1]).." ("..v[3]..")",utf8.len(exports["inventory"]:getItemName(v[1]).."("..v[3]..")")-10,utf8.len(exports["inventory"]:getItemName(v[1]))),sx*0.63  - 1,sy*0.258 + sy*0.05 * (k-scrolvaule) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
            dxDrawText("..."..utf8.sub(exports["inventory"]:getItemName(v[1]).." ##8163bf("..v[3]..")",utf8.len(exports["inventory"]:getItemName(v[1]).."("..v[3]..")")-10,utf8.len(exports["inventory"]:getItemName(v[1]))),sx*0.63 ,sy*0.258 + sy*0.05 * (k-scrolvaule),_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
          end
          dxDrawImage(sx*0.606,sy*0.258 + sy*0.05 * (k-scrolvaule),sx*0.021,sy*0.035,exports["inventory"]:getItemImage(v[1]))
          dxDrawText(v[5].."$",sx*0.63 - 1,sy*0.275 + sy*0.05 * (k-scrolvaule) + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
          dxDrawText(v[5].."$",sx*0.63,sy*0.275 + sy*0.05 * (k-scrolvaule),_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)
        end
      end
  
      if isInSlot(sx*0.603,sy*0.65,sx*0.095,sy*0.046) then
        dxDrawRectangle(sx*0.603,sy*0.65,sx*0.095,sy*0.046,tocolor(94, 173, 94,255))
      else
        dxDrawRectangle(sx*0.603,sy*0.65,sx*0.095,sy*0.046,tocolor(94, 173, 94,200))
      end
  
      dxDrawText("Vásárlás",sx*0.634 - 1,sy*0.662 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
      dxDrawText("Vásárlás",sx*0.634,sy*0.662,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
  
      row2 = 0
      column2 = 0
      hoverslot = 0
      hoveritem = nil
  
      for i = 1,row * column do
        if i <= maxshow2 and (i > scrolvaule2) then
          height = sx*0.021
          weight = sy*0.035
          left = sx*0.355 + column2 * (height + margin + sx*0.07) + margin
          top = sy*0.265 + row2 * (weight + margin + sy*0.046) + margin
  
          if pedItems[i] then
  
            if isInSlot(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003) then
              hoverslot = i
              hoveritem = pedItems[i]
              dxDrawRectangle(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003,tocolor(129, 99, 191,255))
            else
              dxDrawRectangle(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003,tocolor(40,40,40,255))
            end
  
            dxDrawImage(left,top,sx*0.021,sy*0.035,exports["inventory"]:getItemImage(pedItems[i][1]))
            dxDrawText(exports["inventory"]:getItemName(pedItems[i][1]),left - dxGetTextWidth(exports["inventory"]:getItemName(pedItems[i][1]),0.00032*sx,cache.roboto)/2 + sx*0.01 - 1,top + sy*0.04 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
            dxDrawText(exports["inventory"]:getItemName(pedItems[i][1]),left - dxGetTextWidth(exports["inventory"]:getItemName(pedItems[i][1]),0.00032*sx,cache.roboto)/2 + sx*0.01,top + sy*0.04,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
            dxDrawText(pedItems[i][5].."$",left - dxGetTextWidth(pedItems[i][5].."$",0.00032*sx,cache.roboto)/2 + sx*0.011 - 1,top + sy*0.06 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
            dxDrawText(pedItems[i][5].."$",left - dxGetTextWidth(pedItems[i][5].."$",0.00032*sx,cache.roboto)/2 + sx*0.011,top + sy*0.06,_,_,tocolor(129, 99, 191,255),0.00032*sx,cache.roboto)
  
            column2 = column2 + 1
  
            if column2 == column then
              column2 = 0
              row2 = row2 + 1
            end
          end
        end
  
      end
  
    elseif page == "restock" then 
      dxDrawRectangle(sx*0.62,sy*0.22,sx*0.08,sy*0.025,tocolor(40,40,40,255))
      dxDrawRectangle(sx*0.6215,sy*0.2225,sx*0.0775,sy*0.02,tocolor(25,25,25,255)) --94, 173, 94

      if isInSlot(sx*0.57,sy*0.2225,sx*0.047,sy*0.02) then 
      dxDrawRectangle(sx*0.57,sy*0.2225,sx*0.047,sy*0.02,tocolor(94, 173, 94,255))
      else 
      dxDrawRectangle(sx*0.57,sy*0.2225,sx*0.047,sy*0.02,tocolor(94, 173, 94,200))
      end 

      dxDrawText("Kivétel",sx*0.5825 - 1,sy*0.2235 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto)
      dxDrawText("Kivétel",sx*0.5825,sy*0.2235,_,_,tocolor(255,255,255,255),0.00027*sx,cache.roboto)

      if isInSlot(sx*0.52,sy*0.2225,sx*0.047,sy*0.02) then 
      dxDrawRectangle(sx*0.52,sy*0.2225,sx*0.047,sy*0.02,tocolor(191, 65, 65,255))
      else 
      dxDrawRectangle(sx*0.52,sy*0.2225,sx*0.047,sy*0.02,tocolor(191, 65, 65,200))
      end 

      dxDrawText("Berakás",sx*0.53 - 1,sy*0.2235 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto)
      dxDrawText("Berakás",sx*0.53,sy*0.2235,_,_,tocolor(255,255,255,255),0.00027*sx,cache.roboto)

        if cache.clicknum == 3 then 
          dxDrawText(text4.."$",sx*0.698 - dxGetTextWidth(text4.."$",0.0003*sx,cache.roboto),sy*0.2225,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)
        else 
          dxDrawText(getElementData(pedElement,"ped:money").."$",sx*0.698 - dxGetTextWidth(getElementData(pedElement,"ped:money").."$",0.0003*sx,cache.roboto),sy*0.2225,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)
        end 

      dxDrawRectangle(sx*0.33,sy*0.25,sx*0.37,sy*0.45,tocolor(25,25,25,255))
      dxDrawRectangle(sx*0.6,sy*0.25,sx*0.001,sy*0.45,tocolor(129, 99, 191,255))
      dxDrawRectangle(sx*0.33,sy*0.22,sx*0.05,sy*0.025,tocolor(40,40,40,255))
  
      if isInSlot(sx*0.33125,sy*0.2225,sx*0.047,sy*0.02) then
      dxDrawRectangle(sx*0.33125,sy*0.2225,sx*0.047,sy*0.02,tocolor(129, 99, 191,255))
      else 
      dxDrawRectangle(sx*0.33125,sy*0.2225,sx*0.047,sy*0.02,tocolor(25,25,25,255))
      end
  
      dxDrawText("Vissza a bolthoz",sx*0.333 - 1,sy*0.2245 + 1,_,_,tocolor(0,0,0,255),0.00022*sx,cache.roboto)
      dxDrawText("Vissza a bolthoz",sx*0.333,sy*0.2245,_,_,tocolor(255,255,255,255),0.00022*sx,cache.roboto)  
  
      if isInSlot(sx*0.33,sy*0.25,sx*0.27,sy*0.45) then
        cache.listpanel = true
      else
        cache.listpanel = false
      end
  
      if isInSlot(sx*0.601,sy*0.25,sx*0.099,sy*0.4) then
        cache.choosepanel = true
      else
        cache.choosepanel = false
      end
  
      dxDrawText("Kínálat szerkesztése",sx*0.611 - 1,sy*0.258 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
      dxDrawText("Kínálat szerkesztése",sx*0.611,sy*0.258,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
  
      dxDrawText(cache.price.."$",sx*0.649 - dxGetTextWidth(cache.price.."$",0.0003*sx,cache.roboto)/2 - 1,sy*0.276 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
      dxDrawText(cache.price.."$",sx*0.649 - dxGetTextWidth(cache.price.."$",0.0003*sx,cache.roboto)/2,sy*0.276,_,_,tocolor(129, 99, 191,255),0.0003*sx,cache.roboto)
  
  
      if chooseditems[1] then 
        dxDrawImage(sx*0.637,sy*0.3,sx*0.021,sy*0.035,exports["inventory"]:getItemImage(chooseditems[1][1]))

        dxDrawText(exports["inventory"]:getItemName(chooseditems[1][1]),sx*0.648 - dxGetTextWidth(exports["inventory"]:getItemName(chooseditems[1][1]),0.0003*sx,cache.roboto)/2 - 1,sy*0.34 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto)
        dxDrawText(exports["inventory"]:getItemName(chooseditems[1][1]),sx*0.648 - dxGetTextWidth(exports["inventory"]:getItemName(chooseditems[1][1]),0.0003*sx,cache.roboto)/2,sy*0.34,_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto)
        dxDrawText("A termék jelenlegi ára: "..pedItems[sale][5].."$",sx*0.65 - dxGetTextWidth("A termék jelenlegi ára: "..pedItems[sale][5].."$",0.00025*sx,cache.roboto)/2 - 1,sy*0.37 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.roboto,"left","top",false,false,false,true)
        dxDrawText("A termék jelenlegi ára: ##8163bf"..pedItems[sale][5].."$",sx*0.65 - dxGetTextWidth("A termék jelenlegi ára: "..pedItems[sale][5].."$",0.00025*sx,cache.roboto)/2,sy*0.37,_,_,tocolor(255,255,255,255),0.00025*sx,cache.roboto,"left","top",false,false,false,true)
        dxDrawText("Raktáron: "..pedItems[sale][4].."db",sx*0.649 - dxGetTextWidth("Raktáron: "..pedItems[sale][4].."db",0.00025*sx,cache.roboto)/2 - 1,sy*0.39 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.roboto,"left","top",false,false,false,true)
        dxDrawText("Raktáron: ##8163bf"..pedItems[sale][4].."db",sx*0.649 - dxGetTextWidth("Raktáron: "..pedItems[sale][4].."db",0.00025*sx,cache.roboto)/2,sy*0.39,_,_,tocolor(255,255,255,255),0.00025*sx,cache.roboto,"left","top",false,false,false,true)
        dxDrawText("Beszerzési ár: "..pedItems[sale][2].."$",sx*0.649 - dxGetTextWidth("Beszerzési ár: "..pedItems[sale][2].."$",0.00025*sx,cache.roboto)/2 - 1,sy*0.41 + 1,_,_,tocolor(0,0,0,255),0.00025*sx,cache.roboto,"left","top",false,false,false,true)
        dxDrawText("Beszerzési ár: ##8163bf"..pedItems[sale][2].."$",sx*0.649 - dxGetTextWidth("Beszerzési ár: "..pedItems[sale][2].."$",0.00025*sx,cache.roboto)/2,sy*0.41,_,_,tocolor(255,255,255,255),0.00025*sx,cache.roboto,"left","top",false,false,false,true)

        dxDrawText("Beszerzés: ",sx*0.632 - 1,sy*0.47 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)
        dxDrawText("Beszerzés: ",sx*0.632,sy*0.47,_,_,tocolor(255,255,255,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)

        dxDrawRectangle(sx*0.626,sy*0.496,sx*0.05,sy*0.022,tocolor(40,40,40,255))

        if text3 == "" then 
          dxDrawText("0db",sx*0.645 - 1,sy*0.499 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)
          dxDrawText("0db",sx*0.645,sy*0.499,_,_,tocolor(255,255,255,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)
        else 
          dxDrawText(text3.."db",sx*0.651 - dxGetTextWidth(text3.."db",0.00027*sx,cache.roboto)/2 - 1,sy*0.499 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)
          dxDrawText(text3.."db",sx*0.651 - dxGetTextWidth(text3.."db",0.00027*sx,cache.roboto)/2,sy*0.499,_,_,tocolor(255,255,255,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)
        end

        dxDrawText("Új ár megadása: ",sx*0.624,sy*0.54,_,_,tocolor(255,255,255,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)
        dxDrawRectangle(sx*0.626,sy*0.57,sx*0.05,sy*0.022,tocolor(40,40,40,255))

        if text2 == "" then 
          dxDrawText("0$",sx*0.647 - 1,sy*0.5725 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)
          dxDrawText("0$",sx*0.647,sy*0.5725,_,_,tocolor(255,255,255,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)
        else 
          dxDrawText(text2.."$",sx*0.6523 - dxGetTextWidth(text2.."$",0.00027*sx,cache.roboto)/2 - 1,sy*0.5725 + 1,_,_,tocolor(0,0,0,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)
          dxDrawText(text2.."$",sx*0.6523 - dxGetTextWidth(text2.."$",0.00027*sx,cache.roboto)/2,sy*0.5725,_,_,tocolor(255,255,255,255),0.00027*sx,cache.roboto,"left","top",false,false,false,true)
        end

        if isInSlot(sx*0.631,sy*0.6,sx*0.04,sy*0.025) then
          dxDrawRectangle(sx*0.631,sy*0.6,sx*0.04,sy*0.025,tocolor(94, 173, 94,255))
        else
          dxDrawRectangle(sx*0.631,sy*0.6,sx*0.04,sy*0.025,tocolor(94, 173, 94,200))
        end

        dxDrawText("Mentés",sx*0.637 - 1,sy*0.603 + 1,_,_,tocolor(0,0,0,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)
        dxDrawText("Mentés",sx*0.637,sy*0.603,_,_,tocolor(255,255,255,255),0.0003*sx,cache.roboto,"left","top",false,false,false,true)

      end
  
  
      if isInSlot(sx*0.603,sy*0.65,sx*0.095,sy*0.046) then
        dxDrawRectangle(sx*0.603,sy*0.65,sx*0.095,sy*0.046,tocolor(94, 173, 94,255))
      else
        dxDrawRectangle(sx*0.603,sy*0.65,sx*0.095,sy*0.046,tocolor(94, 173, 94,200))
      end
  
      dxDrawText("Beszerzés",sx*0.632 - 1,sy*0.662 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
      dxDrawText("Beszerzés",sx*0.632,sy*0.662,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
  
      row2 = 0
      column2 = 0
      hoverslot = 0
      hoveritem = nil
  
      for i = 1,row * column do
        if i <= maxshow2 and (i > scrolvaule2) then
          height = sx*0.021
          weight = sy*0.035
          left = sx*0.355 + column2 * (height + margin + sx*0.07) + margin
          top = sy*0.265 + row2 * (weight + margin + sy*0.046) + margin
  
          if pedItems[i] then
  
            if isInSlot(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003) then
              hoverslot = i
              hoveritem = pedItems[i]
              dxDrawRectangle(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003,tocolor(129, 99, 191,255))
            else
              dxDrawRectangle(left - sx*0.0015,top - sy*0.0015,height + sx*0.003,weight + sy*0.003,tocolor(40,40,40,255))
            end
  
            dxDrawImage(left,top,sx*0.021,sy*0.035,exports["inventory"]:getItemImage(pedItems[i][1]))
            dxDrawText(exports["inventory"]:getItemName(pedItems[i][1]),left - dxGetTextWidth(exports["inventory"]:getItemName(pedItems[i][1]),0.00032*sx,cache.roboto)/2 + sx*0.01 - 1,top + sy*0.04 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
            dxDrawText(exports["inventory"]:getItemName(pedItems[i][1]),left - dxGetTextWidth(exports["inventory"]:getItemName(pedItems[i][1]),0.00032*sx,cache.roboto)/2 + sx*0.01,top + sy*0.04,_,_,tocolor(255,255,255,255),0.00032*sx,cache.roboto)
            dxDrawText(pedItems[i][5].."$",left - dxGetTextWidth(pedItems[i][5].."$",0.00032*sx,cache.roboto)/2 + sx*0.011 - 1,top + sy*0.06 + 1,_,_,tocolor(0,0,0,255),0.00032*sx,cache.roboto)
            dxDrawText(pedItems[i][5].."$",left - dxGetTextWidth(pedItems[i][5].."$",0.00032*sx,cache.roboto)/2 + sx*0.011,top + sy*0.06,_,_,tocolor(129, 99, 191,255),0.00032*sx,cache.roboto)
  
            column2 = column2 + 1
  
            if column2 == column then
              column2 = 0
              row2 = row2 + 1
            end
          end
        end
  
      end
  
    end
  end
  
  function onClientClick ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if button == "left" and state == "down" then
        if page == "chooseitem" then
            if cache.show then
                if hoverslot > 0 then
                    if hoveritem then
                        local isInItem = false;
                        for k,v in pairs(chooseditems) do
                            if items[hoverslot][1] == v[1] then
                                isInItem = true;
                            end
                        end
  
                        if not isInItem then
                            local tableRecords = {items[hoverslot][1],items[hoverslot][2],items[hoverslot][3],items[hoverslot][4],items[hoverslot][5]}
                            table.insert(chooseditems,1,tableRecords)
                        else
                            exports["Pinfobox"]:addNotification("Ez a tétel már szerepel a listán!","error")
                        end
                    end
                end
      
                for k,v in pairs(chooseditems) do
                    if isInSlot(sx*0.605,sy*0.255 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039) and page == "chooseitem" then
                        if k <= maxshow and (k > scrolvaule) then
                            table.remove(chooseditems,k)
                        end
                    end
                end
      
                if isInSlot(sx*0.603,sy*0.65,sx*0.095,sy*0.046) then
                    local count = 0
      
                    for k,v in pairs(chooseditems) do
                        count = count + 1
                    end
      
                    if count == 0 then
                        exports["Pinfobox"]:addNotification("Először válaszd ki milyen itemeket szeretnél a boltba!","error")
                    else
                        exports["Pinfobox"]:addNotification("Add meg a bolt típusát","success")
                        page = "choosetype"
                    end
                end
            end
        elseif page == "choosetype" then

            if isInSlot(sx*0.4725,sy*0.45,sx*0.06,sy*0.03) then
                cache.click = true
                setElementData(localPlayer,"box:writing",true)
            else
              if not isInSlot(sx*0.57,sy*0.2225,sx*0.047,sy*0.02) and not isInSlot(sx*0.52,sy*0.2225,sx*0.047,sy*0.02) then 
                cache.click = false
                setElementData(localPlayer,"box:writing",false)
              end
            end
      
            if isInSlot(sx*0.477,sy*0.5,sx*0.05,sy*0.025) then
                if text == "" or text == " " then
                    exports["Pinfobox"]:addNotification("Típus nélkűl???","error")
                else
                    triggerServerEvent("insertSave",localPlayer,localPlayer,getElementData(pedElement,"ped:dbid"),chooseditems,tostring(text))
                    setElementData(pedElement,"ped:items",chooseditems)
                    exports["Pinfobox"]:addNotification("Sikeresen elkészítetted a boltot.","success")
                    removeEventHandler("onClientRender",root,drawPanel)
                    setElementData(pedElement,"ped:type",tostring(text))
                    page = ""
                    text = ""
                    pedElement = nil
                    cache.show = false
                    chooseditems = {}
                    maxshow = 7
                    scrolvaule = 0
                    maxshow2 = 15
                    scrolvaule2 = 0
                    maxshow3 = 10
                    scrolvaule3 = 0
                    cache.price = 0
                    sale = 0
                end
            end
        elseif page == "shop" or page == "ownershop" then 
      
            if hoveritem then
              if hoverslot > 0 then
                      local inserted = true 
  
                      for k,v in pairs(chooseditems) do 
                        if pedItems[hoverslot][1] == v[1] then 
                          if exports["inventory"]:getItemStackable(v[1]) then 
                          inserted = false
                          chooseditems[k][3] = chooseditems[k][3] + 1
                          cache.price = cache.price + chooseditems[k][5]
                          end 
                        end 
                      end 
  
                      if inserted then 
  
                        local tableRecords = {pedItems[hoverslot][1],pedItems[hoverslot][2],pedItems[hoverslot][3],pedItems[hoverslot][4],pedItems[hoverslot][5]}
                        table.insert(chooseditems,1,tableRecords)
                        cache.price = cache.price + pedItems[hoverslot][5]
  
                      end 
                end
            end
             
  
          for k,v in pairs(chooseditems) do
            if isInSlot(sx*0.605,sy*0.255 + sy*0.05 * (k-scrolvaule),sx*0.023,sy*0.039) then
                if k <= maxshow and (k > scrolvaule) then
                  if v[3] > 1 then 
                    v[3] = v[3] - 1
                    cache.price = (cache.price - v[5])
                  else 
                    table.remove(chooseditems,k)
                    cache.price = cache.price - v[5]
                  end 
                end
            end
          end
  
          if isInSlot(sx*0.603,sy*0.65,sx*0.095,sy*0.046) then 
            
            local count2 = 0;
            for k,v in pairs(chooseditems) do
                count2 = count2+1;
            end
  
              if count2 > 0 then 
              --ide ird te fasz
              triggerServerEvent("buyItem",localPlayer,localPlayer,chooseditems,cache.price,exports["inventory"]:getAllItemWeight(),getElementData(pedElement,"ped:dbid"))
              removeEventHandler("onClientRender",root,drawPanel)

              page = ""
              pedElement = nil
              cache.show = false
              chooseditems = {}
              maxshow = 7
              scrolvaule = 0
              maxshow2 = 15
              scrolvaule2 = 0
              maxshow3 = 10
              scrolvaule3 = 0
              cache.price = 0
              else 
              exports["Pinfobox"]:addNotification("Nincs semmilyen kiválasztott itemed!","error")
              end 
  
          end
  
        end
      
        if clickedElement and isElement(clickedElement) and getElementData(clickedElement,"ped:shop") then
            local x,y,z = getElementPosition(localPlayer)
            local px,py,pz = getElementPosition(clickedElement)
            local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
      
            if distance < 2 then
                if not pedElement then
                    pedElement = clickedElement
                    pedItems = getElementData(pedElement,"ped:items");
                    pedOwner = getElementData(pedElement,"ped:owner");
                    
                    local count = 0;
                    for kv in pairs(pedItems) do
                        count = count+1;
                    end

                  if count == 0 then

                      if getElementData(localPlayer,"player:admin") >= 3 then 
                        addEventHandler("onClientRender",root,drawPanel)
                        page = "chooseitem"
                        exports["Pinfobox"]:addNotification("Válaszd ki milyen itemek legyenek a shopban.","info")
                        cache.show = true
                        row = #items
                      else 
                        exports["Pinfobox"]:addNotification("Ez a bolt még nincs beállítva, keress fel egy Lead Administratort.","error")
                        page = ""
                        pedElement = nil
                        cache.show = false
                        chooseditems = {}
                        maxshow = 7
                        scrolvaule = 0
                        maxshow2 = 15
                        scrolvaule2 = 0
                        maxshow3 = 10
                        scrolvaule3 = 0
                        cache.price = 0 
                      end 

                  else

                      if pedOwner == getElementData(localPlayer,"player:dbid") then 
                        addEventHandler("onClientRender",root,drawPanel)
                        page = "ownershop"
                        row = #pedItems
                        cache.show = true
                      else 
                        addEventHandler("onClientRender",root,drawPanel)
                        page = "shop"
                        row = #pedItems
                        cache.show = true
                      end 

                  end
                end
            end
        end
  
        if page == "ownershop" then 
          if isInSlot(sx*0.33125,sy*0.2225,sx*0.047,sy*0.02) then 
            page = "restock"
            exports["Pinfobox"]:addNotification("Válaszd ki a szerkeszteni kívánt itemet.","info")
            chooseditems = {}
            cache.price = 0
          end 
        elseif page == "restock" then 
          if isInSlot(sx*0.33125,sy*0.2225,sx*0.047,sy*0.02) then 
            page = "ownershop"
            chooseditems = {}
            cache.price = 0
          end
        end

        if page == "restock" then 

          if hoveritem then
            if hoverslot > 0 then

                chooseditems = {}
                local tableRecords = {pedItems[hoverslot][1],pedItems[hoverslot][2],pedItems[hoverslot][3],pedItems[hoverslot][4],pedItems[hoverslot][5]}
                table.insert(chooseditems,1,tableRecords)
                sale = hoverslot

              end
          end

          if isInSlot(sx*0.626,sy*0.496,sx*0.05,sy*0.022) then 
            cache.clicknum = 1
            cache.click = true 
            setElementData(localPlayer,"box:writing",true)
          elseif isInSlot(sx*0.626,sy*0.57,sx*0.05,sy*0.022) then  
              cache.clicknum = 2
              cache.click = true 
              setElementData(localPlayer,"box:writing",true)
          elseif isInSlot(sx*0.6215,sy*0.2225,sx*0.0775,sy*0.02) then 
              cache.clicknum = 3
              cache.click = true 
              setElementData(localPlayer,"box:writing",true)
          else
            if not isInSlot(sx*0.57,sy*0.2225,sx*0.047,sy*0.02) and not isInSlot(sx*0.52,sy*0.2225,sx*0.047,sy*0.02) then 
              cache.clicknum = 0
              cache.click = false 
              setElementData(localPlayer,"box:writing",false)
            end 
          end

          if isInSlot(sx*0.631,sy*0.6,sx*0.04,sy*0.025) then 
            if type(tonumber(text2)) == "number" then 
              if tonumber(text2) > 0 and tonumber(text2) < 999999 then 
                pedItems[sale][5] = tonumber(text2)
                triggerServerEvent("insertSave",localPlayer,localPlayer,getElementData(pedElement,"ped:dbid"),pedItems,tostring(text))
                setElementData(pedElement,"ped:items",pedItems)
                text2 = ""
              else 
                exports["Pinfobox"]:addNotification("Ne adj meg irreális árat!","error")
              end 
            end 
          end  

          if isInSlot(sx*0.603,sy*0.65,sx*0.095,sy*0.046) then 
            triggerServerEvent("restockItem",localPlayer,localPlayer,cache.price,getElementData(pedElement,"ped:dbid"))
          end 

          if isInSlot(sx*0.57,sy*0.2225,sx*0.047,sy*0.02) then 
            if text4 == "" then 
              exports["Pinfobox"]:addNotification("Először írd be a pénzhez az összeget.","error")
            else 
              triggerServerEvent("takeMoneyFromShop",localPlayer,localPlayer,tonumber(text4),getElementData(pedElement,"ped:dbid"))
              text4 = ""
              cache.click = false 
              cache.clicknum = 0
              setElementData(localPlayer,"box:writing",false)
            end 
          elseif isInSlot(sx*0.52,sy*0.2225,sx*0.047,sy*0.02) then 
            if text4 == "" then 
              exports["Pinfobox"]:addNotification("Először írd be a pénzhez az összeget.","error")
            else 
              triggerServerEvent("giveMoneyForShop",localPlayer,localPlayer,tonumber(text4),getElementData(pedElement,"ped:dbid"))
              text4 = ""
              cache.click = false 
              cache.clicknum = 0
              setElementData(localPlayer,"box:writing",false)
            end
          end 


        end 
  
  
    end
  end
  addEventHandler ( "onClientClick", getRootElement(), onClientClick )
  
  function restockItems()
    triggerServerEvent("saveItems",localPlayer,localPlayer,pedItems,getElementData(pedElement,"ped:dbid"))
    cache.price = 0 
    pedItems[sale][4] = pedItems[sale][4] + tonumber(text3)
    setElementData(pedElement,"ped:items",pedItems)
    text3 = ""
  end 
  addEvent("restockItems",true)
  addEventHandler("restockItems",root,restockItems)

  addEventHandler("onClientKey", getRootElement(), function(button, press)
  if press and cache.choosepanel and cache.show and not page == "restock" then
    if button == "mouse_wheel_up" then
      if scrolvaule > 0  then
        scrolvaule = scrolvaule -1
        maxshow = maxshow -1
      end
    elseif button == "mouse_wheel_down" then
      if maxshow < #chooseditems then
        scrolvaule = scrolvaule +1
        maxshow = maxshow +1
      end
    end
  end
  end)
  
  addEventHandler("onClientKey", getRootElement(), function(button, press)
  if press and cache.listpanel and cache.show then
    if button == "mouse_wheel_up" then
      if scrolvaule2 > 0  then
        scrolvaule2 = scrolvaule2 -3
        maxshow2 = maxshow2 -3
      end
    elseif button == "mouse_wheel_down" then
      if maxshow2 < #items then
        scrolvaule2 = scrolvaule2 +3
        maxshow2 = maxshow2 +3
      end
    end
  end
  end)
  
  addEventHandler("onClientKey", root,
  function(key,pOr)
    if (key == "backspace") and cache.click and cache.show then
      if page == "choosetype" then  
        if (pOr) then
          text = utf8.sub(text, 0, utf8.len(text)-1)
          deleteTimer = setTimer(function()
          text = utf8.sub(text, 0, utf8.len(text)-1)
          end, 100, 0);
        else
          if (isTimer(deleteTimer)) then
            killTimer(deleteTimer);
          end
        end
      elseif page == "restock" then 
        if cache.clicknum == 1 then 
          if (pOr) then
            if string.len(text3) > 1 then
              text3 = utf8.sub(text3, 0, utf8.len(text3)-1)
              cache.price = pedItems[1][2] * tonumber(text3)
              deleteTimer = setTimer(function()
              text3 = utf8.sub(text3, 0, utf8.len(text3)-1)
              --cache.price = pedItems[1][2] * tonumber(text3)
              end, 100, 0);
            else 
              text3 = utf8.sub(text3, 0, utf8.len(text3)-1)
              cache.price = 0
              deleteTimer = setTimer(function()
              text3 = utf8.sub(text3, 0, utf8.len(text3)-1)
              --cache.price = pedItems[1][2] * tonumber(text3)
              end, 100, 0);
            end 
          else
            if (isTimer(deleteTimer)) then
              killTimer(deleteTimer);
            end
          end
        elseif cache.clicknum == 2 then 
          if (pOr) then
            text2 = utf8.sub(text2, 0, utf8.len(text2)-1)
            deleteTimer = setTimer(function()
              text2 = utf8.sub(text2, 0, utf8.len(text2)-1)
            end, 100, 0);
          else
            if (isTimer(deleteTimer)) then
              killTimer(deleteTimer);
            end
          end
        elseif cache.clicknum == 3 then 
          if (pOr) then
            text4 = utf8.sub(text4, 0, utf8.len(text4)-1)
            deleteTimer = setTimer(function()
              text4 = utf8.sub(text4, 0, utf8.len(text4)-1)
            end, 100, 0);
          else
            if (isTimer(deleteTimer)) then
              killTimer(deleteTimer);
            end
          end 
        end
      end
    end
    end)
  
  
addEventHandler("onClientCharacter", root, function(char)
    if cache.show then
        if cache.click == true then
          if page == "choosetype" then 
          text = text ..char
          elseif page == "restock" then 
            if cache.clicknum == 1 then 
              if type(tonumber(char)) == "number" then 
                text3 = text3 ..char
                cache.price = pedItems[1][2] * tonumber(text3) 
              end 
            elseif cache.clicknum == 2 then 
                text2 = text2 ..char
            elseif cache.clicknum == 3 then 
              if type(tonumber(char)) == "number" then 
                text4 = text4 ..char
              end 
            end 
          end
        end
    end
end)
  
  
      local func = {};
      local peds = {};
  
    func.start = function()  

      for k,v in ipairs(getElementsByType("ped")) do
        if getElementData(v,"ped:dbid") and getElementDimension(localPlayer) == getElementDimension(v) and getElementInterior(localPlayer) == getElementInterior(v) then
          if not peds[v] then
            peds[v] = true;
          end
        end
      end
  
    end
    addEventHandler("onClientResourceStart",resourceRoot,func.start)
  
    func.streamOut = function()
    if getElementType(source) == "ped" and getElementData(source, "ped:dbid") then
      peds[source] = nil;
    end
  end
  addEventHandler("onClientElementStreamOut",getRootElement(),func.streamOut)
  
  func.streamIn = function()
  if getElementType(source) == "ped" and getElementData(source, "ped:dbid") and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) then
    if not peds[source] then
      peds[source] = true;
    end
  end
  end
  addEventHandler("onClientElementStreamIn",getRootElement(),func.streamIn)
  
  func.destroy = function()
  if getElementType(source) == "ped" and getElementData(source, "ped:dbid") and getElementDimension(localPlayer) == getElementDimension(source) and getElementInterior(localPlayer) == getElementInterior(source) then
  if peds[source] then
    peds[source] = nil;
  end
  end
  end
  addEventHandler("onClientElementDestroy", getRootElement(),func.destroy)
  
  func.render = function()
  local pX,pY,pZ, _, _, _ = getCameraMatrix()
  for v,k in pairs(peds) do
  if isElementStreamedIn(v) then
    if getElementData(v,"ped:shop") then
    local pedX,pedY,pedZ = getElementPosition(v)
    local x,y = getScreenFromWorldPosition(pedX, pedY, pedZ+1)
    local distance = getDistanceBetweenPoints3D(pedX, pedY, pedZ, pX, pY, pZ)
    if distance <= 30 then
      local line = isLineOfSightClear(pedX, pedY, pedZ+1, pX, pY, pZ, true, true, false, true, false, false, false, localPlayer)
      if line then
        if x or y then
          dxDrawText("ID: ["..getElementData(v,"ped:dbid").."]".." OWNER: ["..getElementData(v,"ped:owner").."]",x - 1,y + 1,x,y,tocolor(0,0,0,255),1,"default","center","center",false,false,false,true)
          dxDrawText("ID: ##8163bf["..getElementData(v,"ped:dbid").."]".." #ffffffOWNER: ##8163bf["..getElementData(v,"ped:owner").."]",x,y,x,y,tocolor(255,255,255,255),1,"default","center","center",false,false,false,true)
        end
      end
    end
    end 
  end
  end
  end
  
  func.nearby = function()
  if getElementData(localPlayer,"player:admin") >= 3 then
  if not cache.nearby then
  cache.nearby = true 
  addEventHandler("onClientRender",getRootElement(),func.render)
  outputChatBox("[xProject]:#ffffff Shop információ megjelenítve.",129, 99, 191,true)
  else
  cache.nearby = false
  removeEventHandler("onClientRender",getRootElement(),func.render)
  outputChatBox("[xProject]:#ffffff Shop információ eltüntetve.",129, 99, 191,true)
  end
  end
  end
  addCommandHandler("nearbyshop",func.nearby)
  
  --end