--[[
# DESCRIPTION

Same functionalites of the https://github.com/joabeslopes/Reaper-scripts-multitrack-creation/blob/main/Scripts/insertMultipleFiles.lua script, but this time you just want to add some musics to the project, instead of all the musics.
How do you do that? You create a file named "musics.txt", and put inside it the names of the folders that you want to pull the instruments, separating by line breaks.
You don't need to write the exact folder name, just the enough to the computer find it.

## Example of content:
Folder 1
second_folder
THIRD FOLDER

* Author: Joabe Lopes
* Github repo: https://github.com/joabeslopes/Reaper-scripts-multitrack-creation/
* Licence: GPL v3
* Extensions required: None
]]
--[[
  * Changelog:
  * v1.2 (2023-11-15)
    Add MacOS support

  * v1.1 (2023-11-15)
    Improve logic and clean code
  
  * v1.0 (2023-07-25)
    Initial release

]]

-- adjust this table according to your needs
searchTable = { {"cli",0,true},{"regencia",2},{"guia"},{"bass"},{"baixo"},{"guita"},{"vio"},{"perc"},{"sanf"},{"acordeon"},{"key"},{"tecla"},{"piano"},{"org"},{"fx"},{"sax"},{"trompete"} }



OSName = reaper.GetOS()

-- read all folder content and register it in an array
function readFolderContent(folderPath)

    folderContent = ""

    if (OSName == "Other" or OSName == "OSX64") then -- Linux or MacOS
        openedFolder = io.popen('ls "'..folderPath..'"', 'r')
        folderContent = openedFolder:read('*all')
        openedFolder:close()
    elseif (OSName == "Win64" or OSName == "Win32") then -- Windows
        openedFolder = io.popen('dir /b "'..folderPath..'"', 'r')
        folderContent = openedFolder:read('*all')
        openedFolder:close()
    end

    return folderContent

end

-- split a big string into an array of strings, separated by the line breaks ( \n )
function splitString(bigString)
    stringArray = {}
    for str in string.gmatch(bigString, "[^\n]+") do
        table.insert(stringArray, str)
    end
    return stringArray
end

