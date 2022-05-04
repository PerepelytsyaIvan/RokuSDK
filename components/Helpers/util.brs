function filterAssocarray(array, mark) as object
    arrayResult = []
    
    for each item in array
        if findString(item.code, mark.code)
            arrayResult.push(item)
        end if
    end for
    return arrayResult
end function

function findString(findStr, mark) as boolean
    arr = findStr.split(mark)
    return arr.count() > 1
end function

function getWidthForText(text, font)
    label = CreateObject("roSGNode", "Label")
    label.height = font.size
    label.font = font
    label.width = 0
    label.text = text
    return label.boundingrect().width
end function

' ******************************************************
' Logging Helper Functions
' ******************************************************

function ConsolLog() as object
    console = {
        logPOSTRequest: function(url, body, requestHeaders, urlEvent)
            logPOSTRequest(url, body, requestHeaders, urlEvent)
        end function
        logGetRequest: function(url, requestHeaders, urlEvent)
            logGetRequest(url, requestHeaders, urlEvent)
        end function
        logObject: function(logObject, logerName = invalid)
            logObjectWithName(logerName, logObject)
        end function
    }
    return console
end function

sub logObjectWithName(logerName, logObject)
    log = ""
    if IsString(logerName)
        log += ">>> " + logerName + ": "
    end if
    if IsString(logObject)
        log += chr(10) + chr(10) + logObject
        ? log
    else if IsValid(objectToPrintable(logObject))
        ? log
        ? objectToPrintable(logObject)
    else
        ? log
        ? "Cant print this object!!!"
    end if
end sub

function objectToTheString(obj)
    stringObj = ""
    if IsAssociativeArray(obj)
        return FormatJson(obj)
    else if IsArray(obj)
        for each item in obj
            stringObj += chr(10) + objectToTheString(item) + chr(10)
        end for
    else if IsSGNode(obj)
        fields = obj.getFields()
        return objectToTheString(fields)
    end if
    return stringObj
end function

function objectToPrintable(obj)
    stringObj = ""
    if IsAssociativeArray(obj) or IsArray(obj)
        return obj
    else if IsSGNode(obj)
        fields = obj.getFields()
        return fields
    else
        return invalid
    end if
    return stringObj
end function

' =====================================================

function logRequest(url, body, requestHeaders, method, roURLEvent)
    resJson = invalid
    responseString = roURLEvent.GetString()
    if isValid(responseString) and Len(responseString) > 0
        resJson = ParseJson(responseString)
    end if
    h = roURLEvent.GetResponseHeaders()
    ? ""
    ? "======================("method")========================== "
    ? "URL: " url
    ? ""
    if method = "POST"
        ? "BODY: " body
        ? ""
    end if
    ? "HEADERS: " requestHeaders
    ? "=================================================== "
    ? ""
    ? "RESPONSE CODE: " roURLEvent.GetResponseCode().toStr()
    ? "=================================================== "
    ? ""
    ? "RESPONSE: " resJson
    ? "=================================================== "
    ? ""
end function

function logGetRequest(url, requestHeaders, roURLEvent)
    logRequest(url, invalid, requestHeaders, "GET", roURLEvent)
end function

function logPOSTRequest(url, body, requestHeaders, roURLEvent)
    logRequest(url, body, requestHeaders, "POST", roURLEvent)
end function

' ******************************************************
' Registry Helper Functions
' ******************************************************

function RegRead(key, section = invalid)
    if section = invalid then section = "SDKData"
    sec = CreateObject("roRegistrySection", section)
    if sec.Exists(key)
        return sec.Read(key)
    end if
    return invalid
end function

function RegReadMulti(arr, section = invalid)
    if section = invalid then section = "SDKData"
    sec = CreateObject("roRegistrySection", section)
    return sec.ReadMulti(arr)
end function

function RegWrite(key, val, section = invalid)
    if section = invalid then section = "SDKData"
    sec = CreateObject("roRegistrySection", section)
    sec.Write(key, val)