-- search for the file and it's corresponding track
function regexFullSearch(musicPath, fileName, regex, trackFolder)
    if string.find(fileName, string.upper(regex)) then
        if string.find(fileName, ".*SOLO.*") then
            temp = string.sub(fileName, string.find(fileName, ".*SOLO.*"))
            if string.find(temp, ".*_R.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*_R.*"))
                correctTrackNumber = trackFolder + 4
            elseif string.find(temp, ".*_2.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*_2.*"))
                correctTrackNumber = trackFolder + 4
            elseif string.find(temp, ".*%pR.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*%pR.*"))
                correctTrackNumber = trackFolder + 4
            else
                audioPath = musicPath..temp
                correctTrackNumber = trackFolder + 3
            end
        elseif string.find(fileName, ".*BASE.*") then
            temp = string.sub(fileName, string.find(fileName, ".*BASE.*"))
            if string.find(temp, ".*_R.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*_R.*"))
                correctTrackNumber = trackFolder + 2
            elseif string.find(temp, ".*%pR.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*%pR.*"))
                correctTrackNumber = trackFolder + 2
            elseif string.find(temp, ".*_2.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*_2.*"))
                correctTrackNumber = trackFolder + 2
            else
                audioPath = musicPath..temp
                correctTrackNumber = trackFolder + 1
            end
        elseif string.find(fileName, ".*_L.*") then
            audioPath = musicPath .. string.sub(fileName, string.find(fileName, ".*_L.*"))
            correctTrackNumber = trackFolder + 1
        elseif string.find(fileName, ".*%pL.*") then
            audioPath = musicPath..string.sub(fileName, string.find(fileName, ".*%pL.*"))
            correctTrackNumber = trackFolder + 1
        elseif string.find(fileName, ".*_R.*") then
            audioPath = musicPath..string.sub(fileName, string.find(fileName, ".*_R.*"))
            correctTrackNumber = trackFolder + 2
        elseif string.find(fileName, ".*%pR.*") then
            audioPath = musicPath..string.sub(fileName, string.find(fileName, ".*%pR.*"))
            correctTrackNumber = trackFolder + 2

        else
            audioPath = musicPath..string.sub(fileName, string.find(fileName, string.upper(regex)))
            correctTrackNumber = trackFolder
        end
    
    elseif string.find(fileName, regex) then

        if string.find(fileName, ".*solo.*") then
            temp = string.sub(fileName, string.find(fileName, ".*solo.*"))
            if string.find(temp, ".*_R.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*_R.*"))
                correctTrackNumber = trackFolder + 4
            elseif string.find(temp, ".*_r.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*_r.*"))
                correctTrackNumber = trackFolder + 4
            elseif string.find(temp, ".*%pR.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*%pR.*"))
                correctTrackNumber = trackFolder + 4
            elseif string.find(temp, ".*%pr.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*%pr.*"))
                correctTrackNumber = trackFolder + 4
            elseif string.find(temp, ".*_2.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*_2.*"))
                correctTrackNumber = trackFolder + 4
            else
                audioPath = musicPath..temp
                correctTrackNumber = trackFolder + 3
            end
        elseif string.find(fileName, ".*base.*") then
            temp = string.sub(fileName, string.find(fileName, ".*base.*"))
            if string.find(temp, ".*_R.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*_R.*"))
                correctTrackNumber = trackFolder + 2
            elseif string.find(temp, ".*_r.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*_r.*"))
                correctTrackNumber = trackFolder + 2
            elseif string.find(temp, ".*%pR.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*%pR.*"))
                correctTrackNumber = trackFolder + 2
            elseif string.find(temp, ".*%pr.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*%pr.*"))
                correctTrackNumber = trackFolder + 2
            elseif string.find(temp, ".*_2.*") then
                audioPath = musicPath..string.sub(temp, string.find(temp, ".*_2.*"))
                correctTrackNumber = trackFolder + 2
            else
                audioPath = musicPath..temp
                correctTrackNumber = trackFolder + 1
            end
        elseif string.find(fileName, ".*_L.*") then
            audioPath = musicPath .. string.sub(fileName, string.find(fileName, ".*_L.*"))
            correctTrackNumber = trackFolder + 1
        elseif string.find(fileName, ".*_l.*") then
            audioPath = musicPath..string.sub(fileName, string.find(fileName, ".*_l.*"))
            correctTrackNumber = trackFolder + 1
        elseif string.find(fileName, ".*%pL.*") then
            audioPath = musicPath..string.sub(fileName, string.find(fileName, ".*%pL.*"))
            correctTrackNumber = trackFolder + 1
        elseif string.find(fileName, ".*%pl.*") then
            audioPath = musicPath..string.sub(fileName, string.find(fileName, ".*%pl.*"))
            correctTrackNumber = trackFolder + 1
        elseif string.find(fileName, ".*_R.*") then
            audioPath = musicPath..string.sub(fileName, string.find(fileName, ".*_R.*"))
            correctTrackNumber = trackFolder + 2
        elseif string.find(fileName, ".*_r.*") then
            audioPath = musicPath..string.sub(fileName, string.find(fileName, ".*_r.*"))
            correctTrackNumber = trackFolder + 2
        elseif string.find(fileName, ".*%pR.*") then
            audioPath = musicPath..string.sub(fileName, string.find(fileName, ".*%pR.*"))
            correctTrackNumber = trackFolder + 2
        elseif string.find(fileName, ".*%pr.*") then
            audioPath = musicPath..string.sub(fileName, string.find(fileName, ".*%pr.*"))
            correctTrackNumber = trackFolder + 2
        else
            audioPath = musicPath..string.sub(fileName, string.find(fileName, regex))
            correctTrackNumber = trackFolder
        end
    end

    return audioPath, correctTrackNumber
end

-- insert the audio files in the project
function insertAudioTake(audioPath, trackNumber, folderName)
    if folderName then
        reaper.AddProjectMarker(0, false, reaper.GetCursorPosition(), 0, folderName, -1)
    end
    track = reaper.GetTrack(0, trackNumber)
    reaper.SetOnlyTrackSelected(track)
    reaper.InsertMedia(audioPath, 0)

end

-- search the corresponding folder of the track and adjust it in the search table
function fillSearchTable(searchTable)
    for i = 1, reaper.CountTracks(0) do
        track = reaper.GetTrack(0,i-1)
        nothing, trackName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        for j =1, #searchTable do
            nameSearch = string.upper(searchTable[j][1])
            if string.find(trackName, ".*"..nameSearch..".*") then
                searchTable[j][2] = i
            end
        end
    end
end

-- get the musics.txt file
function getNewMusicsFileProject()

    local path = reaper.GetProjectPath()
    if (OSName == "Other" or OSName == "OSX64") then -- Linux or MacOS
  
      folder = io.popen('ls "'..path..'"', 'r')
      folderItems = splitString(folder:read("a"))
      folder:close()
      for f=1, #folderItems do
        if string.find(folderItems[f], "musics%ptxt") then
          musicsTextfile = path.."/musics.txt"
          return musicsTextfile
        end
      end

    elseif (OSName == "Win64" or OSName == "Win32") then -- Windows
    
      folder = io.popen('dir /b "'..path..'"', 'r')
      folderItems = splitString(folder:read("a"))
      folder:close()
      for f=1, #folderItems do
        if string.find(folderItems[f], "musics%ptxt") then
          musicsTextfile = path.."\\musics.txt"
          return musicsTextfile
        end
      end
    end
  
end

-- read the content of the text file
function openTextFile(filePath)
  
      file = io.open(filePath, 'r')
      local fileContent = splitString(file:read("a"))
      file:close()
      return fileContent
  
end


---------------------- Main function ----------------------

-- get the musics file
newMusics = openTextFile(getNewMusicsFileProject())

if newMusics then

    -- correct the search table
    fillSearchTable(searchTable)


-- insert the media files in the project
    projectPath = reaper.GetProjectPath()

    readFolders = readFolderContent(projectPath)
    if readFolders then
        foldersNames = splitString(readFolders)

            for folder = 1, #foldersNames do

                for new =1, #newMusics do

                    if string.find(foldersNames[folder]:upper(), ".*"..newMusics[new]:upper()..".*" ) then

                        musicPath = projectPath.. '/' ..foldersNames[folder].. '/'
                        allFiles = readFolderContent(musicPath)
                        filesNames = splitString(allFiles)

                        for file = 1, #filesNames do
                           if string.find(filesNames[file], ".*%pwav$") or string.find(filesNames[file], ".*%pmp3$") then --select only audio files (.wav or .mp3)

                                for s=1, #searchTable do
                                    regex = ".*"..searchTable[s][1]..".*"
                                    trackFolder = searchTable[s][2]
                                    haveProjMarker = searchTable[s][3]
                                    if string.find(filesNames[file]:upper(),regex:upper()) then
                                        audioPath, trackNumber = regexFullSearch(musicPath, filesNames[file], regex, trackFolder)

                                        if haveProjMarker then
                                            insertAudioTake(audioPath, trackNumber, foldersNames[folder])
                                        else
                                            insertAudioTake(audioPath, trackNumber)
                                        end

                                    end
                                end

                            end
                        end
                    end
                end
            end
        else
            reaper.ShowConsoleMsg("Folder read error")
        end


else
    reaper.ShowConsoleMsg("File \"musics.txt\" not found.\nPlease create it on the project folder.")
end