end function

function RegWriteMulti(obj, section = "SDKData")
    sec = CreateObject("roRegistrySection", section)
    for each key in obj
        obj[key] = FormatJson(obj[key], 1)
    end for
    sec.WriteMulti(obj)
end function

function RegDelete(key = invalid, section = "SDKData")
    if key = invalid
        sec = CreateObject("roRegistry")
        sec.Delete(section)
    else
        sec = CreateObject("roRegistrySection", section)
        sec.Delete(key)
    end if
end function

sub saveInGlobal(key, data)
    if m.global[key] <> invalid
        m.global[key] = data
    else
        obj = {}
        obj[key] = data
        m.global.addFields(obj)
    end if
end sub

' ******************************************************
' Max function (largest from values)
' ******************************************************

function max(a, b)
    if a < b then
        return b
    else
        return a
    end if
end function

' ******************************************************
' Min function (minimum from values)
' ******************************************************

function min(a, b)
    if a > b then
        return b
    else
        return a
    end if
end function

' ******************************************************
' Array Helper Functions
' ******************************************************

function filterArr(arr, key, value)
    if arr <> invalid
        filterredArr = []
        arrCount = arr.Count() - 1
        for i = 0 to arrCount
            ? arr[i][key]
            ? value
            if arr[i][key] = value
                filterredArr.Push(arr[i])
            end if
        end for
        if (filterredArr.Count() > 0)
            return filterredArr
        else
            return invalid
        end if
    else return invalid
    end if
end function

function firstWhere(arr, key, value)
    if arr <> invalid
        filterredArr = []
        arrCount = arr.Count() - 1
        for i = 0 to arrCount
            if arr[i][key] = value
                filterredArr.Push(arr[i])
            end if
        end for
        if (filterredArr.Count() > 0)
            return filterredArr[0]
        else
            return invalid
        end if
    else return invalid
    end if
end function

function sortArray(list, property, ascending = true) as dynamic
    for i = 1 to list.count() - 1
        value = list[i]
        j = i - 1

        while j >= 0
            if (ascending and list[j][property] < value[property]) or (not ascending and list[j][property] > value[property]) then
                exit while
            end if

            list[j + 1] = list[j]
            j = j - 1
        end while

        list[j + 1] = value
    next
    return list
end function

function findArrIndex(arr, key, value, key2 = invalid)
    if arr <> invalid
        if key2 <> invalid
            for i = 0 to arr.Count() - 1
                if arr[i][key][key2] = value
                    return i
                end if
            end for
        else
            for i = 0 to arr.Count() - 1
                if arr[i][key] = value
                    return i
                end if
            end for
        end if
    end if
    return invalid
end function

function contains(arr as object, value as string) as boolean
    for each entry in arr
        if entry = value
            return true
        end if
    end for
    return false
end function

function getIndex(arr, value)
    i = 0
    for each item in arr
        if item = value
            return i
        end if
        i++
    end for
    return invalid
end function

' ******************************************************
' ToString
' ******************************************************

function ToString(variable as dynamic) as string
    if Type(variable) = "roInt" or Type(variable) = "roInteger" or Type(variable) = "roFloat" or Type(variable) = "Float" then
        return Str(variable).Trim()
    else if Type(variable) = "roBoolean" or Type(variable) = "Boolean" then
        if variable = true then
            return "True"
        end if
        return "False"
    else if Type(variable) = "roString" or Type(variable) = "String" then
        return variable
    else
        return Type(variable)
    end if
end function

' ******************************************************
' Type check
' ******************************************************

function IsXmlElement(value as dynamic) as boolean
    return IsValid(value) and GetInterface(value, "ifXMLElement") <> invalid
end function

function IsFunction(value as dynamic) as boolean
    return IsValid(value) and GetInterface(value, "ifFunction") <> invalid
end function

function IsBoolean(value as dynamic) as boolean
    return IsValid(value) and GetInterface(value, "ifBoolean") <> invalid
end function

function IsInteger(value as dynamic) as boolean
    return IsValid(value) and GetInterface(value, "ifInt") <> invalid and (Type(value) = "roInt" or Type(value) = "roInteger" or Type(value) = "Integer")
end function

function IsFloat(value as dynamic) as boolean
    return IsValid(value) and (GetInterface(value, "ifFloat") <> invalid or (Type(value) = "roFloat" or Type(value) = "Float"))
end function

function IsDouble(value as dynamic) as boolean
    return IsValid(value) and (GetInterface(value, "ifDouble") <> invalid or (Type(value) = "roDouble" or Type(value) = "roIntrinsicDouble" or Type(value) = "Double"))
end function

function IsList(value as dynamic) as boolean
    return IsValid(value) and GetInterface(value, "ifList") <> invalid
end function

function IsArray(value as dynamic) as boolean
    return IsValid(value) and Type(value) = "roArray"
end function

function IsAssociativeArray(value as dynamic) as boolean
    return IsValid(value) and Type(value) = "roAssociativeArray"
end function

function IsString(value as dynamic) as boolean
    return IsValid(value) and GetInterface(value, "ifString") <> invalid
end function

function IsDateTime(value as dynamic) as boolean
    return IsValid(value) and (GetInterface(value, "ifDateTime") <> invalid or Type(value) = "roDateTime")
end function

function IsSGNode(value as dynamic) as boolean
    return IsValid(value) and (GetInterface(value, "ifSGNodeField") <> invalid or Type(value) = "roSGNode")
end function

function IsValid(value as dynamic) as boolean
    return Type(value) <> "<uninitialized>" and value <> invalid
end function

function IsInvalid(value as dynamic) as boolean
    return Type(value) = "<uninitialized>" or value = invalid
end function

function IsNonEmptyString(value as dynamic) as boolean
    return IsString(value) and value <> ""
end function

function defaultValueIfInvalid(default as object, unknown)
    if unknown = invalid then return default
    return unknown
end function

function getDeviceModel()
    di = CreateObject("roDeviceInfo")
    return di.getModel()
end function

function getDeviceName()
    di = CreateObject("roDeviceInfo")
    return di.GetModelDisplayName()
end function

function getLocale()
    di = CreateObject("roDeviceInfo")
    return di.GetCurrentLocale()
end function

function toBase64String(object) as string
    json = FormatJson(object)
    byteArray = CreateObject("roByteArray")
    byteArray.FromAsciiString(json)
    return byteArray.ToBase64String()
end function

function fromBase64String(base64String as string) as object
    byteArray = CreateObject("roByteArray")
    byteArray.FromBase64String(base64String)
    asciString = byteArray.ToAsciiString()
    json = ParseJson(asciString)
    return json
end function

function dateFromISOString(dateString)
    dateTime = CreateObject("roDateTime")
    dateTime.FromISO8601String(dateString)
    return dateTime
end function

function getSizeMaskGroupWith(size) as object
    deviceInfo = CreateObject("roDeviceInfo")
    resolution = deviceInfo.GetUIResolution()
    if resolution.name = "HD"
        size[0] = size[0] * 2 / 3
        size[1] = size[1] * 2 / 3
        return size
    end if
    return size
end function

function getSize(size) as object
    deviceInfo = CreateObject("roDeviceInfo")
    resolution = deviceInfo.GetUIResolution()
    if resolution.name = "HD"
        size = size * 2 / 3
        return size
    end if
    return size
end function

sub getLanguage() as string
    di = CreateObject("roDeviceInfo")
    locale = di.GetCurrentLocale().split("_")
    return locale[0]
end sub

sub getWidthScreen() as object
    di = CreateObject("roDeviceInfo")
    resolution = di.GetUIResolution()
    return resolution.width
end sub

sub getHeightScreen() as object
    di = CreateObject("roDeviceInfo")
    resolution = di.GetUIResolution()
    return resolution.height
end sub

sub getMediumFont(size = 25) as object
    font = CreateObject("roSGNode", "Font")
    customFont = getFont("Medium")
    if IsValid(customFont)
        font.uri = font.uri
    else
        font.uri = "pkg:/components/fonts/Medium.otf"
    end if
    font.size = size
    return font
end sub

sub getBoldFont(size = 25) as object
    font = CreateObject("roSGNode", "Font")
    customFont = getFont("Bold")
    if IsValid(customFont)
        font.uri = customFont.uri
    else
        font.uri = "pkg:/components/fonts/Bold.otf"
    end if
    font.size = size
    return font
end sub

sub convertStrToInt(value) as object
    if IsString(value) then return value.toInt()
    return value
end sub

sub convertIntToStr(value) as object
    if IsInteger(value) then return value.toStr()
    return value
end sub

sub getFont(typeFont) as object
    if isInvalid(m.global.fonts) then return invalid

    for each font in m.global.fonts
        if IsValid(font.type) and font.type = typeFont
            if font.uri = "pkg:/<font path>.otf" or font.uri = "" then return invalid
            return font
        end if
    end for 

    return invalid
end sub

sub getRegularFont(size = 25) as object
    font = CreateObject("roSGNode", "Font")
    customFont = getFont("Regular")
    if IsValid(customFont)
        font.uri = font.uri
    else
        font.uri = "pkg:/components/fonts/Regular.otf"
    end if
    font.size = size
    return font
end sub

sub validationUsername(username) as object
    regexUsername = CreateObject("roRegex", "[`!@#$%^&*()+\=\[\]{};:\\|,.<>\/?~]", "i")
    isMatchUsername = regexUsername.isMatch(username)

    if username.len() < 30 and username.len() > 3 then isMatchUsername = true
    if username.len() < 3 then isMatchUsername = false
    return isMatchUsername
end sub

sub getPercent(percent) as object
    strPercent = percent.toStr().split(".")
    if strPercent.count() > 1
        return (strPercent[0] + "." + strPercent[1].left(2) + "%").replace("-", "")
    else
        return (strPercent[0] + "%").replace("-", "")
    end if
end sub

sub getImageWithName(name) as object
    if IsInvalid(name) then name = ""
    return "https://media2.inthegame.io" + name
end sub

sub configureTimer(duration, repeat) as object
    timer = CreateObject("roSGNode", "Timer")
    timer.duration = duration
    timer.repeat = repeat
    return timer
end sub

sub getScreenWidth() as integer
    di = CreateObject("roDeviceInfo")
    displaySize = di.GetDisplaySize()
    return displaySize.w
end sub

sub getScreenHeight() as integer
    di = CreateObject("roDeviceInfo")
    displaySize = di.GetDisplaySize()
    return displaySize.h
end sub

sub getTime(seconds) as object

    minute = seconds / 60
    hour = minute / 60

    if hour > 1
        return [hour.toStr().split(".")[0], "h"]
    else if minute > 1
        a = gmdate(seconds)
        return [minute.toStr().split(".")[0], "m"]
    else
        return [seconds.toStr().split(".")[0], "sec"]
    end if
end sub


function gmdate(seconds as dynamic) as dynamic
    a = seconds
    b = 60
    c = Fix(a / b)
    sec = a - b * c


    a = Fix(a / 60)
    b = 60
    c = Fix(a / b)
    minute = a - b * c

    a = Fix(a / 60)
    b = 60
    c = Fix(a / b)
    hour = a - b * c

    if hour > 9
        hour = hour.toStr()
    else
        hour = "0" + hour.toStr()
    end if

    if minute > 0
        return minute.toStr() + "m " + sec.toStr() + "sec"
    else 
        return sec.toStr()
    end if
end function